#!/bin/bash

declare -A content

buildfile=$1
user=$2
password=$3
tags=$4
registry=$5
# read
while IFS="=" read -r key value; do content["$key"]=$value; done < <(
  yq '.fileImageMap | to_entries | map([.key, .value] | join("=")) | .[]' $buildfile
)

docker_registry='' 
if [ "$registry" != 'EMPTY' ]; then
    docker_registry=$registry
fi

echo ${password} | docker login --username ${user} --password-stdin ${docker_registry}

for key in "${!content[@]}"; do 
  printf "key %s, value %s\n" "$key" "${content[$key]}";
  dockerfile=$key
  image=${content[$key]}  
  docker build -f ${dockerfile} ${tags} .
  docker push ${image} --all-tags 
done

