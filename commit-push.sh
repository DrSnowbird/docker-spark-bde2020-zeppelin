#!/bin/bash -x

# Reference: https://docs.docker.com/engine/userguide/containers/dockerimages/

echo "Usage: "
echo "  ${0} <comment> <repo-name/repo-tag>"
echo

imageTag=${2:-openkbs/bde2020-zeppelin}
version=2.1.0-hadoop2.8-hive-java8
comment=${1:-"push ${imageTag}:${version}"}

docker ps -a

containerID=`docker ps |grep "${imageTag} "|awk '{print $1}'`
echo "containerID=$containerID"

docker commit -m "$comment" ${containerID} ${imageTag}:${version}
docker push ${imageTag}:${version}

#docker commit -m "$comment" ${containerID} ${imageTag}:latest
#docker push ${imageTag}:latest


