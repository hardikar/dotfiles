#!/bin/bash

# This is a work in progress! Use carefully
# TODO Add counters to report summary at the end

# Algorithm:
# Select the earliest acceptable local snapshot (based on age) -> L 
# if L does not exist :
#    L = earliest known local snapshot

# if L exists remotely :
#   E : most recent snapshot on local
#   zfs send -I L E | zfs recv
# else:
#   zfs send L | zfs recv
#   zfs send -I L E | ifs recv
# Destroy all old snapshots

set -e

# ================================================================================
# Configuration
# ================================================================================

# Time to live on the remote backup
ttl='3m'

# Mounting directory for remote backup
altroot="/media/offsite"

# Datasets (recursive) to back up
datasets=(
  zroot/warden
  zroot/ROOT/default
  zroot/usr/home
  tank/frodo
)

# ================================================================================
# Temporary storage for zfslist file
zfslist="/tmp/zfslist"

# ================================================================================


function report() {
  if [ '0' == "$?" ]; then
    printf 'ok\n'
  else
    printf 'error\n'
  fi
}

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

select_device() {
  devices=($(ls /dev/da[0-9]))
  if [ -z "$devices" ]; then
     # This is all I want to support for now.
     printf "No external drives found!\n"
     exit 1
  fi
  printf "Select the external drive :\n"
  select selected_dev in "${devices[@]}"; do
    break
  done
  dev="${selected_dev}.eli"

  printf "Mounting drive $dev ... "
  if [ -e $dev ]; then
    printf "already mounted\n"
  else
    geli attach ${selected_dev}
    if [ '0' == "$?" ]; then 
      printf "${selected_dev} attached successfully!\n"
    else
      printf "${selected_dev} attach failed!\n"
    fi
  fi
}

select_pool() {
  pools=($(zpool import | awk -F':' '/pool:/ { print $2 }' ))
  import=true
  if [ -z "$pools" ]; then
    printf "No importable pools found!\n"
    pools=($(zpool status | awk -F':' '/pool:/ { print $2 }' ))
    import=false
  fi
  
  printf "Select the offsite pool:\n"
  select pool in "${pools[@]}"; do
    break
  done
  printf "Selected pool: $pool; Importing now ... "
  if $import; then
    # -N            : Do not mount the datasets
    # -o altroot=<> : Change the root mountpoint (just incase we backed up /)
    zpool import -o -N -o altroot=${altroot} $pool ; report
  else
    printf "already imported\n"
  fi
}
  
detach_device_and_pool() {
  printf "Exporting pool $pool ... "
  zpool export $pool ; report

  printf "Unmounting drive $dev ... "
  geli detach ${dev} ; report
}


backup() {
  printf "\n\nCommencing backups ... \n"

  cutoff=$(date -v "-$ttl" '+%s')

  _datasets=()
  for dataset in ${datasets[@]}; do
    # Compute all the descendents and list them in reverse topological order
    for desc in $(zfs list -H -o name -S name -r ${dataset}); do
      _datasets+=($desc)
    done
  done

  # TODO How do we make sure there are no race conditions?
  for dataset in ${_datasets[@]}; do
    destdataset=$(echo $dataset | sed -e 's+^[^/]*/+'$pool'/+')

    # 1. Select the earliest acceptable local snapshot (based on age)

    # Notes:
    #  -H removes the header
    #  -p uses timestamps
    #  -S sorts by creation
    #  -t list only snapshots
    prev_local_snapshot=$(
      zfs list -H -p -o name,creation -S creation -d 1 -t snapshot -r ${dataset} |
      # Select the earliest local snapshot (daily/monthly) at or after $cutoff
      awk -v cutoff="$cutoff" ' \
        /daily|monthly/ { if ( $2 >= cutoff ) { chosen = $1 } } \
        END { print chosen }' |
      head -1 | cut -d'@' -f 2
    )

    # 2. Select the latest local snapshot to backup
    latest_local_snapshot=$(
      zfs list -H -o name -S creation -t snapshot -d 1 -r ${dataset} |
      head -1 | cut -d'@' -f 2
    )

    printf '\n\n'
    printf "================================================================================\n"
    printf "Backing up dataset $dataset to $destdataset...\n"
    printf "================================================================================\n"

    printf " > prev_local_snapshot: ${prev_local_snapshot:-none}\n"
    printf " > latest_local_snapshot: ${latest_local_snapshot:-none}\n"

    if [[ -z "${prev_local_snapshot}" || -z "${latest_local_snapshot}" ]]; then
      printf " > No local snapshots available to backup. Skipping this backup\n"
      continue
    fi

    # 3. Determine if prev_local_snapshot and latest_local_snapshot exists remotely
    prev_remote_snapshot=$(zfs list -H -o name -d 0 -r "$destdataset@$prev_local_snapshot" 2>/dev/null || true)
    latest_remote_snapshot=$(zfs list -H -o name -d 0 -r "$destdataset@$latest_local_snapshot" 2>/dev/null || true)

    printf " > prev_remote_snapshot: ${prev_remote_snapshot:-none}\n"
    printf " > latest_remote_snapshot: ${latest_remote_snapshot:-none}\n"

    printf "\n"


    if [ -z "${latest_remote_snapshot}" ]; then
      # Latest remote snapshot doesn't exist - we need to do backup

      if [ -z "${prev_remote_snapshot}" ]; then 
        printf " > No remote snapshot counterpart of ${prev_local_snapshot} found.\n"
        printf " > Performing FULL backup.\n\n"

        # Destroy all snapshots on remote
        # zfs list -H -o name -t snapshot -d 1 -r ${destdataset} |
        #   while read snap; do
        #     zfs destroy -v $snap
        #   done

        # Send the first full stream
        zfs send -P "${dataset}@${prev_local_snapshot}" | zfs recv -uvdF "${pool}"

        # Send the remaining incremental streams
        zfs send -P -I "${dataset}@${prev_local_snapshot}" "${dataset}@${latest_local_snapshot}" | zfs recv -uvdF "${pool}"
      else
        printf " > Remote snapshot counterpart of ${prev_local_snapshot} found.\n"
        printf " > Performing INCREMENTAL backup.\n\n"

        # Send the incremental streams
        zfs send -P -I "${dataset}@${prev_local_snapshot}" "${dataset}@${latest_local_snapshot}" | zfs recv -uvdF "${pool}"
      fi
    else
        printf " > Latest local snapshot exists remotely. No backup necessary.\n"
        continue
    fi
  done
}

cleanup() {
  printf '\n\n'
  printf "================================================================================\n"
  printf "Cleaning up ... \n"
  printf "================================================================================\n"

  # Destroy all snapshots on remote before $cutoff to save space
  # We could do this automatically but I don't want to destroy snapshots willy nilly
  printf "" > ${zfslist}
  for dataset in ${_datasets[@]}; do
    destdataset=$(echo $dataset | sed -e 's+^[^/]*/+'$pool'/+')
    zfs list -H -p -o name,creation -t snapshot -d 1 -r ${destdataset} |
      awk -v cutoff="$cutoff" '{ if ( $2 < cutoff ) print $1 }' >> ${zfslist}
  done

  if [ -s ${zfslist} ]; then
    # ${zfslist} is not empty
    printf "Found datasets on $pool that are old and may be deleted:\n"
    cat ${zfslist}
    printf "\n"

    if confirm "Delete these snapshots ? (y/n)"; then
      printf "\n"
      cat ${zfslist} |
        while read snap; do
          zfs destroy -v "$snap"
        done
    else
      printf "Old datasets not deleted. You can find the list at ${zfslist}.\n"
    fi
  fi
  printf "\n"

  confirm "Detach and unmount pool: $pool? (y/n)" && detach_device_and_pool || true
}

main() {
	select_device
  printf "\n"
  select_pool
  printf "\n"
  pool=offsite
  dev="/dev/da0.eli"
  confirm "Continue with pool: $pool & device: $dev? (y/n)" && backup
  printf "\n\nBackups complete!\n"
  printf "\n"
  cleanup
  printf 'Done.\n'
}

main "$@"

