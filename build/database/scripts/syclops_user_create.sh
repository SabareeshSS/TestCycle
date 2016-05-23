#!/bin/bash
DBPASS=$(pwgen -s 12 1)
mysql -uroot -e "CREATE USER 'syclops'@'%' IDENTIFIED BY '$DBPASS'"
mysql -uroot -e "CREATE DATABASE syclops"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'syclops'@'%' WITH GRANT OPTION"
mysql -uroot -e "GRANT ALL PRIVILEGES ON syclops.* TO 'syclops'@'%'" 	
echo $DBPASS
exit 0
