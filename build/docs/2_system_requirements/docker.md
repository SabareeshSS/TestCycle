## Docker ##
 
### What is Docker ? ###

 Docker is a tool which allows to manage the lxc-container. It is a linux container which allows us to separate specific process from hostname by using process virtualization. If you want to learn more about lxc container. please visit this url http://linuxcontainers.org/. Here you can learn more about lxc. Docker is a front end tool for lxc and it is REST API client to create and manage the lxc container. If you want to create lxc container, you have to follow so many steps and so many instruction in order to create a container. So avoid those chores, we uses the Docker. The Docker has so many features. This document is not enough to tell all those features. If you want to learn more about Docker, Our suggestion is that you just visit the Docker official site. The site url is https://www.docker.io/. There you may see lot of tutorials and documentation to learn about the Docker.

### What is Docker image? ###

 Docker image file is a lightweight OS image. It consists of usefull binary files that is usefull to boot up operating system. By using the operating system image, we could create lxc-container. Docker maintains their own image repository. It is free. From that repository we could download any flavor of Linux and Uninx like operating system images. We could upload and maintain our own docker repository. The Docker image respository url is https://index.docker.io/.  

### What is Docker container? ###

 Docker container is a virtual machine which consists the particular process binary and it's supported library. The Docker container is being created by using the Docker images. All the Docker container shares Linux kernel of the host machine  while It boots up. It takes less amount of time to boot up the machine. By using running the Docker container, we could create the Docker image. The Docker image creation instruction will be there on the Syclops installation section. 
