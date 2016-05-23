## Syclops Container Management ##

 This document could help to manage the container of the Syclops. We assigned name to the each container so that we can easily start and stop the container by using name. For example:

 >
 > **i.e) docker stop terminal**
 >

 Start a container to use following command.

 >
 >**docker start `<container-name>`**
 >

 Stop a container to use following command   

 >
 >**docker stop `<container-name>`**   
 >

 Restart a container to use the following command

 >
 > **docker restart `<container-name>`**
 >

 If you want to access the running container to use the following command.

 >
 >**C_PID=$(docker inspect --format '{{.State.Pid}}' <your container name> )**
 >

 The above command lists out whole information about the container. For example container IP address, container id and so on. From the list to take container IP which is unique for each container and use the following command to access the container. 

 >
 >**nsenter --target $C_PID --mount --uts --ipc --net --pid bash**
 >

 >**Notes**: If you want to access the container which you are going to access, that should be running in the system. Otherwise the Docker will show some strange error. Whenever start or stop the container, the IP address of the container will be changed. Please await the stop and start command as much possible because the Syclops stack linked with other container and each container is being communicated by using ip address.
