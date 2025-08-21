#!/bin/bash

# Generate SSL certificates if they don't exist
if [ ! -f /etc/ssl/certs/g0dr1c.crt ] || [ ! -f /etc/ssl/private/g0dr1c.key ]; then
    echo "Generating SSL certificates..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/g0dr1c.key \
        -out /etc/ssl/certs/g0dr1c.crt \
        -subj="/C=MA/ST=benguerir/L=benguerir/O=1337 School/OU=g0dr1c/CN=$DOMAIN_NAME"
fi

# Replace domain name in nginx configuration
sed -i "s/server_name _;/server_name $DOMAIN_NAME;/g" /etc/nginx/sites-available/default

# Test nginx configuration
nginx -t

# Start nginx
echo "Starting nginx..."
exec nginx -g "daemon off;"