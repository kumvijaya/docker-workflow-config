#!/bin/bash

declare -A content

# read
while IFS="=" read -r key value; do content["$key"]=$value; done < <(
  yq 'to_entries | map([.key, .value] | join("=")) | .[]' docker-workflow-config/build.yaml
)

for key in "${!content[@]}"; do printf "key %s, value %s\n" "$key" "${content[$key]}"; done
