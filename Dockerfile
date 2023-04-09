FROM openjdk:8
MAINTAINER Rubens Minoru Andako Bueno <rubensmabueno@hotmail.com>

USER root

ENV APP_HOME /opt

RUN set -ex

# Installing JMX Exporter
ENV JMX_PROMETHEUS_JAVAAGENT_VERSION 0.3.1
ENV JMX_PROMETHEUS_JAVAAGENT_HOME /opt/jmx_prometheus_javaagent
ENV JMX_PROMETHEUS_JAVAAGENT_PORT 5556
ENV JMX_PROMETHEUS_JAVAAGENT_CONFIG ${JMX_PROMETHEUS_JAVAAGENT_HOME}/config.yml

RUN mkdir -p ${JMX_PROMETHEUS_JAVAAGENT_HOME} && \
    curl -s https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_PROMETHEUS_JAVAAGENT_VERSION}/jmx_prometheus_javaagent-${JMX_PROMETHEUS_JAVAAGENT_VERSION}.jar > ${JMX_PROMETHEUS_JAVAAGENT_HOME}/jmx_prometheus_javaagent.jar

# Installing Hadoop
ENV HADOOP_VERSION 2.10.2
ENV HADOOP_HOME $APP_HOME/hadoop
ENV HADOOP_CONF_DIR /etc/hadoop

RUN curl -fSL https://dlcdn.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -o hadoop-$HADOOP_VERSION.tar.gz && \
    tar -xzf hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION $HADOOP_HOME && \
    rm hadoop-$HADOOP_VERSION.tar.gz && \
    wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/$HADOOP_VERSION/hadoop-aws-$HADOOP_VERSION.jar -P $HADOOP_HOME/share/hadoop/common/lib/ && \
    wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.271/aws-java-sdk-bundle-1.11.271.jar -P $HADOOP_HOME/share/hadoop/common/lib/

RUN mkdir -p /hadoop/dfs/name && mkdir -p /hadoop/dfs/data

# Copy default configs
ADD config/core-site.xml /etc/hadoop/core-site.xml
ADD config/hdfs-site.xml /etc/hadoop/hdfs-site.xml
ADD config/hadoop-metrics2.properties /etc/hadoop/hadoop-metrics2.properties

ENV PATH $HADOOP_HOME/bin/:$PATH

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
