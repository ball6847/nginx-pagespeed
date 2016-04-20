#!/bin/bash

set -e

NGINX_USER=www-data
NGINX_GROUP=www-data
NGINX_LOG_PATH=/var/log/nginx
NGINX_CACHE_PATH=/var/cache/nginx
PAGESPEED_CACHE_PATH=/var/cache/ngx_pagespeed

mkdir -p $NGINX_LOG_PATH $NGINX_CACHE_PATH $PAGESPEED_CACHE_PATH
chown -R "$NGINX_USER:$NGINX_GROUP" $NGINX_CACHE_PATH $PAGESPEED_CACHE_PATH

nginx -g "daemon off;"
