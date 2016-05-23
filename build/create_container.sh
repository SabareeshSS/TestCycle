#!/bin/bash
# File :create_container.sh
# Author : Chandrasekaran "<chandrasekaran@thebw.in>"
# Description: Syclops Stack Setup
#
# Help: To access a running docker container to use following command
#
# 	C_PID=$(docker inspect --format '{{.State.Pid}}' <your container name> )
#
# 	nsenter --target $C_PID --mount --uts --ipc --net --pid bash
#
# Creates database container and syclops user
#
DATABASE=$(docker run -i -d --name database -v /syclops/database:/var/lib/mysql -v /share:/share -t syclops/syclops_db)
#
# Set timeout for 15 inorder to mysql deamon to start.
#
sleep 25
echo "Syclops Database container started."
#
# Creates Syclops user and database
#
DATABASE_PID=$(docker inspect --format '{{.State.Pid}}' $DATABASE)
DATABASE_PASS=$(nsenter --target $DATABASE_PID --mount --uts --ipc --net --pid /syclops_user_create.sh)
sleep 2
#
# Creates Terminal container
#
docker run -i -d -p 7443:7443 --name term -v /syclops/terminal:/etc/gateone -v /syclops/playbacks:/var/www/syclops/sites/default/files/playbacks -v /share:/share -t syclops/syclops_trm
#
# Set timeout for 10 inorder to install GateOne application.
#
sleep 10
echo "Syclops Terminal container started"
#
# Creates UI container
#
UI_CONTAINER=$(docker run -i -d -p 80:80 -p 443:443 --volumes-from term -v /syclops/ui/:/var/www/syclops:rw -v /syclops/playbacks:/var/www/syclops/sites/default/files/playbacks -v /share:/share --name ui --link database:db -t syclops/syclops_ui)
#
# Install Syclops UI
#
echo "Syclops UI container started"
#
UI_PID=$(docker inspect --format '{{.State.Pid}}' $UI_CONTAINER)
nsenter --target $UI_PID --mount --uts --ipc --net --pid /drush_script.sh $DATABASE_PASS
#

