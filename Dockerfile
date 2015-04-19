FROM ubuntu:14.10

ENV ZOOKEEPER_VERSION=3.4.5

COPY cloudera.pref /etc/apt/preferences.d/cloudera.pref

RUN apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y wget openjdk-8-jre-headless --no-install-recommends &&\
    dpkg-reconfigure ca-certificates-java &&\
    (wget http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key -O - | apt-key add -) &&\
    wget 'http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/cloudera.list' -O /etc/apt/sources.list.d/cloudera.list &&\
    apt-get update &&\
    apt-get install -y "zookeeper-server=$ZOOKEEPER_VERSION+*" --no-install-recommends &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /var/lib/zookeeper /etc/zookeeper

EXPOSE 2181 2888 3888
CMD ["zookeeper-server"]
