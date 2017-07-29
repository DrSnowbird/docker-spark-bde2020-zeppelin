#!/bin/bash -x

cd ./example-docker-spark-bde2020 
docker-compose -f docker-compose-hive.yml stop $*
