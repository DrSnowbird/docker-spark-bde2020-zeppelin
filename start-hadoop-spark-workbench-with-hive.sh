#!/bin/bash -x

cd ./example-docker-spark-bde2020

echo "Usage: $(basename $0) <docker_file> <base_dir_for_data>"

export DATA_DIR=${1:-${HOME}/data-docker/bde2020-hadoop-spark}/data
#export NOTEBOOK_DIR=${1:-${HOME}/data-docker/bde2020-hadoop-spark}/notebook
mkdir -p ${DATA_DIR}
#mkdir -p ${NOTEBOOK_DIR}

echo "DATA_DIR=${DATA_DIR}"
echo "NOTEBOOK_DIR=${NOTEBOOK_DIR}"

## -- some issue with restarting spark-notebook
## -- workaround: remove old instance first
docker rm -f spark-notebook

## -- Starting all services
DOCKER_FILE=${1:-docker-compose-hive.yml}
DOCKER_CMD="docker-compose -f ${DOCKER_FILE} up -d "
CONTAINER_LIST="\
    namenode hive-metastore-postgresql \
    datanode hive-metastore hive-server spark-master spark-worker \
    hive-server \
    spark-master spark-worker \
    wait/10 \
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

my_ip=`ip route get 1|awk '{print $NF;exit}'`
echo "Namenode: http://${my_ip}:50070"
echo "Datanode: http://${my_ip}:50075"
echo "Spark-master: http://${my_ip}:8080"
echo "Spark-notebook: http://${my_ip}:9001"
echo "Hue (HDFS Filebrowser): http://${my_ip}:8088/home"
echo "Zeppelin: http://${my_ip}:19090"
