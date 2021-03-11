ORCA_INSTALL_PATH=/usr/local
ORCA_PREFIX=gporca

export PGHOST=localhost

GPDB_WORKSPACE=$HOME/workspace

echo -ne "\e]1;${GPDB_TITLE}\a"
echo -en "\033]0;${GPDB_TITLE}\a"

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

configure_gpdb_clang() {
	set -x
	CC="ccache clang" CXX="ccache clang++"\
		./configure \
		--with-includes="/usr/local/include" \
		--with-libraries="/usr/local/lib" \
		--with-python PYTHON=python3 \
		--with-perl --with-libxml \
		--enable-orca \
		--enable-orafce --enable-tap-tests \
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
		--with-python --with-perl --without-libxml --enable-orca \
		--disable-gpfdist --disable-gpcloud \
		--enable-debug \
		--enable-depend \
		"$@" \
		--prefix="$(pwd)/.build"
	set +x
}

configure_gpdb_official() {
	set -x
	CC="ccache cc" CXX="ccache c++" \
		./configure \
		--with-perl \
		--with-python PYTHON=python3 \
		--enable-gpcloud --with-libxml --enable-mapreduce \
		--enable-orafce --enable-tap-tests \
		--enable-orca \
		--with-openssl \
		--enable-debug \
		--prefix="$(pwd)/.build"
		"$@"
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

cdorca () {
  cd "${GPDB_PATH:-.}/src/backend/gporca/$1"
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

icg_diff_orca()
{
	orca_expect_file="expected/$1_optimizer.out"
	planner_expect_file="expected/$1.out"
	results_file="results/$1.out"

	if [[ ! -f "$orca_expect_file" ]]; then
		orca_expect_file="$planner_expect_file"
	fi

	vimdiff "$orca_expect_file" "$results_file"
}

icg_diff_planner()
{
	planner_expect_file="expected/$1.out"
	results_file="results/$1.out"

	vimdiff "$planner_expect_file" "$results_file"
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

setup_git_graft()
{
	git remote add old-orca git@github.com:Pivotal/gp-qp-orca.git
	git remote add old-gpos git@github.com:Pivotal/gp-qp-gpos.git
	git remote add hist-gpdb git@github.com:Pivotal/gp-gpdb-historical.git
	git remote add old-gpdb git@github.com:Pivotal/gp-qp.git

	git remote update

	git replace --graft 6b0e52beadd678c5 9de71fa31b2ab2d8 2f52d7260ceac8e5
	git replace --graft 18cd409afb75b6d5 7123bd8cb2884647
	git replace --graft 306cd19727f955ff f5555223b55418b7
	git replace --graft d089a971e2389dc5 cc881d1ef2de4961 5a8a7639ba576a2c
	git replace --graft 82e3ab04e691f4d3 346aff04be3311ce

	readonly OSS_GPOS=644d31318268f514
	readonly QP_GPOS=7d1b9b8772ee5f56
	readonly OSS_ORCA=76feb99efdc92bf2
	readonly QP_ORCA=ad3d9efd892fdbb4
	readonly QP_GPOS_ENGINF372=22e278c258f60e9b
	readonly QP_ORCA_ENGINF372=d8d3577a3e77ec14

	git replace --graft "${OSS_GPOS}" "${QP_GPOS}"
	git replace --graft "${OSS_ORCA}" "${QP_ORCA}"
	git replace --graft "${QP_GPOS_ENGINF372}" "${QP_ORCA_ENGINF372}~"
}
