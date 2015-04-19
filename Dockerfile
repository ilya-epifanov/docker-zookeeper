FROM debian:wheezy

MAINTAINER Ilya Epifanov <elijah.epifanov@gmail.com>

RUN apt-get update && apt-get install -y curl ca-certificates --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$(dpkg --print-architecture)" \
        && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$(dpkg --print-architecture).asc" \
        && gpg --verify /usr/local/bin/gosu.asc \
        && rm /usr/local/bin/gosu.asc \
        && chmod +x /usr/local/bin/gosu

ENV ZOOKEEPER_VERSION=3.4.5

COPY cloudera.pref /etc/apt/preferences.d/cloudera.pref
COPY cloudera.list /etc/apt/sources.list.d/cloudera.list
COPY cloudera.key /tmp/cloudera.key

RUN groupadd -r zookeeper && useradd -r -d /var/lib/zookeeper -m -g zookeeper zookeeper

RUN apt-key add /tmp/cloudera.key &&\
    apt-get update &&\
    apt-get install -y openjdk-7-jre-headless "zookeeper-server=$ZOOKEEPER_VERSION+*" --no-install-recommends &&\
    dpkg-reconfigure ca-certificates-java &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH /usr/lib/zookeeper/bin:$PATH

VOLUME /var/lib/zookeeper /etc/zookeeper

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 2181 2888 3888
CMD ["zookeeper-server", "start-foreground"]
