#!/bin/bash

# TODO: What does this script do?

split() {
  start="$1"
  end="$2"
  output="$3"
  echo -n "start=$start" "end=$end" "output=$output ..."
  if [ "$end" ]; then
    ffmpeg -y -i "$input" -ss $start -to $end "$output" >/dev/null 2>&1 </dev/null
  else
    ffmpeg -y -i "$input" -ss $start "$output" >/dev/null 2>&1 </dev/null
  fi
  echo "done" 
}

input="$1"
splits="$2"

cat $splits | while read line; do
  start=$(echo "$line" | cut -d'-' -f 1)
  end=$(echo "$line" | cut -d'-' -f 2)
  name=$(echo "$line" | cut -d'-' -f 3)
  
  if [ "$name" -a "$start" -a "$end" ]; then
    output="${input%.*} -$name.mp3"
    split "$start" "$end" "$output"
  fi
done

