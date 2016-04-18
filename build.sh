#!/bin/bash

set -e

buildDeps="build-essential zlib1g-dev libpcre3 libpcre3-dev libssl-dev"

# prepare dependencies
apt-get update
apt-get install -y $buildDeps wget unzip

# prepare ngx_pagespeed
cd /usr/src
wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip -O release-${NPS_VERSION}-beta.zip
unzip release-${NPS_VERSION}-beta.zip
cd ngx_pagespeed-release-${NPS_VERSION}-beta/
wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
tar -xzvf ${NPS_VERSION}.tar.gz

# compile nginx
cd /usr/src
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xvzf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}/
./configure \
  --prefix=/var/lib/nginx \
  --sbin-path=/usr/sbin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --pid-path=/run/nginx/nginx.pid \
  --lock-path=/run/nginx/nginx.lock \
  --http-client-body-temp-path=/var/lib/nginx/tmp/client_body \
  --http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
  --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
  --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi \
  --http-scgi-temp-path=/var/lib/nginx/tmp/scgi \
  --user=www-data \
  --group=www-data \
  --with-ipv6 \
  --with-file-aio \
  --with-pcre-jit \
  --with-http_dav_module \
  --with-http_ssl_module \
  --with-http_stub_status_module \
  --with-http_gzip_static_module \
  --with-http_v2_module \
  --with-http_auth_request_module \
  --add-module=/usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta
make
make install

# make container a little smaller
apt-get purge -y --auto-remove $buildDeps
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /usr/src/*

# log to stdout and stderr
# ln -sf /dev/stdout /var/log/nginx/access.log
# ln -sf /dev/stderr /var/log/nginx/error.log
