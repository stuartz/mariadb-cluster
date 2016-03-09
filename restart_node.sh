#!/bin/bash
# used to restart/upgrade a previously initialized node
node=node"$1"
if [ "$#" -lt 1 ]
then
	echo "need 3 args( IP pwd node#)... 10.0.0.3 password 1 [docker-machine-name]"
	exit
fi

if [ "$#" -gt 1 ]
then
	# use docker-machine to run scripts remotely.
	echo "sudo  $(sudo chown 999:docker /data -R)" | $(docker-machine ssh $2)
	eval $(docker-machine env $2)
#else
	sudo chown 999:docker /data
fi

#first node
docker stop $node
docker rm $node
docker pull vernonco/mariadb-cluster
docker run \
  --name $node \
  -v /data:/var/lib/mysql \
  -v /home/ubuntu/certs:/var/lib/mysql/ssl \
  -e MYSQL_INITDB_SKIP_TZINFO=yes \
  -e MYSQL_ROOT_PASSWORD=$my_pwd \
  -e TERM=xterm \
  -d \
  -p 3306:3306 \
  -p 4444:4444 \
  -p 4567:4567/udp \
  -p 4567-4568:4567-4568 \
  vernonco/mariadb-cluster \
  mysqld