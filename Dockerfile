FROM ubuntu:latest

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y openssh-server supervisor
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

RUN apt-get install -y python-software-properties software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get install -y oracle-java7-installer

# Install ElasticSearch.
RUN wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb http://packages.elasticsearch.org/elasticsearch/1.0/debian stable main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y elasticsearch

# Install curl
RUN apt-get install -y curl

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN echo 'root:pass' |chpasswd
RUN /bin/echo -e "LANG=\"en_US.UTF-8\"" > /etc/default/locale

EXPOSE 22

# Prevent elasticsearch calling `ulimit`.
RUN sed -i 's/MAX_OPEN_FILES=/# MAX_OPEN_FILES=/g' /etc/init.d/elasticsearch

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300

CMD ["/usr/bin/supervisord"]
