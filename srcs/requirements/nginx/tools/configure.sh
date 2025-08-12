#!/bin/sh
# Generate SSL certificates if they don't exist
if [ ! -f "/etc/ssl/certs/nginx.crt" ]; then
    ./generate_certs.sh
fi

# Start NGINX
exec "$@"