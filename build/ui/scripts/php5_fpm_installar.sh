#!/bin/bash
apt-get install -y curl libcurl3 libcurl3-dev libpcre3-dev
apt-get install -y php5-cli php5-dev php5-common php5-fpm php5-gd php5-mysql php5-curl php-pear mysql-client php5-mcrypt
pear channel-discover pear.drush.org
pear install drush/drush
pear install Console_Table
printf "\n" | pecl install apc
mv /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.bak
mv /etc/php5/fpm/php-fpm.conf /etc/php5/fpm/php-fpm.conf.bak
