#!/bin/sh

# If cmus is installed, show "current playing" track in the Tmux status bar
# This script, will query cmus using cmus-remote, and parse the title, album, tracknumber, artist.
# Add tm_music="#(~/bin/tmux-cmus-player.sh)" in .tmux.conf to add it to the status line.
#
if cmus-remote -Q >/dev/null; then
    cmus_output=$(cmus-remote -Q)
    status=$(echo "$cmus_output" | grep "^status")

    title=$(echo "$cmus_output" | grep "tag title " | cut -d ' ' -f 3- | cut -c 1-15)
    album=$(echo "$cmus_output" | grep "tag album " | cut -d ' ' -f 3- | cut -c 1-15)
    tracknumber=$(echo "$cmus_output" | grep "tag tracknumber " | cut -d ' ' -f 3- | cut -c 1-15)
    artist=$(echo "$cmus_output" | grep "tag artist " | cut -d ' ' -f 3- | cut -c 1-15)
fi

if [[ "$status" == "status playing" ]]; then
    echo "♫  $artist - $album - $tracknumber. $title ♫ "
fi


