# How to use HDFS/Spark Workbench

To start an HDFS/Spark Workbench (without Hive):
```
    docker-compose up -d
or
    ./start-hadoop-spark-workbench.sh
```
To start an HDFS/Spark Workbench and Hive:
```
    docker-compose -f docker-compose-hive.yml up -d
or
    ./start-hadoop-spark-workbench-with-hive.sh
```
To scale up spark-worker containers:
```
    docker-compose scale spark-worker=3
or
    docker-compose -f docker-compose-hive.yml scale spark-worker=3
```
## Stop/Down all

To Down one service
````
    ./stop-services.sh "some_service_name"
    ./stop-services.sh "zeppelin"
````
To Down all services
```
    ./stop-services.sh   ()
````
## Starting workbench with Hive support
Before starting the next command, check that the previous service is running correctly (with docker logs servicename).
```
docker-compose -f docker-compose-hive.yml up -d namenode hive-metastore-postgresql
docker-compose -f docker-compose-hive.yml up -d datanode hive-metastore
docker-compose -f docker-compose-hive.yml up -d hive-server
docker-compose -f docker-compose-hive.yml up -d spark-master spark-worker spark-notebook hue
```
## Interfaces

* Namenode: http://localhost:50070
* Datanode: http://localhost:50075
* Spark-master: http://localhost:8080
* Spark-notebook: http://localhost:9001
* Hue (HDFS Filebrowser): http://localhost:8088

## Important

When opening Hue, you might encounter ```NoReverseMatch: u'about' is not a registered namespace``` error after login. I disabled 'about' page (which is default one), because it caused docker container to hang. To access Hue when you have such an error, you need to append /home to your URI: ```http://docker-host-ip:8088/home```

## Docs

* [Zeppelin docker for BDE 2020 project](https://github.com/big-data-europe/docker-zeppelin)
** For example usage see [docker-compose.yml](https://github.com/big-data-europe/docker-zeppelin/blob/master/docker-compose.yml) and [SANSA-Notebooks repository](https://github.com/SANSA-Stack/SANSA-Notebooks).
* [Motivation behind the repo and an example usage @BDE2020 Blog](http://www.big-data-europe.eu/scalable-sparkhdfs-workbench-using-docker/)

## Troubleshoot

* Sometimes, spark-notebook container failed to "restart" (when you docker-compose stop and start again), the work around is to "docker rm -f spark-notebook" and then 
```
docker-compose -f docker-compose-hive.yml down -d spark-notebook
docker-compose -f docker-compose-hive.yml up -d spark-notebook
```
## Contributors

* DrSnowbird @openkbs.org
* Ivan Ermilov @earthquakesan

