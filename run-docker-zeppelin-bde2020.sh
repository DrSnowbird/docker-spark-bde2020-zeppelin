#!/bin/bash -x

export DATA_DIR=${1:-${HOME}/data-docker/hadoop-spark}/data
mkdir -p ${DATA_DIR}
echo "DATA_DIR=${DATA_DIR}"
export ZEPPELIN_LOCAL_PORT=${2:-9090}

docker-compose up -d



