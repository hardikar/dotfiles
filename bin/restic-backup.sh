#! /bin/sh
#
# Requirements:
#  - write access to /tmp for exclude files
# If using s3 backend, it is expected that a .aws/creditials file is already
# set up [1].
# See https://docs.aws.amazon.com/ses/latest/DeveloperGuide/create-shared-credentials-file.html.
#
# Enter configuration in /etc/periodic.conf
# Install in /usr/local/etc/periodic/daily/

if [ -r /etc/defaults/periodic.conf ]
then
    . /etc/defaults/periodic.conf
    source_periodic_confs
fi


daily_restic_backup_enable=${daily_restic_backup_enable:-"NO"}
daily_restic_backup_user=${daily_restic_backup_user:-"backup"}
daily_restic_backup_passfile=${daily_restic_backup_passfile:-""}
daily_restic_backup_backend=${daily_restic_backup_backend:-""}

daily_restic_backup_paths=${daily_restic_backup_paths:-""}
daily_restic_backup_excludes=${daily_restic_backup_excludes:-""}

daily_restic_backup_backup_args=${daily_restic_backup_backup_args:-""}


restic_backup() {

  EXCLUDES_FILE='.restic-excludes'
  PATHS_FILE='.restic-paths'

  su -l "${daily_restic_backup_user}" << EOF

echo "${daily_restic_backup_excludes}" > "${EXCLUDES_FILE}"

# Isolate paths that actually exist!
> ${PATHS_FILE}
echo "${daily_restic_backup_paths}" | while read f; do
  if test -n "\$f"; then
      echo "\$f" >> ${PATHS_FILE}
  fi
done
echo

restic backup \
  --repo "${daily_restic_backup_backend}" \
  --password-file "${daily_restic_backup_passfile}" \
  --exclude-file "${EXCLUDES_FILE}" \
  --files-from "${PATHS_FILE}" \
  ${daily_restic_backup_backup_args}
EOF

}
case "${daily_restic_backup_enable}" in
  [Yy][Ee][Ss])
    echo
    echo "Performing backups using restic-backup:"

    if test -z "${daily_restic_backup_paths}" || \
        test -z "${daily_restic_backup_passfile}" || \
        test -z "${daily_restic_backup_backend}"; then
      echo "Missing configuration for either paths, passfile or backend. Quitting."
      exit 1
    fi

    restic_backup
    ;;
esac
