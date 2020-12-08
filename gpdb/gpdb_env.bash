ORCA_INSTALL_PATH=/usr/local
ORCA_PREFIX=gporca

export PGHOST=localhost

GPDB_WORKSPACE=$HOME/workspace
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

configure_gpdb_old() {
	set -x
	CC="ccache cc" CXX="ccache c++" LDFLAGS="-rpath ${CONF_RPATH}" \
		./configure \
		--with-includes="${CONF_INC}:/usr/local/include" \
		--with-libraries="${CONF_LIB}:/usr/local/lib" \
		--with-python --with-perl --with-libxml --enable-orca \
		--disable-gpfdist --disable-gpcloud \
		--enable-debug \
		--enable-depend \
		"$@" \
		--prefix="$(pwd)/.build"
	set +x
}

configure_gpdb() {
	set -x
	CC="ccache cc" CXX="ccache c++"\
		./configure \
		--with-includes="/usr/local/include" \
		--with-libraries="/usr/local/lib" \
		--with-python --with-perl --with-libxml --enable-orca \
		--disable-gpfdist --disable-gpcloud \
		--enable-debug \
		--enable-depend \
		"$@" \
		--prefix="$(pwd)/.build"
	set +x
}

GPDB4_PATH="$HOME/workspace/gpdb4"
GPDB5_PATH="$HOME/workspace/gpdb5"
GPDB6_PATH="$HOME/workspace/gpdb6"
GPDB_MASTER_PATH="$HOME/workspace/gpdb"

pick_gpdb () {
	if [ "$1" = "4x" ]; then
		echo "${GPDB4_PATH}"
	elif [ "$1" = "5x" ]; then
		echo "${GPDB5_PATH}"
	elif [ "$1" = "6x" ]; then
		echo "${GPDB6_PATH}"
	elif [ "$1" = "master" ]; then
		echo "${GPDB_MASTER_PATH}"
	fi
}

gpcd () {
	path="$(pick_gpdb $1)"
	cd "$path"
}

gpsource () {
	path="$(pick_gpdb $1)"
	source "$path/.build/greenplum_path.sh"
	source "$path/gpAux/gpdemo/gpdemo-env.sh"
}

gpdb_start () {
	gpsource "$1"
	gpstart -a
}

gpdb_stop () {
	gpsource "$1"
	gpstop -a
}

start4x () { gpdb_start 4x; }
start5x () { gpdb_start 5x; }
start6x () { gpdb_start 6x; }
startmaster () { gpdb_start master; }

stop4x () { gpdb_stop 4x; }
stop5x () { gpdb_stop 5x; }
stop6x () { gpdb_stop 6x; }
stopmaster () { gpdb_stop master; }

use_orca () {
	local ver
  ver="$1"
  echo_and_run() { echo "$@" ; "$@" ; }
	
  echo_and_run export CONF_INC="${ORCA_INSTALL_PATH}/$1/include"
  echo_and_run export CONF_LIB="${ORCA_INSTALL_PATH}/$1/lib"
  echo_and_run export CONF_RPATH="${ORCA_INSTALL_PATH}/$1/lib"
}

_use_orca_complete()
{
  _script_commands=$(ls "${ORCA_INSTALL_PATH}" | grep gporca)

  local cur
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "${_script_commands}" -- ${cur}) )

  return 0
}
complete -o nospace -F _use_orca_complete use_orca


make_gpdb_project()
{
  local projdir
  projdir="$1"

  if [[ -z "$projdir" ]]; then
    echo "  ERROR: Usage $0 <project-dir>"
    return 1
  fi

  if [[ -d "${GPDB_WORKSPACE}/$projdir" ]]; then
    echo "  ERROR: Usage ${GPDB_WORKSPACE}/$projdir already exists!"
    return 1
  fi

  mkdir -p "${GPDB_WORKSPACE}/$projdir"
  pushd "${GPDB_WORKSPACE}/$projdir"

  git clone git@github.com:hardikar/gpdb.git
  git clone git@github.com:hardikar/gporca.git
  git clone https://github.com/d/bug-free-fortnight

  git -C gpdb remote add upstream git@github.com:greenplum-db/gpdb.git
  git -C gpdb remote update
  git -C gporca remote add upstream git@github.com:greenplum-db/gporca.git
  git -C gporca remote update

  cp ${SOURCE_DIR}/CMakeLists.txt.all ./CMakeLists.txt
  cp ${SOURCE_DIR}/CMakeLists.txt.gpdb gpdb/CMakeLists.txt

  mkdir build.xcode
  pushd build.xcode

  cmake -G Xcode ..

  popd
  popd
}

verify_version()
{
  file1="config/orca.m4"
  m4_version_1=$(grep 'GPORCA_VERSION_STRING' ${file1} | grep -o '\d\+\.\d\+.')
  m4_version_2=$(grep 'ORCA version' ${file1} | grep -o '\d\+\.\d\+.')

  if [[ ${m4_version_1} != ${m4_version_2} ]]; then
    echo "Mismatch found in ${file1}: \"${m4_version_1}\" and \"${m4_version_2}\"" 
    error=$(($error + 1))
  fi

  file2="configure"
  configure_version_1=$(grep 'GPORCA_VERSION_STRING' ${file2} | grep -o '\d\+\.\d\+.')
  configure_version_2=$(grep 'ORCA version' ${file2} | grep -o '\d\+\.\d\+.')

  if [[ ${configure_version_1} != ${configure_version_2} ]]; then
    echo "Mismatch found in ${file2}: \"${configure_version_1}\" and \"${configure_version_2}\"" 
    error=$(($error + 1))
  fi

  if [[ ${configure_version_1} != ${m4_version_1} ]]; then
    echo "Mismatch found between ${file1} and ${file2} : \"${configure_version_1}\" and \"${m4_version_1}\"" 
    error=$(($error + 1))
  fi

  # depends/conanfile_orca.txt | 2 +-
  conanfile="depends/conanfile_orca.txt"
  conan_version=$(grep 'orca' ${conanfile} | grep -o '\d\+\.\d\+.\d\+')

  if ! [[ ${conan_version} =~ ${m4_version_1} ]]; then
    echo "Mismatch found in ${conanfile} and ${file1}: \"${conan_version}\" and \"${m4_version_1}\"" 
    error=$(($error + 1))
  fi

  relengfile="gpAux/releng/releng.mk"
  if [ ! -e "${relengfile}" ]; then
		# also check in concourse file (6x onwards)
    relengfile="concourse/tasks/compile_gpdb.yml"
  fi
  releng_version=$(grep -i 'ORCA' ${relengfile} | grep -o '\d\+\.\d\+.\d\+')

  if [[ ${conan_version} != ${releng_version} ]]; then
    echo "Mismatch found in ${conanfile} and ${relengfile}: \"${conan_version}\" and \"${releng_version}\"" 
    error=$(($error + 1))
  fi

  if [[ ! $error ]]; then
    echo "All files contain the version: ${conan_version} (i.e. ${m4_version_1}XXX)"
  else
    return $error
  fi
}

clean_gpopt()
{
	make -C src/backend/gpopt/ clean
}

latest_mdp_path()
{
	path="$MASTER_DATA_DIRECTORY/minidumps"/$(ls -t "$MASTER_DATA_DIRECTORY/minidumps" | head -1)
	if [[ -f $path ]]; then
		echo "$path"
	fi
}

latest_mdp()
{
	if [[ -f $(latest_mdp_path) ]]; then
		xmllint --format $(latest_mdp_path)
	fi
}
