#! /usr/bin/env bash

function abspath(){
    if [[ ! -d "$1" ]]; then
        DIRNAME=$(dirname "$1")
    else
        DIRNAME="$1"
    fi
    echo $(cd $DIRNAME; pwd)
}

show_usage() {
	cat <<EOF
USAGE:
./setup_simlinks.sh [options]

[options]:
	The same options as from "man ln".
	Do not include -s, it is automatically added
EOF
}

for opt in "$@"; do
    case "$opt" in
    "-h"|"--help")
        show_usage
        exit 0
        ;;
    esac
done

SRCDIR=`abspath $0`
DESTDIR="$HOME"
OPTIONS="-s $@"

# verbose output
set -x

ln $OPTIONS "$SRCDIR/.bash_profile" "$DESTDIR"
ln $OPTIONS "$SRCDIR/.bashrc" "$DESTDIR"

ln $OPTIONS "$SRCDIR/.gdbinit" "$DESTDIR"
ln $OPTIONS "$SRCDIR/.gitconfig" "$DESTDIR"

ln $OPTIONS "$SRCDIR/.gvimrc" "$DESTDIR"
ln $OPTIONS "$SRCDIR/.vimrc" "$DESTDIR"
ln $OPTIONS "$SRCDIR/.vim" "$DESTDIR"

ln $OPTIONS "$SRCDIR/.zshrc" "$DESTDIR"
ln $OPTIONS "$SRCDIR/.zsh" "$DESTDIR"
ln $OPTIONS "$SRCDIR/.sh" "$DESTDIR"

ln $OPTIONS "$SRCDIR/.tmux.conf" "$DESTDIR"

ln $OPTIONS "$SRCDIR/bin" "$DESTDIR"

set +x
