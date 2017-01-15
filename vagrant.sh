#!/usr/bin/env bash

#locale-gen UTF-8
#sh -c "echo -e 'LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8' > /etc/default/locale"

apt-get update
apt-get -y autoremove
apt-get -y upgrade
apt-get -y install memcached redis-server openjdk-7-jre-headless

sed -i 's/bind\ 127.0.0.1//' /etc/redis/redis.conf
/etc/init.d/redis-server restart

sed -i 's/-l 127.0.0.1//' /etc/memcached.conf
service memcached restart