## Syclops Base image creation ##
 
 Our Syclops Docker image is being created by using the phusion/baseimage:0.9.9. Before we are going to create the Syclops base image make sure that the system have phusion/baseimage:0.9.9. If image is not found then to download Uphusion/baseimage:0.9.9 image from the docker images repository. This is the link https://index.docker.io/ to download docker images. We recommended to choose phusion/baseimage:0.9.9 image.  To download phusion/baseimage:0.9.9 image from docker.io to use following command. The docker requires super user privilege in order to run docker command. We can't do any operation without sudo permission in Docker.

 >**docker pull phusion/baseimage:0.9.9**

 The above command will take 30 minutes to complete the download. While downloading process is progressing, To keep your Internet speed as stable. Don't do any other downloading. The docker download manager will throw strange error if the download is fail. After complete the download, you can verify the image which you have downloaded before by using following command.

 
 >**docker images**
 
 Now you could see image and its version details so on. Whenever you download new images, you will use this command to verify the image.

 To launch new container by using following commands.

 >**docker run -i -t phusion/baseimage:0.9.9 /bin/bash**

 The above command will launch new container and login in as root. By default the container does not have command which we mostly uses in Linux system. It will have basic Linux command. Mean while, It is a lightweight Linux image. The default /etc/apt/source.list file only consists the ubuntu main repository link. By using main repository, we can't install some other package which are available on multiverse and universe so on. So we have to update “/etc/apt/source.list” with appropriate sources.list file. Which means, If suppose you are choosing ubuntu:12.04 then you have to update source.list file with ubuntu:12.04 source.list file. After updating repository on /etc/source.list then update the local package cache by using 'apt-get update' command. Install tools which are useful to debug an issue such as ping, netstat and so on by using following command. 
 
 >**apt-get install  less vim nettools-netstat software-properties-common python-software-properties build-essential**
 >

 The above packages are very important to functioning some services such as php5-fpm, nginx and so on. After required packages was being installed on container then create a new customized images from the container. Dont' close current terminal and Don't type exit command. To open a terminal and login as a root into your VM which you have created before. To run following command. 

 >
 >**docker ps -a**
 > 

 You could see current running container details. To take container id from the list. To create a new image from the current running container by using following command.

 > 
 >**docker commit `<container-id> <container-name:container-tag>`**
 > 
 >i.e)  docker commit 34ekdserdslk3fd syclops:syclops_base
 > 

 After issuing above command that will take some time to create new image. If finish the image creation process then it will return some unique id which is combination of character and number. This is the lxc-container id for your newly created images. Now go into to your container which you have been launching before you start to create a new images and type exit command, then the new container will be terminated but container used data will be there on your system. The old container data that we are not going to use it anymore. So that we have to remove the container manually by container id.

 To take container id by using following command.

 >
 >**docker ps -a**
 > 

 To remove unused container from the disk by using following command.

 > 
 >**docker rm `<container-id>`**
 > 
 
 > **Notes**: If you try to remove running container, you wouldn't able to do it. So first you have to stop container then you do the container remove command. To stop a container to use the following command. docker stop **`<container-id> or <container-name>`**

