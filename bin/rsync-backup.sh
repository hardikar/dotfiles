#! /bin/bash

# Local and remote (over SSH) backups using rsync & zfs snapshots
# The basic algorithm looks like this : 
#   for each dataset in datasets
#     Find the latest local snapshot.
#     rsync to backup dataset using the source full path 
#     make a new remote snapshot @ <end-of-rsync-time>
#
# Caveats
#   1. Combines multiple datasets into one
#   2. Doesn't do deduplication
#   3. Doesn't handle interrupted backups.
#
# Notes:
# * Only make a snapshot if the sync finished
# * TODO Allow auto-mounting?
# * TODO Implement a pruning policy
#
# References
# [1] https://www.freebsd.org/cgi/man.cgi?query=rsync&sektion=1
# [2] https://www.freebsd.org/cgi/man.cgi?query=zfs&sektion=8


set -u

repo="/offsite/rsync-backup"
repo_dataset="offsite/rsync-backup"
exclude_file="/tmp/rsync_excludes"
snapshot_tag="rsync_backup"

datasets=(
  "tank/frodo/documents"
)

dataset_latest_snapshot() {
  dataset="$1"
  zfs list -H -o name -S creation -t snapshot -d 1 -r ${dataset} |
      head -1 | cut -d'@' -f 2
}

dataset_mountpoint() {
  dataset=$1
  zfs get -H mountpoint "$dataset" | cut -f 3
}

setup_excludes() {
  cat > "${exclude_file}" <<EOF
.TemporaryItems/
.DS_Store
._*
EOF
   
}

main() {
  setup_excludes

  # Compute all the descendents (uses bash 4 features)
  declare -A alldatasets
  for dataset in "${datasets[@]}"; do
    for desc in $(zfs list -H -o name -r "${dataset}"); do
      alldatasets["$desc"]=1
    done
  done
  datasets=()
  for dataset in "${!alldatasets[@]}"; do
    mountpt=$(dataset_mountpoint "$dataset")
    if [[ "${mountpt}" == "none" ]]; then
      printf "Skipping ${dataset} : not mounted\n"
    else
      datasets+=("${dataset}")
    fi
  done

  printf "================================================================================\n"

  ndatasets="${#datasets[@]}"
  printf "%d valid datasets found; commencing backups for :\n" $ndatasets
  for dataset in "${datasets[@]}"; do
    printf " . ${dataset}\n"
  done

  printf "================================================================================\n"

  iter=1
  for dataset in "${datasets[@]}"; do
    src=$(dataset_mountpoint "$dataset")
    latest_snapshot=$(dataset_latest_snapshot "$dataset")
    src_snapshot="${src}/.zfs/snapshot/${latest_snapshot}"
    dest="${repo}/${src}"

    printf "[%d/%d] Backing up ${src} to ${dest}\n" $iter $ndatasets

    if [[ -z "${latest_snapshot}" ]]; then
      printf "No snapshot found; skipping."
      continue
    fi
    printf "Latest snapshot found : ${latest_snapshot}\n"

    mkdir -p "$dest"
    
    # -aH                Keep all attributes of the files
    # --delete           Delete remote files if deleted locally
    # --numeric-ids      Use numeric user/group ids
    # --partial          Keep partial files for faster resumes
    # --relative         Remember paths on local
    # --one-file-system  Don't cross file system boundary
    # --info=progress2   Aggregate stats
    rsync -aH \
      --delete \
      --numeric-ids \
      --exclude-from="${exclude_file}" \
      --partial \
      --relative \
      --one-file-system \
      --info=progress2 \
      "${src_snapshot}/" \
      "${dest}/"

    rc=$?
    
    printf "rsync returned with code $rc\n"
    if [[ $rc == 0 || $rc == 3 ]]; then
      printf "Success : taking a snapshot.\n"
      snapshot_name="${repo_dataset}@${snapshot_tag}_$(date +%Y-%m-%d_%H.%M.%S)"
      if zfs snapshot "${snapshot_name}"; then
        printf " . Done ${snapshot_name}\n"
      else
        printf " . Failed!"
      fi
    fi

    printf "================================================================================\n"

    iter=$(($iter + 1 ))
  done
}


main "$@"
