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
echo ${password} | docker login --username ${user} --password-stdin ${docker_registry}
# read
while IFS="=" read -r key value; do content["$key"]=$value; done < <(
  yq '.fileImageMap | to_entries | map([.key, .value] | join("=")) | .[]' $buildfile
)

for key in "${!content[@]}"; do 
  printf "key %s, value %s\n" "$key" "${content[$key]}";
  file=$key
  image=${content[$key]}
  docker_dir=$(python docker-workflow-config/get_dir.py --path $file)
  docker_file=$(python docker-workflow-config/get_file.py --path $file)
  printf "docker_dir %s, docker_file %s,  image %s\n" "${docker_dir}" "${docker_file}" "${image}";
  (cd ${docker_dir} && docker build -f ${docker_file} ${tags} . && docker push ${image} --all-tags)
done