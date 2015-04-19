#!/bin/bash
set -e

if [ "$1" == 'zookeeper-server' ] || [ "$1" == 'zookeeper-server-initialize' ]; then
        mkdir -m a=rx,u=rwx /var/run/zookeeper
	chown -R zookeeper /var/{lib,run,log}/zookeeper
	set -- gosu zookeeper "$@"
fi

exec "$@"
