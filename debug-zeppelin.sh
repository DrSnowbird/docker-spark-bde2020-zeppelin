#!/bin/bash -x

run_mode="debug"

if [ "$run_mode" = "debug" ]; then
    ## -- interactive debug mode --
    docker -rm -f my-bde2020-zeppeli
    docker run --rm -t -i --name my-bde2020-zeppelin -v /mnt/data/docker/bde2020-zeppelin/notebook:/usr/bin/zeppelin/notebook -v /mnt/data/docker/bde2020-zeppelin/data:/usr/bin/zeppelin/data -p 29090:8080 -i -t openkbs/bde2020-zeppelin:2.1.0-hadoop2.8-hive-java8 bash
else
    ## -- daemon --
    docker -rm -f my-bde2020-zeppeli
    docker run -d -t -i --name my-bde2020-zeppelin -v /mnt/data/docker/bde2020-zeppelin/notebook:/usr/bin/zeppelin/notebook -v /mnt/data/docker/bde2020-zeppelin/data:/usr/bin/zeppelin/data -p 29090:8080 -i -t openkbs/bde2020-zeppelin:2.1.0-hadoop2.8-hive-java8 
fi
