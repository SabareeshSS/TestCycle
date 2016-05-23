## Syclops UI image creation ##

### Nginx Installation ###

 Nginx is a webserver. To install a nginx to launch our customized image which we have created before by using following command.

 >
 >**docker run -i -t syclops:syclops_base /bin/bash**
 >
 
 After successfully launch new container to update latest nginx repository. By using following command.

 >
 >**apt-get install software-properties-common -y**
 >
 >**add-apt-repository ppa:nginx/stable -y**
 >

 After updating the repository details to update local package cache by using following command.

 > 
 >**apt-get update**
 >

 To install a nginx pacakge to use following command.

 >
 >**apt-get install nginx-extras**
 >
 > **Note:**: Here we choose nginx-extras because some useful nginx modules are not available in `core nginx package`.
 >

 The above command installs nginx-extras package. Next process is to configure nginx by using various configuration files which we created for nginx. To go to your nginx configuration directory which is found in "/etc/nginx/" and create a new file called fastcgi_drupal.conf with following content.

		fastcgi_param QUERY_STRING q=$uri&$args;
		fastcgi_param REQUEST_METHOD $request_method;
		fastcgi_param CONTENT_TYPE $content_type;
		fastcgi_param CONTENT_LENGTH $content_length;
		fastcgi_param SCRIPT_NAME /index.php;
		fastcgi_param REQUEST_URI $request_uri;
		fastcgi_param DOCUMENT_URI $document_uri;
		fastcgi_param DOCUMENT_ROOT $document_root;
		fastcgi_param SERVER_PROTOCOL $server_protocol;
		fastcgi_param GATEWAY_INTERFACE CGI/1.1;
		fastcgi_param SERVER_SOFTWARE nginx/$nginx_version;
		fastcgi_param REMOTE_ADDR $remote_addr;
		fastcgi_param REMOTE_PORT $remote_port;
		fastcgi_param SERVER_ADDR $server_addr;
		fastcgi_param SERVER_PORT $server_port;
		fastcgi_param SERVER_NAME $server_name;
		fastcgi_param REDIRECT_STATUS 200;
		fastcgi_param SCRIPT_FILENAME $document_root/index.php;
		fastcgi_param HTTPS $https if_not_empty;
		fastcgi_buffers 256 4k;
		fastcgi_intercept_errors on;
		fastcgi_read_timeout 14400;
		fastcgi_index index.php;
		fastcgi_hide_header 'X-Drupal-Cache';
		fastcgi_hide_header 'X-Generator';

 Update nginx.conf file with the following content.

		user www-data;
		error_log /var/log/nginx/error.log;
		pid /var/run/nginx.pid;
		worker_processes 1;
		events {
		    worker_connections 700;
		    multi_accept on;
		}

		http {
		    variables_hash_max_size 1024;
		    include /etc/nginx/mime.types;
		    default_type application/octet-stream;
		    include /etc/nginx/fastcgi.conf;
		    access_log /var/log/nginx/access.log;
		    error_log /var/log/nginx/error.log;
		    sendfile on;

		    set_real_ip_from 0.0.0.0/32;
		    real_ip_header X-Forwarded-For;

		    client_body_timeout 60;
		    client_header_timeout 60;
		    keepalive_timeout 10 10;
		    send_timeout 60;
		    reset_timedout_connection on;
		    client_max_body_size 10m;
		    tcp_nodelay on;
		    tcp_nopush on;

		    gzip on;
		    gzip_buffers 16 8k;
		    gzip_comp_level 1;
		    gzip_http_version 1.1;
		    gzip_min_length 10;
		    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript image/x-icon application/vnd.ms-fontobject font/opentype application/x-font-ttf;
		    gzip_vary on;
		    gzip_proxied any;
		    gzip_disable msie6;
		    
		    server_tokens off;
		    ssl_session_cache shared:SSL:10m;
		    ssl_session_timeout 10m;
		    ssl_prefer_server_ciphers on;
		    ssl_ciphers ECDHE-RSA-AES256-SHA:DHE-RSAAES256-SHA:DHE-DSS-AES256-SHA:DHE-RSA-AES128SHA:DHE-DSS-AES128-SHA;
		    ssl_protocols SSLv3 TLSv1;
		    add_header X-Content-Options nosniff;
		    upload_progress uploads 1m;
		    #Upstream uninx socket configuration
		    upstream phpcgi {
		    	least_conn;
		    	server unix:/var/run/php5-fpm.sock;
		    	#server unix:/var/run/php5-fpm-zwei.sock;
		    	keepalive 5;
		 	}
		 	
		 	#upstream phpcgi_backup {
		    #	server unix:/var/run/php5-fpm-bkp.sock;
		    #	keepalive 1;
			#}

			#Upstream tcp socket configuration
			#upstream phpcgi {
			#	least_conn;
		    #	server 127.0.0.1:9001;
		    #	server 127.0.0.1:9002;
		    #	keepalive 5
			#}
			#upstream phpcgi_backup {
		    #	server 127.0.0.1:9003;
		    #	keepalive 1;
			#}
		    geo $dont_show_nginx_status {
		        default 1;
		        127.0.0.1 0; # allow on the loopback
		        192.168.1.0/24 0; # allow on an internal network
		    }

		    geo $not_allowed_cron {
		 	   	default 1;
		       	127.0.0.1 0; # allow the localhost
		    	10.0.1.0/24 0; # allow on an internal network
			}

			map $http_user_agent $bad_bot {
		    	default 0;
		    	~*^Lynx 0; # Let Lynx go through
		    	libwww-perl                      1;
		    	~(?i)(httrack|htmlparser|libwww) 1;
			}

			map $http_referer $bad_referer {
		    	default 0;
		    	~(?i)(adult|babes|click|diamond|forsale|girl|jewelry|love|nudit|organic|poker|porn|poweroversoftware|sex|teen|webcam|zippo|casino|replica) 1;
			}

		    map $request_method $not_allowed_method {
		    	default 1;
		    	GET 0;
		    	HEAD 0;
		    	POST 0;
			}
			
			include /etc/nginx/sites-enabled/*;
		}

 Update fastcgi.conf file with the following contents.

		include fastcgi_params;
		fastcgi_buffers 256 4k;
		fastcgi_intercept_errors on;
		fastcgi_read_timeout 14400;
		fastcgi_index index.php;
		fastcgi_hide_header 'X-Drupal-Cache';
		fastcgi_hide_header 'X-Generator';`**

 Go into **/etc/nginx/sites-enabled** directory and delete the default nginx vhost file named default.conf. In same directory to create new virtualhost file named syclops.conf with following file content.

		server {
		    listen 80; 
		    server_name example.com;
		    rewrite ^ https://$server_name$request_uri? permanent;
		}

		server {
			listen 443 ssl;
			server_name example.com;
			access_log /var/log/nginx/example.com_access.log;
			error_log /var/log/nginx/example.com_error.log;
		  	keepalive_timeout 75 75;
		    
		  ssl_certificate /etc/ssl/certs/example-cert.pem;
		  ssl_certificate_key /etc/ssl/private/example.key;
		  add_header Strict-Transport-Security "max-age=7200";
		    
		  root /var/www/sites/example.com;
		  index index.php;
		  fastcgi_keep_conn on;

		  if ($bad_bot) {
		      return 444;
		  }

		  if ($bad_referer) {
		        return 444;
		   }

		  if ($not_allowed_method) {
		       return 405;
		  }

			location / {
				location ^~ /system/files/ {
					include /etc/nginx/fastcgi_drupal.conf;
			    	fastcgi_pass phpcgi;
			    	log_not_found off;
				}

				location ^~ /sites/default/files/private/ {
			    	internal;
				}

				location ^~ /system/files_force/ {
			    	include /etc/nginx/fastcgi_drupal.conf;
			    	fastcgi_pass phpcgi;
			  	  log_not_found off;
				}

				location ~* /imagecache/ {
			  	  access_log off;
			    	expires 30d;
			    	try_files $uri @drupal;
				}

				location ~* /files/styles/ {
			  	  access_log off;
			    	expires 30d;
			    	try_files $uri @drupal;
				}

				location ~* ^.+\.(?:css|cur|js|jpe?g|gif|htc|ico|png|html|xml|otf|ttf|eot|woff|svg)$ {
			  	  access_log off;
			    	expires 30d;
			    	tcp_nodelay off;
			    	open_file_cache max=3000 inactive=120s;
			    	open_file_cache_valid 45s;
			    	open_file_cache_min_uses 2;
			    	open_file_cache_errors off;
				}

				location ~* ^(?:.+\.(?:htaccess|make|txt|engine|inc|info|install|module|profile|po|pot|sh|.*sql|test|theme|tpl(?:\.php)?|xtmpl)|code-style\.pl|/Entries.*|/Repository|/Root|/Tag|/Template)$ {
			      return 404;
			  }

				location ^~ /help/ {
			  	  location ~* ^/help/[^/]*/README\.txt$ {
			    	    include /etc/nginx/fastcgi_drupal.conf;
			      	  fastcgi_pass phpcgi;
			    	}
				}
				try_files $uri @drupal;
		  }

			location @drupal {
		    	include /etc/nginx/fastcgi_drupal.conf;
		    	fastcgi_pass phpcgi;
		    	track_uploads uploads 60s;
			}

			location @drupal-no-args {
		    	include /etc/nginx/fastcgi_drupal.conf;
		    	fastcgi_pass phpcgi;
			}

			location ^~ /.git {
		    	return 404;
			}

			location ^~ /.hg {
		    	return 404;
			}

			location ^~ /backup {
		    	return 404;
			}
			location ^~ /patches {
		    	return 404;
			}

			location = /rss.xml {
		  	  try_files $uri @drupal-no-args;
			}

			location = /sitemap.xml {
		    try_files $uri @drupal-no-args;
			}

			location = /robots.txt {
		    access_log off;
		    try_files $uri @drupal-no-args;
			}

			location = /favicon.ico {
		    expires 30d;
		    try_files /favicon.ico @empty;
			}

			location @empty {
		    expires 30d;
		    empty_gif;
			}
			
			location ~* ^.+\.php$ {
		    	return 404;
			}

			location ~ (?<upload_form_uri>.*)/x-progress-id:(?<upload_id>\d*) {
		    	rewrite ^ $upload_form_uri?X-Progress-ID=$upload_id;
			}

			location ^~ /progress {
		    	upload_progress_json_output;
		    	report_uploads uploads;
			}

			#Cron update
			location = /xmlrpc.php {
		    	fastcgi_pass phpcgi;
			}

			location = /cron.php {
		    	if ($not_allowed_cron) {
		        	return 404 /;
		    	}
		    	fastcgi_pass phpcgi;
		    }

		  	location = /authorize.php {
		    	fastcgi_pass phpcgi;
			}

			#location = /apc.php {
		    #            fastcgi_pass phpcgi;
		    #}

			location = /update.php {
		    	auth_basic "Restricted Access"; # auth realm
		    	auth_basic_user_file .htpasswd-users; # htpasswd file
		    	fastcgi_pass phpcgi;
			}
		}

 After creation of syclops virtualhost file and update **example.com** domain with your fqdn on syclops.conf file. create webroot directory and change directory ownership to www-data user by using following command.

 >
 >**mkdir -p /var/www/syclops**
 >
 >**chown -R /var/www/syclops**
 >
 
 ### Php5-fpm Installation ###

 php5-fpm is a cgi deamon service which runs all requested php file and returns the output of it. To install a php5-fpm package to use following command.

 >
 >**apt-get install -y curl libcurl3 libcurl3-dev libpcre3-dev**
 >
 >**apt-get install php5-cli php5-curl php5-fpm php5-mysql php5-gd**
 >

 The above command installs php5 and required extensions. The above command will take some moments to finish the installation. After successfully installing php5-fpm packages, the php5-fpm deamon will be started automatically. you can verify the running service by typing following command.

 >
 >**netstat -ntl**
 >

 The above command lists out the all open port in the system. Make sure that port 9001 have opened or not. This is the default port for php5-fpm service. You could see some other port which is used by different service. To install supervisord package by using following command.

 >
 >**apt-get install supervisord**
 >

 After installing **supervisord** to update nginx and php5-fpm command details to start service automatically by using following comamnd. Open **/etc/supervisord/supervisor.conf** and append the following line bottom of the file.

 >
 >**[program:nginx]**
 >
 >**command=/usr/sbin/nginx**
 >
 >**[program:php5-fpm]**
 >
 >**command=/usr/sbin/php5-fpm**
 >

 Update the new configuration of supervisord by using followoing command.

 >
 >**supervisorctl reread**
 >

### Drush Installation ###

 Drush is command line shell for drupal. To install drupal shell to use following command.

 >
 >**apt-get install php-pear -y**
 >

 The above command installs php package manager. Enable drush repository and install drush and required packages by using below command.

 >
 >**pear channel-discover pear.drush.org**
 >
 >**pear install Console_Table**
 >
 >**pear install drush/drush**
 >

 After installing drush to test drush is being installed properly or not by using following commands.

 >
 >**drush -h**
 >

### Syclops source installation ###

 Go into the Syclops web root directory that we have created while installing nginx package and download the Syclops source by using syclops.make file. To create a syclops.make file with following content and keep file insde the Syclops web root directory.

		;This file was auto-generated by drush make
		core = 7.x

		api = 2
		projects[drupal][version] = "7.22"

		; Modules
		projects[views_bulk_operations][subdir] = "contrib"
		projects[views_bulk_operations][version] = "3.1"

		projects[admin_menu][subdir] = "contrib"	
		projects[admin_menu][version] = "3.0-rc4"

		projects[auto_nodetitle][subdir] = "contrib"
		projects[auto_nodetitle][version] = "1.0"

		projects[ctools][subdir] = "contrib"
		projects[ctools][version] = "1.2"

		projects[context][subdir] = "contrib"
		projects[context][version] = "3.0-beta6"

		projects[context_og][subdir] = "contrib"
		projects[context_og][version] = "2.1"

		projects[entity][subdir] = "contrib"
		projects[entity][version] = "1.0"

		projects[entityreference][subdir] = "contrib"
		projects[entityreference][version] = "1.0"

		projects[entityreference_prepopulate][subdir] = "contrib"
		projects[entityreference_prepopulate][version] = "1.2"

		projects[features_extra][subdir] = "contrib"
		projects[features_extra][version] = "1.0-beta1"

		projects[features][subdir] = "contrib"
		projects[features][version] = "2.0-beta1"

		projects[field_group][subdir] = "contrib"
		projects[field_group][version] = "1.3"

		projects[flag][subdir] = "contrib"
		projects[flag][version] = "3.0"

		projects[jquery_update][subdir] = "contrib"
		projects[jquery_update][version] = "2.x-dev"

		projects[message][subdir] = "contrib"
		projects[message][version] = "1.8"

		projects[nodeformcols][subdir] = "contrib"
		projects[nodeformcols][version] = "1.x-dev"

		projects[references][subdir] = "contrib"
		projects[references][version] = "2.1"

		projects[og][subdir] = "contrib"
		projects[og][version] = "2.0"

		projects[og_manager_change][subdir] = "contrib"
		projects[og_manager_change][version] = "2.1"

		projects[pathauto][subdir] = "contrib"
		projects[pathauto][version] = "1.2"

		projects[realname][subdir] = "contrib"
		projects[realname][version] = "1.1"

		projects[rules][subdir] = "contrib"
		projects[rules][version] = "2.3"

		projects[smtp][subdir] = "contrib"
		projects[smtp][version] = "1.0"

		; SSHxycore activities
		projects[sshxycore_activities][download][type] = "git"
		projects[sshxycore_activities][download][url] = "git@code.thebw.in:sshxy/sshxycore-activities.git"
		projects[sshxycore_activities][download][branch] = "develop"
		projects[sshxycore_activities][type] = "module"
		projects[sshxycore_activities][subdir] = "sshxy"
		projects[sshxycore_activities][version] = "1.0-beta1"

		; SSHxycore archive
		projects[sshxycore_archive][download][type] = "git"
		projects[sshxycore_archive][download][url] = "git@code.thebw.in:sshxy/sshxycore-archive.git"
		projects[sshxycore_archive][download][branch] = "develop"
		projects[sshxycore_archive][type] = "module"
		projects[sshxycore_archive][subdir] = "sshxy"
		projects[sshxycore_archive][version] = "0.1-dev"

		; SSHxycore connections
		projects[sshxycore_connections][download][type] = "git"
		projects[sshxycore_connections][download][url] = "git@code.thebw.in:sshxy/sshxycore-connections.git"
		projects[sshxycore_connections][download][branch] = "develop"
		projects[sshxycore_connections][type] = "module"
		projects[sshxycore_connections][subdir] = "sshxy"
		projects[sshxycore_connections][version] = "1.0-beta1"

		; SSHxycore grants
		projects[sshxycore_grants][download][type] = "git"
		projects[sshxycore_grants][download][url] = "git@code.thebw.in:sshxy/sshxycore-grants.git"
		projects[sshxycore_grants][download][branch] = "develop"
		projects[sshxycore_grants][type] = "module"
		projects[sshxycore_grants][subdir] = "sshxy"
		projects[sshxycore_grants][version] = "1.0-beta1"

		; SSHxycore log
		projects[sshxycore_log][download][type] = "git"
		projects[sshxycore_log][download][url] = "git@code.thebw.in:sshxy/sshxycore-log.git"
		projects[sshxycore_log][type] = "module"
		projects[sshxycore_log][subdir] = "sshxy"
		projects[sshxycore_log][version] = "1.0-beta1"
		projects[sshxycore_log][download][branch] = "develop"

		; SSHxycore projects
		projects[sshxycore_projects][download][type] = "git"
		projects[sshxycore_projects][download][url] = "git@code.thebw.in:sshxy/sshxycore-projects.git"
		projects[sshxycore_projects][type] = "module"
		projects[sshxycore_projects][subdir] = "sshxy"
		projects[sshxycore_projects][version] = "1.0-beta1"
		projects[sshxycore_projects][download][branch] = "develop"

		; SSHxycore sessions
		projects[sshxycore_sessions][download][type] = "git"
			projects[sshxycore_sessions][download][url] = "git@code.thebw.in:sshxy/sshxycore-sessions.git"
		projects[sshxycore_sessions][type] = "module"
		projects[sshxycore_sessions][subdir] = "sshxy"
		projects[sshxycore_sessions][version] = "1.0-beta1"
		projects[sshxycore_sessions][download][branch] = "develop"

		; SSHxycore UI
		projects[sshxycore_ui][download][type] = "git"
		projects[sshxycore_ui][download][url] = "git@code.thebw.in:sshxy/sshxycore-ui.git"
		projects[sshxycore_ui][type] = "module"
		projects[sshxycore_ui][subdir] = "sshxy"
		projects[sshxycore_ui][version] = "1.0-beta1"
		projects[sshxycore_ui][download][branch] = "develop"

		; SSHxycore users
		projects[sshxycore_users][download][type] = "git"
		projects[sshxycore_users][download][url] = "git@code.thebw.in:sshxy/sshxycore-users.git"
		projects[sshxycore_users][type] = "module"
		projects[sshxycore_users][subdir] = "sshxy"
		projects[sshxycore_users][version] = "1.0-beta1"
		projects[sshxycore_users][download][branch] = "develop"

		; SSHxycore webssh
		projects[sshxycore_webssh][download][type] = "git"
		projects[sshxycore_webssh][download][url] = "git@code.thebw.in:sshxy/sshxycore-webssh.git"
		projects[sshxycore_webssh][type] = "module"
		projects[sshxycore_webssh][subdir] = "sshxy"
		projects[sshxycore_webssh][version] = "1.0-beta1"
		projects[sshxycore_webssh][download][branch] = "develop"

		projects[strongarm][subdir] = "contrib"
		projects[strongarm][version] = "2.0"

		projects[token][subdir] = "contrib"
		projects[token][version] = "1.5"

		projects[unique_field][subdir] = "contrib"
		projects[unique_field][version] = "1.0-rc1"

		projects[views][subdir] = "contrib"
		projects[views][version] = "3.5"

		projects[views_php][subdir] = "contrib"
		projects[views_php][version] = "1.x-dev"

		; SSHxycore Themes
		projects[sshxy][download][type] = "git"
		projects[sshxy][download][url] = "git@code.thebw.in:sshxy/sshxycore-theme.git"
		projects[sshxy][type] = "theme"
		projects[sshxy][version] = "2.0"
		projects[sshxy][download][branch] = "develop"

		; Modules
		projects[sshxycore_private_key][type] = "module"
		projects[sshxycore_private_key][subdir] = "sshxy"
		projects[sshxycore_private_key][download][type] = "git"
		projects[sshxycore_private_key][download][url] = "git@code.thebw.in:sshxy/sshxycore-private-key.git"
		projects[sshxycore_private_key][download][branch] = "develop"

 Before going to run **drush make** command, you have to create public ssh key and put that key in code server where you have the syclops source. otherwise the drush make command should not work. Finally run the following command.

 >
 >**drush make syclops.make**
 >

 The above command will take some time to download all the package.

 After finish above command to create script named drush_script using following code.

			#!/bin/bash
			DATABASE_PASS=$1
			# gets database ip address
			if [[ -f /share/database ]];then
			DATABASE_IP=$(eval echo -e `</share/database`)
			else
			echo "Database container is stoped." 
			exit 0
			fi

			#check drupal is already exists or not
			if [[ -f /.drupal_installed ]];then
			echo "Drupal already installed"
			exit 0
			fi

			#change web root
			cd /var/www/syclops
			drush site-install minimal --yes --db-url=mysql://syclops:$DATABASE_PASS@$DATABASE_IP/syclops --site-name=Syclops --account-name=admin --account-pass=tbw5h0p

			#enable syclops core module
			drush en --yes sshxycore_users sshxycore_projects sshxycore_activities sshxycore_connections sshxycore_grants sshxycore_sessions sshxycore_ui sshxycore_webssh sshxycore_log sshxycore_archive sshxycore_private_key

			#enable syclops dependency
			drush en --yes auto_nodetitle admin_menu admin_menu_toolbar token comment list file image ctools context features fe_block nodeformcols options references node_reference user_reference strongarm views views_php menu views_bulk_operations entity entity_token entityreference entityreference_prepopulate message og og_access og_field_access og_context og_ui context_og path pathauto jquery_update unique_field flag smtp rules realname og_manager_change

			#installs session limit module and enables
			drush dl --yes session_limit
			drush en --yes session_limit
			#drush sshxy as default theme
			drush pm-enable --yes sshxy
			drush vset theme_default sshxy
			#disable default drupal theme
			drush pm-disable --yes bartik
			#push syclops code to database
			drush features-revert-all --yes
			#clear drupal cache
			drush cc all
			#run cron
			drush cron
			#disable unused blocks
			drush block-disable --strict=0 --module=user --delta=login --region=-1
			drush block-disable --strict=0 --module=system --delta=management --region=-1
			drush block-disable --strict=0 --module=system --delta=navigation --region=-1
			#push syclops code to database
			drush features-revert-all --yes 
			#clear drupal cache
			drush cc all
			#run cron
			drush cron
			#disable drush update
			drush dis --yes update 
			touch /.drupal_installed
			chmod -R 777 /var/www/syclops/sites/default/files

			#get api key and secret KEY1
			if [[ -f /etc/gateone/conf.d/30api_keys.conf ]];then
			    KEY1=$(egrep -x "(.)+:(.)+" /etc/gateone/conf.d/30api_keys.conf | tail -1 | awk '{ print $1 }')
			    KEY2=$(egrep -x "(.)+:(.)+" /etc/gateone/conf.d/30api_keys.conf | tail -1 | awk '{ print $2 }')
			    API_KEY=`echo $KEY1 | sed 's/:/ /g' | sed 's/"//g'`
			    SECRET_KEY=`echo $KEY2 | sed 's/"//g'`
			    drush vset webssh_api_key $API_KEY
			    drush vset webssh_secret_key $SECRET_KEY
			    echo "API Key updated."
			else 
					echo "API Key file is not found."
			fi

			echo "Druapl installation is success"
			exit 0


 To change executable permission for the script and run the script by using following command.

 >
 >**./drush_script [syclops-database-password]**
 > 

 The above script installs syclops.

 To change current working directory to / and create ip_change.sh and ip_check.sh by using following content .

 > 
 >**ip_change.sh**

		#!/bin/bash
		# Drupal settings.php file path
		if [[ ! -f /.drupal_installed ]];then 
		echo "Drupal does not exists."
		exit 0
		fi
		DRUPAL_SETTING="/var/www/syclops/sites/default/settings.php"
		# IP details of the database container
		DATABASE_IP=$(eval echo -e `</share/database`)
		# Change the file permission of drupal setting.php file because default permission is read only.
		chmod u+w $(echo $DRUPAL_SETTING)
		# Modifies ip address
		sed -i -r 's/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/'"$DATABASE_IP"'/' $(echo $DRUPAL_SETTING)
		# Reset the file permission
		chmod u-w  $(echo $DRUPAL_SETTING)
		#kill current process
		exit 0

 >**ip_check.sh**

		#!/bin/bash 
		#get ip address of the container
		pattern=$(ifconfig | awk '{print $2}' | head -n 2 | tail -n 1)
		ip=$(echo $pattern | sed -r 's/[a-z:]+/''/ig')
		#validates the ip address is valid or not
		if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
		        #checks shared folder is exists or not
		        if [[ -d "/share" ]];then
			  		if [[ ! -f "/share/webserver" ]];then
				 		echo $ip > /share/webserver
						old_ip="0"
					else
						old_ip=$(eval echo -e `</share/ui`)
						echo $ip > /share/webserver
					fi

					if [[ $ip != $old_ip ]];then
						echo "Ip changed: $old_ip to $ip" 
					fi
		        else
		                echo "Shared folder not found."
		        fi
		fi
		/ip_change.sh
		exit 0

 Update exetuable file permission for both script.

 Update the supervisord configuration by using following contents.

		[program:ip_check]
		command=/ip_check.sh
		autorestart=false
		startretries=0
		priority=1

### Syclops UI image creation by using running container ###

 Open new terminal and issue following command

 >
 >**docker ps -a**
 >

 Get the running container id from the above command output and create gatone image by using following command.

 >
 >**docker commit -run='{"Cmd":["/usr/bin/surpervisord","-n"],"Portspec":["80","443"]}' `<container-id>` syclops:syclops_ui**
 >

 The above command will take some moments to finish. After finish image creation and go to previous terminal which we used to create a image. To type exit command to exit from the container. After come from the container and type following command to remove unused container.

 >
 >**docker rm `<container-id>`**
 >

### Syclops UI container creation ###

 Create a syclops ui container by using syclops_ui image which we have created before by using following command. 

 >
 >**docker run -i -d -p 80:80 -p 443:443 -volumes-from terminal -v /share:/share -name ui -link database:db -link term:t -t syclops:syclops_ui**
 >

 Verify the ui container is running  or not by using following command.

 >
 >**docker ps -a**
 >