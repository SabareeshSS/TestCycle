## Syclops Base Image ##
FROM phusion/baseimage:0.9.9
MAINTAINER Chandrasekaran "<chandrasekaran@thebw.in>"
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]
RUN apt-get update && locale-gen en_US.UTF-8
RUN apt-get install -y software-properties-common python-software-properties
RUN apt-get install -y build-essential vim incron wget net-tools git-core iputils-ping
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

