## Automatic Installation ##

 This process is needed some package to be installed on the Syclops host machine to run the Syclops installation script. We keep all the source code which uses for the Syclops on our local and public git server. The installation script was being created based on Git and Drush. So that we need to install the following package before running the Syclops installation scripts.

 >
 > * php5.3
 > * php-pear
 > * drush
 > * git-core
 >
 
 To install following packages php5-cli and php5-json on the Syclops host machine to use below command.

 >**apt-get install php5-cli php5-json php-pear git-core**

 The above package are dependency for the Drush. After installing the above packages. To install the Drupal shell to use following command

 >**pear channel-discover pear.drush.org**
 >
 >**pear install drush/drush**
 >
 >**pear install Console_Table**
 >

 Once installed drush, check your php version. If php version is 5.5 then, you have to update php.ini file. Because the Drush uses some php restricted function. If you get any error, you have to comment out the restricted function section in your php.ini. Otherwise the Syclops stack installer script does not work.

 After installing the Drush, you have to create ssh public key for root user account and update the key in our code repository server. We need to update public key because we keep all the Syclops related script and source code on our repository server. 

   
 After installing the Docker and download the Syclops stack creation tool from our repository server.

 >**cd /opt/**
 >
 >**git clone https://bitbucket.org/syclops/syclops_main.git**
 >

 After downloading the tool and go inside the tool's root directory and run the setup.sh scripts that creates Syclops required directory and installs Syclops required packages.

 Run ths create_images.sh script that creates the Syclops base image, Syclops Database, Syclops UI and Syclops Terminal container by using various script. This process will take 35 minutes and above to finish the installation based on your network speed.

 Finally run the create_container.sh script. It creates the Syclops container and links together.