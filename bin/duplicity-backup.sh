#! /bin/bash
#
# Duplicity backup script based on latest ZFS snapshot
# Requires:
#  - bash
#  - duplicity
#  - zfSnap (to generate daily/monthly snapshots)
#  - write access to /tmp for exclude files
# If using s3 remote, it expected that AWS creditials and configs are set up
# correct in ~/.aws home directory of the user running this script.
# See http://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html.
#


set -u
set -o pipefail

#
# Configuration - To be moved to a config file later
#

duplicity_backup_fs="
  tank/usr/hosting/wiki
"
duplicity_backup_recursive_fs="
  tank/usr/hosting
  tank/usr/home
"
duplicity_backup_backend="s3+http://remington-backups"
duplicity_backup_options="--s3-use-multiprocessing"
duplicity_backup_gpg_options="--cipher-algo AES256"
duplicity_backup_full_if_older_than="1M"
duplicity_backup_excludes="
**/.TemporaryItems/
**/.DS_Store
**/._*
**/Plex Media Server/Cache
**/Plex Media Server/Media
**/*.core
**/.cache
"

#
# Implementation
#

dataset_latest_snapshot() {
  dataset="$1"
  zfs list -H -o name -S creation -t snapshot -d 1 -r ${dataset} |
      head -1 | cut -d'@' -f 2
}

dataset_mountpoint() {
  dataset=$1
  zfs get -H mountpoint "$dataset" | cut -f 3
}


main() {
  #
  # Determine datasets to backup first
  #
  datasets=()
  # Iterate non-recursive datasets
  for ds in ${duplicity_backup_fs[@]}; do
    mountpt=$(dataset_mountpoint "${ds}") || continue
    if [[ "${mountpt}" == "none" ]]; then
      printf "Warning : Skipping ${ds} : not mounted\n" >&2
      continue
    fi
    # OK valid dataset
    datasets+=("${ds}")
  done

  # Recurse into recursive datasets
  for recursive_ds in ${duplicity_backup_recursive_fs[@]}; do
    for ds in $(zfs list -H -o name -r ${recursive_ds}); do
      mountpt=$(dataset_mountpoint "${ds}") || continue
      if [[ "${mountpt}" == "none" ]]; then
        printf "Warning : Skipping ${ds} : not mounted\n" >&2
        continue
      fi
      # OK valid dataset
      datasets+=("${ds}")
    done
  done
  
  # Done!

  printf "================================================================================\n"
  datasets=($(printf "%s\n" "${datasets[@]}" | sort -u))
  ndatasets=${#datasets[@]}
  printf "%d valid datasets found; commencing backups for :\n" $ndatasets
  for dataset in ${datasets[@]}; do
    printf " . ${dataset}\n"
  done
  printf "================================================================================\n"

  #
  # Run duplicity backup for each dataset
  #

  iter=1
  for ds in ${datasets[@]}; do
    printf "[%d/%d] Backing up ${ds} from snapshot : " $iter $ndatasets

    mountpoint=$(dataset_mountpoint "$ds")
    latest_snapshot=$(dataset_latest_snapshot "$ds") && printf "${latest_snapshot}\n" \
      || print "No shapshot found; skipping" >&2
    src="${mountpoint}/.zfs/snapshot/${latest_snapshot}/./"

    run_duplicity "${ds}" "${src}"

    printf "================================================================================\n"
    iter=$(($iter + 1 ))
  done
  printf "DONE\n"
}

#
# Calls duplicity with appropriate arguments.
#   Uploads files from latest zfs snapshot of the dataset to a subfolder with
#   the same heirarchy as the dataset
#
run_duplicity() {
  ds="$1"
  src="$2"

  dest="${duplicity_backup_backend}/$ds"

  tmpfile=$(mktemp)
  echo "${duplicity_backup_excludes}" > $tmpfile
  
  export PASSPHRASE=$(cat ~/.passphrase)

  duplicity \
    --allow-source-mismatch \
    --gpg-options "${duplicity_backup_gpg_options}" \
    --exclude-other-filesystems \
    --exclude-filelist ${tmpfile} \
    --progress --progress-rate 60 \
    --full-if-older-than "${duplicity_backup_full_if_older_than}" \
    ${duplicity_backup_options} \
    "${src}" "${dest}"

  unset PASSPHRASE
}

main "$@"

