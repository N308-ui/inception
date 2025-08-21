#!/bin/bash

# Replace domain name in nginx configuration
sed -i "s/server_name _;/server_name $DOMAIN_NAME;/g" /etc/nginx/sites-available/default

# Start nginx
nginx -g "daemon off;"