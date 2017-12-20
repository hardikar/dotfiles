ORCA_INSTALL_PATH=/usr/local/
ORCA_PREFIX=gporca

GPDB_WORKSPACE=$HOME/workspace
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
  releng_version=$(grep 'orca' ${relengfile} | grep -o '\d\+\.\d\+.\d\+')

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
