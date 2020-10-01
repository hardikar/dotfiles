ORCA_INSTALL_PATH=/usr/local
ORCA_PREFIX=gporca

export PGHOST=localhost

GPDB_WORKSPACE=$HOME/workspace

echo -ne "\e]1;${GPDB_TITLE}\a"

function finish() {
	echo -ne "\e]1;\a"
}

trap finish EXIT

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
 
use_orca () {
	local ver
  ver="$1"
  echo_and_run() { echo "$@" ; "$@" ; }
	
  echo_and_run export CONF_INC="${ORCA_INSTALL_PATH}/$1/include"
  echo_and_run export CONF_LIB="${ORCA_INSTALL_PATH}/$1/lib"
  echo_and_run export CONF_RPATH="${ORCA_INSTALL_PATH}/$1/lib"
}

alias cdregress="cd ${GPDB_PATH:-.}/src/test/regress"
alias cdminidumps="cd $MASTER_DATA_DIRECTORY/minidumps"

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
