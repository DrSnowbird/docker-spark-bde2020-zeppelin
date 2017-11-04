#!/bin/bash -x

. "/spark/sbin/spark-config.sh"

. "/spark/bin/load-spark-env.sh"

mkdir -p ${SPARK_WORKER_LOG:-/spark/log}

export SPARK_HOME=${SPARK_HOME:-/spark}
export ZEPPELIN_HOME=${ZEPPELIN_HOME:-/usr/lib/zeppelin}

#### ---- Start the first process ----
#### ---- (Spark Worker) ----
# (actual) /usr/lib/jvm/java-8-openjdk-amd64/bin/java -cp /spark//conf/:/spark/jars/*:/etc/hadoop/ -Xmx1g org.apache.spark.deploy.worker.Worker --webui-port 8081 spark://spark-master:7077
#
#/bin/bash -c /spark/sbin/../bin/spark-class org.apache.spark.deploy.worker.Worker \
#    --webui-port $SPARK_WORKER_WEBUI_PORT $SPARK_MASTER >> $SPARK_WORKER_LOG/spark-worker.out
/bin/bash -c /usr/lib/jvm/java-8-openjdk-amd64/bin/java -cp /spark//conf/:/spark/jars/*:/etc/hadoop/ -Xmx8g org.apache.spark.deploy.worker.Worker --webui-port 8081 spark://spark-master:7077 -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start spark-worker_process: $status"
  exit $status
fi

#### ---- Start the second process ----
#### ---- (Zeppelin) ----
# (acutal) /usr/lib/jvm/java-8-openjdk-amd64/bin/java -Dspark.driver.memory=1g -Dspark.executor.memory=2g -Dfile.encoding=UTF-8 -Xms1024m -Xmx1024m -XX:MaxPermSize=512m -Dlog4j.configuration=file:///usr/lib/zeppelin/conf/log4j.properties -Dzeppelin.log.file=/usr/lib/zeppelin/logs/zeppelin-root-76226b5f7789.log -cp ::/usr/lib/zeppelin/lib/interpreter/*:/usr/lib/zeppelin/lib/*:/usr/lib/zeppelin/*::/usr/lib/zeppelin/conf org.apache.zeppelin.server.ZeppelinServer
#
/bin/bash -c /usr/lib/zeppelin/bin/zeppelin.sh start -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start my_second_process: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container will exit with an error
# if it detects that either of the processes has exited.
# Otherwise it will loop forever, waking up every 60 seconds

while /bin/true; do
  ps aux |grep "webui-port 808" |grep -q -v grep
  PROCESS_1_STATUS=$?
  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo ">>> Spark-work process has already exited."
    exit -1
  fi
  ps aux |grep "zeppelin" |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they will exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "zeppelin process has already exited."
    exit -1
  fi
  sleep 60
done
