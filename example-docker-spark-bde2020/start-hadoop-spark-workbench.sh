#!/bin/bash

echo "Usage: $(basename $0) <base_dir_for_data>"

export DATA_DIR=${1:-${HOME}/data-docker/bde2020-hadoop-spark}/data
mkdir -p ${DATA_DIR}

echo "DATA_DIR=${DATA_DIR}"

## -- some issue with restarting spark-notebook
## -- workaround: remove old instance first
docker rm -f spark-notebook

## -- Starting all services
docker-compose up -d

my_ip=`ip route get 1|awk '{print $NF;exit}'`
echo "Namenode: http://${my_ip}:50070"
echo "Datanode: http://${my_ip}:50075"
echo "Spark-master: http://${my_ip}:8080"
echo "Spark-notebook: http://${my_ip}:9001"
echo "Hue (HDFS Filebrowser): http://${my_ip}:8088/home"

