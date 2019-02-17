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

daily_restic_backup_forget_args=${daily_restic_backup_forget_args:-""}

restic_forget() {
  su -l "${daily_restic_backup_user}" << EOF
restic forget \
  --repo "${daily_restic_backup_backend}" \
  --password-file "${daily_restic_backup_passfile}" \
  --host `hostname` \
  --group-by host,tags \
  ${daily_restic_backup_forget_args}
EOF
}

case "${daily_restic_backup_enable}" in
  [Yy][Ee][Ss])
    echo
    echo "Cleaning up backups using restic-forget:"

    if test -z "${daily_restic_backup_passfile}" || \
        test -z "${daily_restic_backup_backend}"; then
      echo "Missing configuration for either passfile or backend. Quitting."
      exit 1
    fi

    restic_forget
    ;;
esac
