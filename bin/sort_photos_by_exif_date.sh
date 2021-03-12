#! /usr/bin/env bash

set -o errexit -o errtrace -o pipefail -o nounset

# Requires exif to be installed on the system!
if ! command -v exif 1>&2 2>/dev/null; then
	echo "This script requires the exif command."
	exit 1
fi

DIR=${1:-`pwd`}
echo "Searching in $DIR"

find "$DIR" -maxdepth 1 -type f | while read f; do
	if file --mime-type "$f" | grep -q image; then
		date=$(exif --tag 'DateTime' --machine-readable "$f")
		echo "$f -> $date"
		if test $? -eq 0; then
			# EXIF data is present
			date=`echo "$date" | cut -c 1-10 | sed 's/:/-/g'`

			mkdir -p "$date"
			mv --backup=numbered --no-clobber "$f" "$date/"
		fi
	fi
done

