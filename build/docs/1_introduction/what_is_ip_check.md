# What is IP Check? #

 Whenever Docker container is started, the docker will assign new ip addres for contianer. Syclops UI container does not know the new IP address, so we create this script to get new ip address of the container. IP Check is small bash script. It's main task is to update container IP address in /share folder. The each Syclops container consists this script. The script runs when container start and restart. 
