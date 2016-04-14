#! /usr/bin/env bash

function abspath(){
    if [[ ! -d "$1" ]]; then
        DIRNAME=$(dirname "$1")
    else
        DIRNAME="$1"
    fi
    echo $(cd $DIRNAME; pwd)
}

USAGE="
USAGE:
      ./setup_simlinks.sh [options] <from-dir> <to-dir>
[options]:
      The same options as from \"man ln\". 
      Do not include -s, it is automatically added"

if [[ "$#" == "2" ]]; then
    OPTIONS="-s"
    SRCDIR="$(abspath $1)"
    DESTDIR="$(abspath $2)"
elif [[ "$#" == "3" ]]; then
    OPTIONS="-s $1"
    SRCDIR="$(abspath $2)"
    DESTDIR="$(abspath $3)"
else
    echo "$USAGE"
    exit 1
fi

# verbose output
set -x

ln $OPTIONS $SRCDIR/.vimrc $DESTDIR
ln $OPTIONS $SRCDIR/.vim $DESTDIR

ln $OPTIONS $SRCDIR/.tmux.conf $DESTDIR

ln $OPTIONS $SRCDIR/.zshrc $DESTDIR
ln $OPTIONS $SRCDIR/.zsh $DESTDIR
ln $OPTIONS $SRCDIR/.sh $DESTDIR
ln $OPTIONS $SRCDIR/.bashrc $DESTDIR

ln $OPTIONS $SRCDIR/.vimperator $DESTDIR
ln $OPTIONS $SRCDIR/.vimperatorrc $DESTDIR

ln $OPTIONS $SRCDIR/bin $DESTDIR

ln $OPTIONS $SRCDIR/.gdbinit $DESTDIR

set +x
