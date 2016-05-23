# What is Docker #

 Docker is an application which allows us to manage the lxc-container. Syclops uses the Docker to run its components such Syclops UI, Syclops Terminal and Syclops Database. Each Syclops component is designed to run inside Docker container. Syclops component has relationship with each other. For instance, Syclops UI container depends on database and termial container. If one component is failt to start then other component will not work.
