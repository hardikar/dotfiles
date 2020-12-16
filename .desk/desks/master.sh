# gpdb_master.sh
#
# Description: environment for gpdb master development
#

GPDB_PATH=$HOME/workspace/gpdb
GPDB_TITLE="master"

cd "${GPDB_PATH}"

source ".build/greenplum_path.sh"
source "gpAux/gpdemo/gpdemo-env.sh"

# Keep at the end to let common aliases work
source "$HOME/.dotfiles/gpdb/gpdb_env.bash"
