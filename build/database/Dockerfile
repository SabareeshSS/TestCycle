## Syclops Database Image ##
FROM syclops/syclops_base
MAINTAINER Chandrasekaran "<chandrasekaran@thebw.in>"

ENV DEBIAN_FRONTEND noninteractive

CMD ["/sbin/my_init"]

RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A

# create percona repository 
RUN touch /etc/apt/sources.list.d/percona.list
RUN echo "deb http://repo.percona.com/apt precise main" >> /etc/apt/sources.list.d/percona.list
RUN echo "deb-src http://repo.percona.com/apt precise main" >> /etc/apt/sources.list.d/percona.list

# updates new repository details
RUN apt-get update

#installs percona server and client
RUN apt-get install -y percona-server-server-5.5 percona-server-client-5.5 pwgen

# copy mysql specific configuration
ADD ./config/mysql/my.cnf /etc/mysql/my.cnf


# copy syclops user and database creation script
ADD ./scripts /

#Mysql startup script
RUN mkdir /etc/service/mysql
ADD ./config/build/mysql.sh /etc/service/mysql/run
RUN chmod +x /etc/service/mysql/run

#IP Check startup script
ADD ./scripts/ip_check.sh /etc/my_init.d/99_ip_check.sh
RUN chmod +x /etc/my_init.d/99_ip_check.sh

ADD ./config/etc/init.d/3_mysql_setup.sh /etc/my_init.d/3_mysql_setup.sh
RUN chmod +x /etc/my_init.d/3_mysql_setup.sh

#Removes unused files
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
