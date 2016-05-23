## Syclops Terminal image creation

 Gateone is a web terminal. It is being built by using python and tornado web server. It has so many features. Before installing the gateone server, we have to install its required packages. We need to install python, tornado and some other packages in order to gateone server to work. By default python and python-dev package should not be there inside a customized image so we have to install explicitily by using ubuntu package manager. To launch a new container by using following command.

 >
 >**docker run -i -t syclops:syclops_base /bin/bash**
 >

 Install gateone required pacakges to use the following command.

 >
 >**apt-get install python-pip python-dev git-core -y**
 > 

 The above command only installs python package manager and python development related packages. Here we have installed pip which is python package manager. By using this we can install community python module and we can upload your own python module to python community. The Python core should not have all the module which is required for **GateOne**. To install GateOne required module by using below command.

 >
 >**pip install tornado slimit cssmin PIL pyopenssl**
 >

 After installing modules, To download the GateOne source and Syclops plugin from our repository server.

 The gateone plugin directory is ***/opt/gateone/application/terminal/plugins/***. Inorder to our the Syclops UI to communicate with gateone, you have to install the Syclops plugin which developed for the Gateone. We have to put the Syclops plugin inside the plugin directory which we have mentioned above.

 Install the GatOone source by using the following command. Before issuing the command, make sure that you are in GateOne source directory.

 >
 >**python setup.py install**
 >

 The above command installs the Gateone server in the container. If the GateOne required module is not on the system, the command execution will be stoped and ask you to install the required module. After successfully installing gateone then you have to do some work. 

 Enable gateone listen port by using gateone setting file. Gateone has various configuration files inside the directory called ***/opt/gateone/settings/***. Go inside the directory and open the file named **XXserver.conf** and change listen port 443 into 7443.

 To enable Gateone api authentication, we have to create api key and enable default authentication method to api. You do this to use the following command.

 >
 >**/opt/gateone/gateone/py --new_apikey**
 >

 The above command line creates new api and secret key on file named **XX.api_key** inside the gateone settings directory which we have mentioned above. To open **XX.authentication.conf*** file from the directory called **/opt/gateone/settings/** and change authentication method none to api.


 Install supervisord and enable the GatOne by using following command.

 >
 >**apt-get install supervisord**
 >

 After installing supervisord and go into supervisord configuration file which is located in ***/etc/supervisor/supervisord.conf***. To append the following line bottom of the **supervisord.conf** file by using following command.

 >
 >**[program:gateone]**
 >
 >**command=/opt/gateone/gateone.py**
 >

 To change current working directory to / and create ip_check.sh by using following content .

 >
 >**ip_check.sh**
 >
		#!/bin/bash 
		#get ip address of the container
		pattern=$(ifconfig | awk '{print $2}' | head -n 2 | tail -n 1)
		ip=$(echo $pattern | sed -r 's/[a-z:]+/''/ig')
		#validates the ip address is valid or not
		if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
		        #checks shared folder is exists or not
		        if [[ -d "/share" ]];then
			  		if [[ ! -f "/share/terminal" ]];then
				 		echo $ip > /share/terminal
						old_ip="0"
					else
						echo $ip > /share/terminal
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

 To update the new configuration of the supervisord by using followoing command.

 >
 >**supervisorctl reread**
 > 

 Open a new terminal and enter following command

 >
 >**docker ps -a**
 >

 Get the running container id from the above command output and create the Syclops terminal image by using following command.

 > 
 >**docker commit -run='{"Cmd":["/usr/bin/surpervisord","-n"],"Portspec":"7443", "Volumes":["/var/www/syclops/sites/defaults/files/playbacks", "/opt/gateone"]}' `<container-id>` syclops:syclops_term**
 > 

 The above command will take some moments to finish. After finish image creation and go to previous terminal which we used to create a image. Type exit command to terminate the container. After terminate the container and type following command to remove unused container. By default docker will keep the all terminated container on disk, so we have to remove explicitily by using docker container remove command.

 >
 >**docker rm container-id**
 >

### Syclops Terminal container creation ###

 Create a syclops terminal container by using the syclops_term image which we have created before by using following command. 

 >
 >**docker run -i -d -name terminal -link database:db -p 7443:7443 -v /share:/share -t syclops:syclops_term**
 >

 Verify the terminal container is running  or not by using following command.
 
 >
 >**docker ps -a**