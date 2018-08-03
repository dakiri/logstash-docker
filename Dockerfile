FROM debian:stretch-slim

##################################################################
## Logstash 
##################################################################

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		apt-transport-https vim procps wget gnupg iputils-ping kafkacat

ENV LOGSTASH_VERSION 6.3.2

	
RUN wget --no-check-certificate -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list

#RUN apt-get update && apt-get install -y --no-install-recommends logstash
COPY ./package/logstash-"$LOGSTASH_VERSION".deb /opt/logstash.deb
# prevent bug update-alternatives: error: error creating symbolic link '/usr/share/man/man1/rmid.1.gz.dpkg-tmp': No such file or directory
# due to using slim version of debian
RUN mkdir /usr/share/man/man1 -p
RUN apt-get install -y --no-install-recommends openjdk-8-jre-headless
RUN dpkg -i /opt/logstash.deb
RUN apt-get install -y --no-install-recommends libcap2-bin
RUN setcap cap_net_bind_service=+epi /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

ADD config/vim/.vimrc /root/.vimrc

COPY ./config/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./config/logstash/logstash.conf /etc/logstash/conf.d/logstash.conf

COPY ./script/logstash.sh /opt/logstash.sh
RUN chmod +x /opt/logstash.sh

RUN ln -snf /usr/share/zoneinfo/Europe/Paris /etc/localtime && echo Europe/Paris > /etc/timezone

##
# 514  : syslog
# 5044 : flux beat
##
EXPOSE 514 5044
VOLUME ["/etc/logstash/conf.d/","/var/log/logstash/","/var/result"]
CMD ["/usr/bin/supervisord"]
