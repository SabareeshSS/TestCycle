## Syclops Database image creation ##

 To start a new container by using our customized the Syclops base image. If you are not sure about the image name, you can use the following command to get images name.

 >
 >**docker images**
 >

 To take our customized image name from the list then run following command.

 >
 >**docker run -i -t syclops:syclops_base /bin/bash**
 >

 In order to install the Percona, To update the Percona repository details on /”etc/apt/sources.list” file by using below command. 

 > 
 >**apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A**
 >
 >**add-apt-repository 'deb http://repo.percona.com/apt precise main'**
 >
 > **Notes**
 > >The percona repository details will not be same for all Linux distribution. If you are using different OS than ubuntu:12.04, you will be best to visit the Percona official and take the repository details based upon your OS. 

 After mention about the repository details.  To update new repository package details by issuing following command. 

 >
 >**apt-get update** 
 >

 After updating the Pecona package details and install the Percona server and their required packages by issuing following command.

 >
 >**apt-get install percona-server-server-5.5 percona-server-client-5.5 -y**
 >

 The installation process could take some time. After installing the packages then, the MySQL server will be automatically started. By default MySQL configuration file named my.cnf would not be there inside a /etc/mysql directory. So you have to copy the my.cnf file from /usr/share/mysql directory manually. This directory could have different type of my.cnf file. But our recommendation is my-mendium.cnf file. To copy this file to /etc/mysql folder and rename the file to my.cnf 

 To stop the MySQL service and open my.cnf file by using following command.

 > 
 >**service mysql stop**
 > 
 >**vim /etc/mysql/my.cnf**
 > 

 To append following line below mysqld section on file.
 
 > 
 >**bind-address = 0.0.0.0**
 > 
 > **Notes**
 > >Now we are able to access the MySQL server from other container. Don't do this host only installed machine because it is a security risk. We are doing here, because we are using lxc-container. So we can block port access from outside of the container.

 Save and close file and to start the MySQL service by using service comamnd.

 >
 >**service mysql start**
 >

 To create new database named syclops and create new user named syclops by using following command.

 > 
 >**mysql -u root -p**
 > 
 >**create database syclops;**
 > 
 >**create user 'syclops'@'%' identified by 'your password';**
 > 

 To grant privilege to syclops user to access syclops database by using following command.

 >
 >**grant usage on *.* to 'syclops'@'%' identified by 'your password';**
 >
 >**grant all privileges on syclops.* to 'syclops'@'%';**  
 >

 If you want to run a deamon service inside a container, you have to install superviord which is a process controller deamon inside a container and tell about your service which is deamon service to supervisord.

 To install supervisord by using following command.

 >
 >**apt-get install supervisord**
 >

 After installing supervisord then update the MySQL binary path. Open supervisord configuration from /etc/superviorsd/supervisor.conf and append following line at end of the file.

 >
 >**[program:mysql]**
 >
 >**command=/usr/bin/mysqld_safe**
 >

 To change current working directory to / and create ip_check.sh by using following content .

 >
 >**ip_check.sh**

		#!/bin/bash 
		#get ip address of the container
		pattern=$(ifconfig | awk '{print $2}' | head -n 2 | tail -n 1)
		ip=$(echo $pattern | sed -r 's/[a-z:]+/''/ig')
		#validates the ip address is valid or not
		if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
		        #checks shared folder is exists or not
		        if [[ -d "/share" ]];then
			  		if [[ ! -f "/share/database" ]];then
				 		echo $ip > /share/database
						old_ip="0"
					else
						echo $ip > /share/database
					fi
		        else
		                echo "Shared folder not found."
		        fi
		fi
		exit 0

 Update exetuable file permission for the script.

 Update the supervisord configuration by using following contents.

		[program:ip_check]
		command=/ip_check.sh
		autorestart=false
		startretries=0
		priority=1

 To update the new configuration of supervisord by using followoing command.

 >
 >**supervisorctl reread**
 > 

### Syclops Database image creation by using running container ###

 To open new terminal and issue following command

 >
 >**docker ps -a**
 >

 To get the running container id from the above command output and create database container by using following command.

 >
 >**docker commit -run='{"Cmd":["/usr/bin/surpervisord","-n"]}' `<container-id>` syclops:syclops_db**
 >

 The above command will take some moments to finish. After finish image creation and go to previous terminal which we used to create a image. To type exit command to exit from the container. After exit from the container and type following command to remove unused container.

 >
 >**docker rm `<container-id>`**
 > 

### Syclops Database container creation ###

 Create a sshxy database container by using syclops_db image which we have created before by using following command. 

 > 
 >**docker run -i -d -name database -v /share:/share -t syclops:syclops_db**
 >

 To verify the database container is running  or not by using following command.

 >
 >**docker ps -a**
