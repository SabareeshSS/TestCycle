### Syclops Terminal Image ###

FROM syclops/syclops_base

MAINTAINER Chandrasekaran "chandrasekaran@thebw.in"

ENV DEBIAN_FRONTEND noninteractive

CMD ["/sbin/my_init"]

RUN apt-get update

RUN apt-get install -y libcurl4-gnutls-dev libexpat1-dev gettext libffi-dev libz-dev libssl-dev python-setuptools python-pip python-dev cpulimit

ADD ./src/gateone /gateone

ADD ./scripts /

VOLUME ["/etc/gateone"]

#Gateone startup script
RUN mkdir /etc/service/gateone
ADD config/build/gateone.sh /etc/service/gateone/run
RUN chmod +x /etc/service/gateone/run

#Playback Agent startup script
RUN mkdir /etc/service/playback
ADD config/build/playback.sh /etc/service/playback/run
RUN chmod +x /etc/service/playback/run

#IP Check startup script
ADD ./scripts/ip_check.sh /etc/my_init.d/99_ip_check.sh
RUN chmod +x /etc/my_init.d/99_ip_check.sh

#Installs GateOne
ADD ./config/etc/init.d/3_gateone_setup.sh /etc/my_init.d/3_gateone_setup.sh
RUN chmod +x /etc/my_init.d/3_gateone_setup.sh

EXPOSE 7443

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
