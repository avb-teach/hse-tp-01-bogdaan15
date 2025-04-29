#!/bin/bash 

if [ $# -ne 2 ]; then
  
  exit 1
fi

in_dir="$1"
out_dir="$2"

if [ ! -d "$in_dir" ]; then
  
  exit 1
fi

mkdir -p "$out_dir"

declare -A total count_seen

while IFS= read -r -d '' file; do
  bn=$(basename "$file")
  total["$bn"]=$(( total["$bn"] + 1 ))
done < <(find "$in_dir" -type f -print0)

i=0
while IFS= read -r -d '' file; do
  i=$((i + 1))
  bn=$(basename "$file")

  name="${bn%.*}"
  ext="${bn##*.}"
  if [ "$name" = "$ext" ]; then
    ext=""
  else
    ext=".$ext"
  fi

  if [ "${total[$bn]}" -gt 1 ]; then
    count_seen["$bn"]=$(( count_seen["$bn"] + 1 ))
    idx=${count_seen["$bn"]}
    new_name="${name}${idx}${ext}"
  else
    new_name="$bn"
  fi

  cp "$file" "$out_dir/$new_name"
done < <(find "$in_dir" -type f -print0)
