FROM bde2020/spark-base:2.1.0-hadoop2.8-hive-java8

MAINTAINER DrSnowbird <DrSnowbird@openkbs.org>

#### ---- Host Arguments variables----
ARG APACHE_SPARK_VERSION=2.1.0 
ARG APACHE_HADOOP_VERSION=2.8.0 
ARG SPARK_MASTER="spark://spark-master:7077" 
ARG ZEPPELIN_DOWNLOAD_URL=http://apache.cs.utah.edu/zeppelin 
ARG ZEPPELIN_VERSION=0.7.1 
ARG ZEPPELIN_PORT=8080 
ARG ZEPPELIN_INSTALL_DIR=/usr/lib 
ARG ZEPPELIN_HOME=${ZEPPELIN_INSTALL_DIR}/zeppelin 
ARG ZEPPELIN_PKG_NAME=zeppelin-${ZEPPELIN_VERSION}-bin-all 

#### ---- Host Environment variables ----
ENV APACHE_SPARK_VERSION=${APACHE_SPARK_VERSION} 
ENV APACHE_HADOOP_VERSION=${APACHE_HADOOP_VERSION} 
ENV SPARK_MASTER=${SPARK_MASTER} 
ENV ZEPPELIN_VERSION=${ZEPPELIN_VERSION} 
ENV ZEPPELIN_HOME=${ZEPPELIN_HOME} 
ENV ZEPPELIN_PORT=${ZEPPELIN_PORT} 
ENV ZEPPELIN_CONF_DIR=${ZEPPELIN_HOME}/conf 
ENV ZEPPELIN_DATA_DIR=${ZEPPELIN_HOME}/data 
ENV ZEPPELIN_NOTEBOOK_DIR=${ZEPPELIN_HOME}/notebook 

#### ---- Python 3 ----
COPY requirements.txt ./
RUN apt-get update -y \
  && apt-get install -y curl net-tools build-essential git wget unzip vim python3-pip python3-setuptools python3-dev python3-numpy python3-scipy python3-pandas python3-matplotlib \
  && pip3 install -r requirements.txt \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

#### ---- Zeppelin Installation -----
WORKDIR ${ZEPPELIN_INSTALL_DIR}

#### ---- (Interim mode) Zeppelin Installation (using local host tar file) ----
#COPY ${ZEPPELIN_PKG_NAME}.tgz /tmp/
#RUN tar -xvf /tmp/${ZEPPELIN_PKG_NAME}.tgz -C /usr/lib/ \
#    && chown -R root ${ZEPPELIN_PKG_NAME} \
#    && ln -s ${ZEPPELIN_PKG_NAME} zeppelin \ 
#    && mkdir -p ${ZEPPELIN_HOME}/logs && mkdir -p ${ZEPPELIN_HOME}/run \
#    && rm /tmp/${ZEPPELIN_PKG_NAME}.tgz

#### ---- (Deployment mode use) Zeppelin Installation (Download from Internet -- Deployment) ----
#e.g. RUN wget -c http://apache.cs.utah.edu/zeppelin/zeppelin-0.7.1/zeppelin-0.7.1-bin-all.tgz
RUN wget -c ${ZEPPELIN_DOWNLOAD_URL}/zeppelin-${ZEPPELIN_VERSION}/${ZEPPELIN_PKG_NAME}.tgz \
    && tar xvf ${ZEPPELIN_PKG_NAME}.tgz \
    && ln -s ${ZEPPELIN_PKG_NAME} zeppelin \
    && mkdir -p ${ZEPPELIN_HOME}/logs && mkdir -p ${ZEPPELIN_HOME}/run \
    && rm -f ${ZEPPELIN_PKG_NAME}.tgz

#### ---- default config is ok ----
#COPY conf/zeppelin-site.xml ${ZEPPELIN_HOME}/conf/zeppelin-site.xml
#COPY conf/zeppelin-env.sh ${ZEPPELIN_HOME}/conf/zeppelin-env.sh

#### ---- SparkR ----
# TO-DO if needed
# (see https://github.com/rocker-org/rocker/blob/master/r-base/Dockerfile)

#RUN mkdir -p ${ZEPPELIN_HOME}/data

#### ---- Debug ----
RUN ls -al /usr/lib/zeppelin/bin \
    && ls -al /usr/lib/zeppelin/notebook \
    && ls -al /usr/lib/zeppelin/bin/zeppelin-daemon.sh

VOLUME ${ZEPPELIN_HOME}/notebook
VOLUME ${ZEPPELIN_HOME}/conf
VOLUME ${ZEPPELIN_HOME}/data

EXPOSE ${ZEPPELIN_PORT}

WORKDIR ${ZEPPELIN_HOME}

CMD ["/opt/zeppelin/bin/zeppelin.sh"]



