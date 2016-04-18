FROM ubuntu:16.04
MAINTAINER ball6847@gmail.com

# Version
ENV NGINX_VERSION 1.9.14
ENV NPS_VERSION 1.11.33.0

# build
ADD build.sh /build.sh
RUN /build.sh

ADD conf/* /etc/nginx/
ADD entrypoint.sh /entrypoint.sh

VOLUME ["/var/cache/nginx", "/var/cache/ngx_pagespeed", "/var/www"]

WORKDIR /etc/nginx

EXPOSE 80 443

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
