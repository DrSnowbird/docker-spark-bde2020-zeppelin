#!/bin/bash -x
DOCKER_FILE=${1:-docker-compose-hive.yml}
DOCKER_CMD="docker-compose -f ${DOCKER_FILE} up -d "
CONTAINER_LIST="\
    namenode hive-metastore-postgresql \
    datanode hive-metastore hive-server spark-master spark-worker \
    hive-server \
    spark-master spark-worker wait/10\
    spark-notebook hue \
    zeppelin"

for c in $CONTAINER_LIST; do
    if [[ "$c" =~ wait ]]; then
        wait_sec=$(basename $c)
        echo "... waiting for ${wait_sec} seconds ..."
        sleep ${wait_sec}
    else
        echo "${DOCKER_CMD} $c"
    fi
done
