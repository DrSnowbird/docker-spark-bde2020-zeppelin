FROM bde2020/spark-worker:2.4.0-hadoop2.8
#FROM bde2020/spark-worker:2.2.0-hadoop2.8-hive-java8

MAINTAINER DrSnowbird <DrSnowbird@openkbs.org>

#### ---- Host Arguments variables----
ARG APACHE_SPARK_VERSION=2.4.0 
ARG APACHE_HADOOP_VERSION=2.8.0 
ARG SPARK_MASTER="spark://spark-master:7077" 
ARG ZEPPELIN_DOWNLOAD_URL=http://apache.cs.utah.edu/zeppelin
#ARG ZEPPELIN_DOWNLOAD_URL=http://www-us.apache.org/dist/zeppelin
ARG ZEPPELIN_INSTALL_DIR=/usr/lib 
ARG ZEPPELIN_HOME=${ZEPPELIN_INSTALL_DIR}/zeppelin 
ARG ZEPPELIN_VERSION=${ZEPPELIN_VERSION:-0.8.1}
ARG ZEPPELIN_PKG_NAME=zeppelin-${ZEPPELIN_VERSION}-bin-all 
ARG ZEPPELIN_PORT=8080 

#### ---- Host Environment variables ----
ENV APACHE_SPARK_VERSION=${APACHE_SPARK_VERSION} 
ENV APACHE_HADOOP_VERSION=${APACHE_HADOOP_VERSION} 
ENV SPARK_MASTER=${SPARK_MASTER} 
ENV ZEPPELIN_HOME=${ZEPPELIN_HOME} 
ENV ZEPPELIN_CONF_DIR=${ZEPPELIN_HOME}/conf 
ENV ZEPPELIN_DATA_DIR=${ZEPPELIN_HOME}/data 
ENV ZEPPELIN_NOTEBOOK_DIR=${ZEPPELIN_HOME}/notebook 
ENV ZEPPELIN_DOWNLOAD_URL=${ZEPPELIN_DOWNLOAD_URL}
ENV ZEPPELIN_INSTALL_DIR=${ZEPPELIN_INSTALL_DIR}
ENV ZEPPELIN_VERSION=${ZEPPELIN_VERSION} 
ENV ZEPPELIN_PKG_NAME=zeppelin-${ZEPPELIN_VERSION}-bin-all 
ENV ZEPPELIN_PORT=${ZEPPELIN_PORT} 

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
RUN wget -c ${ZEPPELIN_DOWNLOAD_URL}/zeppelin-${ZEPPELIN_VERSION}/${ZEPPELIN_PKG_NAME}.tgz \
    && tar xvf ${ZEPPELIN_PKG_NAME}.tgz \
    && ln -s ${ZEPPELIN_PKG_NAME} zeppelin \
    && mkdir -p ${ZEPPELIN_HOME}/logs && mkdir -p ${ZEPPELIN_HOME}/run \
    && rm -f ${ZEPPELIN_PKG_NAME}.tgz

#### ---- default config is ok ----
#COPY conf/zeppelin-site.xml ${ZEPPELIN_HOME}/conf/zeppelin-site.xml
#COPY conf/zeppelin-env.sh ${ZEPPELIN_HOME}/conf/zeppelin-env.sh
COPY worker.sh /

#### ---- For SparkR ----
## To-do: Later    
#echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | sudo tee -a /etc/apt/sources.list
#gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
#gpg -a --export E084DAB9 | sudo apt-key add 
#sudo apt-get update
#sudo apt-get install r-base-core r-recommended r-base-html r-base r-base-dev 

## Now install R and littler, and create a link for littler in /usr/local/bin
#RUN echo "..... Installing R base ....." \
#    && echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list \
#    && gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 \
#    && gpg -a --export E084DAB9 | apt-key add - \
#    && apt-get update -y \
#    && apt-get -y install build-essential libc6 libjpeg8 r-cran-mgcv r-base-core r-recommended r-base-html r-base r-base-dev 

## To-do: Later    
#ENV RSTUDIO_DEB_PKG=rstudio-xenial-1.1.383-amd64.deb
#RUN echo ".... Installing R-Studio ...." \    
#    && apt-get install gdebi-core \
#    && wget https://download1.rstudio.org/${RSTUDIO_DEB_PKG} \
#    && gdebi -n ${RSTUDIO_DEB_PKG} \
#    && rm ${RSTUDIO_DEB_PKG}

#### ---- Debug ----
RUN mkdir -p ${ZEPPELIN_HOME}/data \
    && ls -al /usr/lib/zeppelin/bin \
    && ls -al /usr/lib/zeppelin/notebook \
    && ls -al /usr/lib/zeppelin/bin/zeppelin-daemon.sh

VOLUME ${ZEPPELIN_HOME}/notebook
VOLUME ${ZEPPELIN_HOME}/conf
VOLUME ${ZEPPELIN_HOME}/data

EXPOSE ${ZEPPELIN_PORT}

#ENV SPARK_SUBMIT_OPTIONS "--jars /opt/zeppelin/sansa-examples-spark-2016-12.jar"

ENV ZEPPELIN_JAVA_OPTS=${ZEPPELIN_JAVA_OPTS:-"-Dspark.driver.memory=4g -Dspark.executor.memory=8g -Dspark.cores.max=16"}
ENV ZEPPELIN_MEM=${ZEPPELIN_MEM:-"-Xms8g -Xmx28g -XX:MaxPermSize=8g"}
ENV ZEPPELIN_INTP_MEM=${ZEPPELIN_INTP_MEM:-"-Xms4g -Xmx24g"}
#ENV ZEPPELIN_INTP_JAVA_OPTS=${ZEPPELIN_INTP_JAVA_OPTS}

WORKDIR ${ZEPPELIN_HOME}

HEALTHCHECK NONE
#HEALTHCHECK CMD curl --fail http://localhost:8080/ || exit 1

#CMD ["/worker.sh"]
CMD ["/usr/lib/zeppelin/bin/zeppelin.sh"]

