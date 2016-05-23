#!/bin/bash
# Drupal settings.php file path
if [[ ! -f "/var/www/syclops/sites/default/settings.php" ]];then 
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
