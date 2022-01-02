#! /usr/bin/env bash

set -o errexit -o errtrace -o pipefail -o nounset

function abspath() {
    if [[ ! -d "$1" ]]; then
        DIRNAME=$(dirname "$1")
    else
        DIRNAME="$1"
    fi
    echo $(cd $DIRNAME; pwd)
}

SRCDIR=`abspath $0`
DESTDIR="$HOME"
OPTIONS="-s $@"

declare -a FILES=(
	"$SRCDIR/.bash_profile"
	"$SRCDIR/.bashrc"
	"$SRCDIR/.zshrc"
	"$SRCDIR/.zsh"
	"$SRCDIR/.sh"

	"$SRCDIR/.tmux.conf"
	"$SRCDIR/.desk"

	"$SRCDIR/.gdbinit"
	"$SRCDIR/.gitconfig"
	"$SRCDIR/.gitignore_global"

	"$SRCDIR/.gvimrc"
	"$SRCDIR/.vimrc"
	"$SRCDIR/.vim"

	"$SRCDIR/.editrc"
	"$SRCDIR/.psqlrc"

	"$SRCDIR/.xprofile"
)

declare -a DIRS=(
	"$DESTDIR"/.config
)

function main() {
	for opt in "$@"; do
	    case "$opt" in
	    "-h"|"--help")
	        usage
	        exit 0
	        ;;
	    esac
	done

	set +o errexit
	for dir in ${DIRS[@]}; do
		exec_cmd "mkdir $dir"
	done

	for file in ${FILES[@]}; do
		exec_cmd "ln $OPTIONS $file $DESTDIR"
	done
	set -o errexit
}


function exec_cmd() {
	cmd="$1"
	echo -n "$cmd ..."
	ERR=$($cmd 2>&1 >/dev/null)
	if [ $? -eq 0 ]; then
		echo " ok"
	else
		echo "$ERR" | awk -F':' '{ print $NF }'
	fi
}

usage() {
	cat <<EOF
USAGE:
./setup_simlinks.sh [options]

[options]:
	The same options as from "man ln".
	Do not include -s, it is automatically added
EOF
}

main
