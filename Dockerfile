#
# Consul web-ui Dockerfile
#
# https://github.com/
#

# Pull base image.
FROM debian:latest

MAINTAINER hihouhou < hihouhou@hihouhou.com >

ENV CONSUL_VERSION 0.6.4
ENV CONSUL_CLUSTER consul_cluster

# Update & install packages for installing consul
RUN apt-get update && \
    apt-get install -y wget unzip

#Install and configure consul-web-ui
RUN mkdir /consul_web_ui && \
    cd /consul_web_ui && \
    wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip && \
    unzip -o consul_${CONSUL_VERSION}_web_ui.zip && \
    rm consul_${CONSUL_VERSION}_web_ui.zip
RUN wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    cd /usr/local/bin/ && \
    unzip /consul_${CONSUL_VERSION}_linux_amd64.zip

EXPOSE 8500

CMD consul agent -data-dir /tmp/consul -client $(ip a ls eth0 |sed -rn 's/^\s+inet (.*)\/.*$/\1/pg') -ui -ui-dir /consul_web_ui/ -join ${CONSUL_CLUSTER}
