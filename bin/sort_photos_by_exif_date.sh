#! /bin/sh

# WARNING: Make sure to back up the photos before running this script!
# Requires exif to be installed on the system!

DIR=${1:-`pwd`}

find "$DIR" -type f -maxdepth 1 | while read f; do
  if file -i "$f" | grep -q image; then
    date=`exif -t 'DateTime' -m "$f"`
    if test $? -eq 0; then
      # EXIF data is present
      date=`echo "$date" | cut -c 1-10 | sed 's/:/-/g'`
      mkdir -p "$date"
      mv "$f" "$date"
    fi
  fi
done


