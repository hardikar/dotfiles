# 4x.sh
#
# Description: environment for gpdb 4x development
#

GPDB_PATH=$HOME/workspace/gpdb4

cd "${GPDB_PATH}"

source ".build/greenplum_path.sh"
source "gpAux/gpdemo/gpdemo-env.sh"

# Keep at the end to let common aliases work
source "$HOME/dotfiles/gpdb/gpdb_env.bash"
