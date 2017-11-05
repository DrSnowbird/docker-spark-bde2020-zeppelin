#!/bin/bash -x

. "/spark/sbin/spark-config.sh"

. "/spark/bin/load-spark-env.sh"

mkdir -p $SPARK_WORKER_LOG

export SPARK_HOME=${SPARK_HOME:-/spark}
export ZEPPELIN_HOME=${ZEPPELIN_HOME:-/usr/lib/zeppelin}

#/bin/bash -c /spark/sbin/../bin/spark-class org.apache.spark.deploy.worker.Worker \
#    -cp /spark//conf/:/spark/jars/*:/etc/hadoop/ \
#    -Xmx24g \
#    org.apache.spark.deploy.worker.Worker \
#    --webui-port $SPARK_WORKER_WEBUI_PORT $SPARK_MASTER >> $SPARK_WORKER_LOG/spark-worker.out
# (actual) 
#/usr/lib/jvm/java-8-openjdk-amd64/bin/java -cp /spark//conf/:/spark/jars/*:/etc/hadoop/ -Xmx1g org.apache.spark.deploy.worker.Worker --webui-port 8081 spark://spark-master:7077
## nohup /bin/bash -c /usr/lib/jvm/java-8-openjdk-amd64/bin/java -cp /spark//conf/:/spark/jars/*:/etc/hadoop/ -Xmx1g org.apache.spark.deploy.worker.Worker --webui-port 8081 spark://spark-master:7077 &
# (alt-1) nohup /bin/bash -c /usr/lib/jvm/java-8-openjdk-amd64/bin/java -cp /spark//conf/:/spark/jars/*:/etc/hadoop/ -Xmx1g org.apache.spark.deploy.worker.Worker --webui-port 8081 spark://spark-master:7077 &

sleep 5

# /usr/lib/zeppelin/bin/zeppelin-daemon.sh", "start"
/bin/bash -c /usr/lib/zeppelin/bin/zeppelin.sh start
# $ZEPPELIN_HOME/bin/zeppelin_daemon.sh start

#jupyter notebook
