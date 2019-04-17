[![](https://images.microbadger.com/badges/image/openkbs/docker-spark-bde2020-zeppelin.svg)](https://microbadger.com/images/openkbs/docker-spark-bde2020-zeppelin "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/openkbs/docker-spark-bde2020-zeppelin.svg)](https://microbadger.com/images/openkbs/docker-spark-bde2020-zeppelin "Get your own version badge on microbadger.com")

# Zeppelin for Spark + Hadoop (optional Hive)

This Dockerfile only build Zeppelin which has dependency on the rest of other dockers in "docker-spark-bde2020" including Hadoop, Spark, Hive, etc.

## Pull Image 
You can get from https://hub.docker.com/r/openkbs/docker-spark-bde2020-zeppelin/
```
docker pull openkbs/docker-spark-bde2020-zeppelin
```

## Build (if you want to build your own)
To build, 
```
./build.sh
```

## Run - "Zeppelin" Only
```
docker-compose -f docker-compose-hive.yml up -d zeppelin
```

## Run - The entire suite - Hadoop + Spark + (Hive) + Zeppelin + SparkNotebook + Hue
There two options to run the entire suite of "docker-spark-bde2020"
* start-hadoop-spark-workbench.sh (no Hive support)
* start-hadoop-spark-workbench-with-hive.sh (with Hive support)

For example, to start the entire "docker-spark-bde2020 and zeppelin with Hive support:
```
./start-hadoop-spark-workbench-with-hive.sh
```
For example, to start the entire "docker-spark-bde2020 and zeppelin without Hive support:
```
./start-hadoop-spark-workbench.sh
```

## Reference to BDE2020 projects
To see how this Container work with with the entire [big-data-europe/docker-hadoop-spark-workbench](https://github.com/big-data-europe/docker-hadoop-spark-workbench), go to "./example-docker-spark-bde2020" directory to explore the entire suite build. 

## Docs
* [Zeppelin docker for BDE 2020 project](https://github.com/big-data-europe/docker-zeppelin)

** For example usage see [docker-compose.yml](https://github.com/big-data-europe/docker-zeppelin/blob/master/docker-compose.yml) and [SANSA-Notebooks repository](https://github.com/SANSA-Stack/SANSA-Notebooks).
* [Motivation behind the repo and an example usage @BDE2020 Blog](http://www.big-data-europe.eu/scalable-sparkhdfs-workbench-using-docker/)

## See 
See [big-data-europe/docker-spark README](https://github.com/big-data-europe/docker-spark).

