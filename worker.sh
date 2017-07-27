#!/bin/bash -x

. "/spark/sbin/spark-config.sh"

. "/spark/bin/load-spark-env.sh"

mkdir -p $SPARK_WORKER_LOG

export SPARK_HOME=${SPARK_HOME:-/spark}
export ZEPPELIN_HOME=${ZEPPELIN_HOME:-/usr/lib/zeppelin}

#/spark/sbin/../bin/spark-class org.apache.spark.deploy.worker.Worker \
#    --webui-port $SPARK_WORKER_WEBUI_PORT $SPARK_MASTER >> $SPARK_WORKER_LOG/spark-worker.out

# /usr/lib/zeppelin/bin/zeppelin-daemon.sh", "start"
/bin/bash -c /usr/lib/zeppelin/bin/zeppelin-daemon.sh start
# $ZEPPELIN_HOME/bin/zeppelin_daemon.sh start

#jupyter notebook
