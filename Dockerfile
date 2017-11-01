FROM bde2020/spark-worker:2.1.0-hadoop2.8-hive-java8

MAINTAINER DrSnowbird <DrSnowbird@openkbs.org>

#### ---- Host Arguments variables----
ARG APACHE_SPARK_VERSION=2.1.0 
ARG APACHE_HADOOP_VERSION=2.8.0 
ARG SPARK_MASTER="spark://spark-master:7077" 
ARG ZEPPELIN_DOWNLOAD_URL=http://apache.cs.utah.edu/zeppelin
#ARG ZEPPELIN_DOWNLOAD_URL=http://www-us.apache.org/dist/zeppelin
ARG ZEPPELIN_INSTALL_DIR=/usr/lib 
ARG ZEPPELIN_HOME=${ZEPPELIN_INSTALL_DIR}/zeppelin 
ARG ZEPPELIN_VERSION=${ZEPPELIN_VERSION:-0.7.2}
ARG ZEPPELIN_PKG_NAME=zeppelin-${ZEPPELIN_VERSION:-0.7.2}-bin-all 
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
ENV ZEPPELIN_VERSION=${ZEPPELIN_VERSION:-0.7.2} 
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
#e.g. RUN wget -c http://apache.cs.utah.edu/zeppelin/zeppelin-0.7.2/zeppelin-0.7.2-bin-all.tgz

RUN wget -c ${ZEPPELIN_DOWNLOAD_URL}/zeppelin-${ZEPPELIN_VERSION}/${ZEPPELIN_PKG_NAME}.tgz \
    && tar xvf ${ZEPPELIN_PKG_NAME}.tgz \
    && ln -s ${ZEPPELIN_PKG_NAME} zeppelin \
    && mkdir -p ${ZEPPELIN_HOME}/logs && mkdir -p ${ZEPPELIN_HOME}/run \
    && rm -f ${ZEPPELIN_PKG_NAME}.tgz

#### ---- default config is ok ----
#COPY conf/zeppelin-site.xml ${ZEPPELIN_HOME}/conf/zeppelin-site.xml
#COPY conf/zeppelin-env.sh ${ZEPPELIN_HOME}/conf/zeppelin-env.sh
COPY worker.sh /

#### ---- SparkR ----
# TO-DO if needed
# (see https://github.com/rocker-org/rocker/blob/master/r-base/Dockerfile)
#RUN apt-get install r-base -y
ENV R_BASE_VERSION 3.4.1

## Now install R and littler, and create a link for littler in /usr/local/bin
## Also set a default CRAN repo, and make sure littler knows about it too
RUN apt-get update \
	&& apt-get install -t unstable -y --no-install-recommends \
		littler \
                r-cran-littler \
		r-base=${R_BASE_VERSION}* \
		r-base-dev=${R_BASE_VERSION}* \
		r-recommended=${R_BASE_VERSION}* \
        && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
        && echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r \
	&& ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
	&& ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
	&& ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
	&& ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
	&& install.r docopt \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
&& rm -rf /var/lib/apt/lists/*

#RUN mkdir -p ${ZEPPELIN_HOME}/data

#### ---- Debug ----
RUN ls -al /usr/lib/zeppelin/bin \
    && ls -al /usr/lib/zeppelin/notebook \
    && ls -al /usr/lib/zeppelin/bin/zeppelin-daemon.sh

VOLUME ${ZEPPELIN_HOME}/notebook
VOLUME ${ZEPPELIN_HOME}/conf
VOLUME ${ZEPPELIN_HOME}/data

EXPOSE ${ZEPPELIN_PORT}

#ENV SPARK_SUBMIT_OPTIONS "--jars /opt/zeppelin/sansa-examples-spark-2016-12.jar"

WORKDIR ${ZEPPELIN_HOME}

CMD ["/usr/lib/zeppelin/bin/zeppelin.sh"]



