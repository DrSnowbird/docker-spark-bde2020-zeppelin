#!/bin/bash -x

service=${1:-""}
docker-compose -f docker-compose-hive.yml stop ${service}
