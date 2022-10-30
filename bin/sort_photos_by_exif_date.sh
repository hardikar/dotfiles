#! /usr/bin/env bash

set -o nounset

# Requires exif to be installed on the system!
if ! command -v exif 1>&2 2>/dev/null; then
	echo "This script requires the exif command."
	exit 1
fi

case $(uname) in
	'Linux')
		MV='mv --backup=numbered --no-clobber'
		;;
	'Darwin')
		MV='mv -n'
		;;
	*)
		echo "Unsupported OS: $(uname)"
		exit 1
		;;
esac

DIR=${1:-`pwd`}
echo "Searching in $DIR"

find "$DIR" -maxdepth 1 -type f | while read f; do
	if file --mime-type "$f" | grep -q image; then
		echo -n "$f -> "
		date=$(exif --tag 'DateTime' --machine-readable "$f")
		rc="$?"
		echo "$date"
		if [ $rc -eq 0 ]; then
			# EXIF data is present
			date=`echo "$date" | cut -c 1-10 | sed 's/:/-/g'`
			mkdir -p "$date"
			$MV "$f" "$date/"
		fi
	fi
done

