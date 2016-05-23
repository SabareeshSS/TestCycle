### Syclops UI Image ###
FROM syclops/syclops_base

MAINTAINER Chandrasekaran "<chandrasekaran@thebw.in>"

ENV DEBIAN_FRONTEND noninteractive

CMD ["/sbin/my_init"]

ADD ./scripts /
ADD ./config/incron/incron-user-table /incron-user-table
RUN /nginx_installar.sh
RUN mkdir -p /var/www/syclops
RUN chown -R www-data:www-data /var/www/syclops

#Replaces nginx configuration files
ADD ./config/nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./config/nginx/fastcgi.conf /etc/nginx/fastcgi.conf
ADD ./config/nginx/fastcgi_drupal.conf /etc/nginx/fastcgi_drupal.conf
ADD ./config/nginx/sites-enabled/syclops.conf /etc/nginx/sites-enabled/syclops.conf

#Installs php5-fpm 
RUN /php5_fpm_installar.sh
ADD ./config/php5-fpm/apc.ini /etc/php5/fpm/conf.d/apc.ini

#Replaces php5-fpm configuration file
ADD ./config/php5-fpm/www.conf /etc/php5/fpm/pool.d/www.conf
ADD ./config/php5-fpm/php-fpm.conf /etc/php5/fpm/php-fpm.conf

#Ngnix startup script
RUN mkdir /etc/service/nginx
ADD ./config/build/nginx.sh  /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

#PHP-FPM Startup script
RUN mkdir /etc/service/phpfpm
ADD ./config/build/phpfpm.sh /etc/service/phpfpm/run
RUN chmod +x /etc/service/phpfpm/run

#Incrond startup script
RUN mkdir /etc/service/incron
ADD ./config/build/incrond.sh /etc/service/incron/run
RUN chmod +x /etc/service/incron/run

#IP Check startup script
ADD ./scripts/ip_check.sh /etc/my_init.d/99_ip_check.sh
RUN chmod +x /etc/my_init.d/99_ip_check.sh

EXPOSE 80 443

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

