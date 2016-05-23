#!/bin/bash

DATABASE_PASS=$1
S_INTERNAL=$(pwgen -s 12 1)
S_ADMIN=$(pwgen -s 12 1)
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
#check drupal is already exists or not
if [[ -f '/var/www/syclops/sites/default/settings.php' ]];then
  echo "Drupal already installed"
  exit 0
fi
#checks password
if [[ $# == 0 ]];then
  echo "Database password is empty"
  exit 0
fi

#change web root
cd /var/www/syclops
drush site-install minimal --yes --db-url=mysql://syclops:$DATABASE_PASS@$DATABASE_IP/syclops --site-name=Syclops --account-name=syclops-internal --account-pass="$S_INTERNAL"

#enable syclops core module
drush en --yes syclops_users syclops_projects syclops_activities syclops_connections syclops_grants syclops_sessions syclops_ui syclops_webssh syclops_log syclops_archive syclops_private_key

#enable syclops dependency
drush en --yes auto_nodetitle admin_menu admin_menu_toolbar token comment list file image ctools context features fe_block nodeformcols options references node_reference user_reference strongarm views views_php menu views_bulk_operations entity entity_token entityreference entityreference_prepopulate message og og_access og_field_access og_context og_ui context_og path pathauto jquery_update unique_field flag smtp rules realname og_manager_change userone role_delegation tfa tfa_basic prlp

#installs session limit module and enables
drush dl --yes session_limit
drush en --yes session_limit
#drush sshxy as default theme
drush pm-enable --yes syclops
drush vset theme_default syclops
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
#creates new syclops admin user
drush user-create admin --mail="example@example.com" --password="$S_ADMIN"

#add site-admin role to syclops-admin user
drush user-add-role "site admin" admin

#clear drupal cache
drush cc all
#run cron
drush cron
#disable drush update
drush dis --yes update 

touch /.drupal_installed

chmod -R 777 /var/www/syclops/sites/default/files

cp /var/www/syclops/sites/all/themes/syclops/images/user_icon.png /var/www/syclops/sites/default/files/

chown -R www-data:www-data /var/www/syclops
#get api key and secret KEY1
if [[ -f /etc/gateone/conf.d/30api_keys.conf ]];then
        KEY1=$(egrep -x "(.)+:(.)+" /etc/gateone/conf.d/30api_keys.conf | tail -1 | awk '{ print $1 }')
        KEY2=$(egrep -x "(.)+:(.)+" /etc/gateone/conf.d/30api_keys.conf | tail -1 | awk '{ print $2 }')
        API_KEY=`echo $KEY1 | sed 's/:/ /g' | sed 's/"//g'`
        SECRET_KEY=`echo $KEY2 | sed 's/"//g'`
        drush vset webssh_api_key $API_KEY
        drush vset webssh_secret_key $SECRET_KEY
        echo "API Key has been updated."
   else 
   		echo "API Key file is not found."
fi
echo "#####################################################################"
echo "# Congratulations! Syclops has been installed successfully.         #"
echo "# Please save the following password details regarding installation.#"
echo "#####################################################################"
echo "*  Syclops User Detail and Password                                 *"
echo "*********************************************************************"
echo "*  syclops master admin            | Username : syclops-internal    *"
echo "* (system internal usage)          | Password : $S_INTERNAL         *"
echo "*---------------------------------------------------------------    *"
echo "*   Administrator                  |  Username : admin              *"
echo "* (main admin account)             |  Password : $S_ADMIN           *"
echo "*********************************************************************"
echo "* Database Details                                                  *"
echo "*********************************************************************"
echo "* Username : syclops                                                *"
echo "* Password : $DATABASE_PASS                                         *"
echo "* Database : syclops                                                *"
echo "*********************************************************************"
exit 0
