#!/bin/bash

declare -A content

buildfile=$1
user=$2
password=$3
tags=$4
registry=$5

docker_registry='' 
if [ "$registry" != 'EMPTY' ]; then
    docker_registry=$registry
fi

# read
while IFS="=" read -r key value; do content["$key"]=$value; done < <(
  yq '.fileImageMap | to_entries | map([.key, .value] | join("=")) | .[]' $buildfile
)

for key in "${!content[@]}"; do 
  printf "key %s, value %s\n" "$key" "${content[$key]}";
  imagefile=$key
  docker_dir=$(python docker-workflow-config/get_dir.py --path $imagefile)
  docker_file=$(python docker-workflow-config/get_file.py --path $imagefile)
  image=${content[$key]}
  echo ${password} | docker login --username ${user} --password-stdin ${docker_registry}
  docker build -f ${docker_file} ${tags} ${docker_dir}
  docker push ${image} --all-tags 
done