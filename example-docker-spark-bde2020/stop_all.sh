#!/bin/bash -x

service=${1:-""}
docker-compose -f docker-compose-hive2.yml down ${service}
