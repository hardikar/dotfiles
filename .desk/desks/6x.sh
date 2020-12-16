# 6x.sh
#
# Description: environment for gpdb 6x development
#

GPDB_PATH=$HOME/workspace/gpdb6
GPDB_TITLE="6X"

cd "${GPDB_PATH}"

source ".build/greenplum_path.sh"
source "gpAux/gpdemo/gpdemo-env.sh"

# Keep at the end to let common aliases work
source "$HOME/.dotfiles/gpdb/gpdb_env.bash"
