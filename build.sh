#!/bin/bash

declare -A content

buildfile=$1
# read
while IFS="=" read -r key value; do content["$key"]=$value; done < <(
  yq '.fileImageMap | to_entries | map([.key, .value] | join("=")) | .[]' $buildfile
)

for key in "${!content[@]}"; do 
  printf "key %s, value %s\n" "$key" "${content[$key]}"; 
done