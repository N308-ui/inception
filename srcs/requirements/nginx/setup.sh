#!/bin/bash

mkdir -p /etc/nginx/ssl

sed -i \
    -e "s/<DOMAIN_NAME>/${DOMAIN_NAME}/" \
    /etc/nginx/sites-available/default

openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/${DOMAIN_NAME}.key \
    -out /etc/nginx/ssl/${DOMAIN_NAME}.crt

chmod 644 /etc/nginx/ssl/${DOMAIN_NAME}.crt
chmod 600 /etc/nginx/ssl/${DOMAIN_NAME}.key

nginx -t

exec nginx -g "daemon off;"
