# What is IP Change? #
 
 It is a small bash script that updates Syclops Database container IP address in Syclops UI container. Syclops UI container count on database container because Syclops UI container stores all datas including user, session, project, grant and connection in it. Each Syclops component talk each others by using IP address. The IP Address of the running Docker container is not static. The address will change while start and stop container. If the database container is stopped then Syclops UI container whould not work. The script will checks each container IP address all along and updates address.