#! /usr/bin/env bash
USAGE="
USAGE:
      ./setup_simlinks.sh [options] <from-dir> <to-dir>
[options]:
      The same options as from \"man ln\". 
      Do not include -s, it is automatically added"

if [[ "$#" == "2" ]]; then
    OPTIONS="-s"
    SRCDIR="$(dirname $1)/$(basename $1)"
    DESTDIR="$(dirname $2)/$(basename $2)"
elif [[ "$#" == "3" ]]; then
    OPTIONS="-s $1"
    SRCDIR="$(dirname $2)/$(basename $2)"
    DESTDIR="$(dirname $3)/$(basename $3)"
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
ln $OPTIONS $SRCDIR/.bashrc $DESTDIR

ln $OPTIONS $SRCDIR/.vimperator $DESTDIR
ln $OPTIONS $SRCDIR/.vimperatorrc $DESTDIR

ln $OPTIONS $SRCDIR/bin $DESTDIR

set +x
