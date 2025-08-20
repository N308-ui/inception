#!/bin/bash

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
while ! mysqladmin ping -h"mariadb" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
    sleep 2
done

echo "MariaDB is ready! Setting up WordPress..."

cd /var/www/html

# Download WordPress if not already present
if [ ! -f wp-config.php ]; then
    wp core download --allow-root
fi

# Create wp-config.php if it doesn't exist
if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb \
        --allow-root
fi

# Install WordPress if not already installed
if ! wp core is-installed --allow-root; then
    wp core install \
        --url=${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=superuser \
        --admin_password=superpassword \
        --admin_email=super@user.com \
        --allow-root
fi

# Start PHP-FPM (use PHP 8.2 version)
echo "Starting PHP-FPM 8.2..."
exec php-fpm8.2 -F