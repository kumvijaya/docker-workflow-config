#!/bin/bash

declare -A content

build_images=$1
user=$2
password=$3
tags=$4
registry=$5

docker_registry='' 
if [ "$registry" != 'EMPTY' ]; then
    docker_registry=$registry
fi

set -x
echo ${password} | docker login --username ${user} --password-stdin ${docker_registry}

IFS=', ' read -r -a build_image_array <<< "$build_images"

for build_image in "${build_image_array[@]}"
do
  file=$(echo $build_image | cut -f1 -d=)
  image=$(echo $build_image | cut -f2 -d=)
  IFS=', ' read -r -a tags_array <<< "$tags"
  docker_tags=''
  for tag in "${tags_array[@]}"
  do
      docker_tags="${docker_tags} -t $image:$tag"
  done
  docker_dir=$(python docker-workflow-config/get_dir.py --path $file)
  docker_file=$(python docker-workflow-config/get_file.py --path $file)
  printf "docker_dir %s, docker_file %s,  image %s, docker_tags %s\n" "${docker_dir}" "${docker_file}" "${image}" "${docker_tags}";
  (cd ${docker_dir} && docker build -f ${docker_file} ${docker_tags} . && docker push ${image} --all-tags)
done
docker logout ${docker_registry}