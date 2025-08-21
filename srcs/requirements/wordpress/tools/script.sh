#!/bin/bash

echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h"mariadb" -u"root" -p"$MYSQL_ROOT_PASSWORD" --silent; do
    echo "MariaDB not ready yet, waiting..."
    sleep 2
done

echo "MariaDB is ready! Setting up WordPress..."

cd /var/www/html

# Download WordPress if not already present
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
fi

# Create wp-config.php if it doesn't exist
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb \
        --allow-root
fi

# Check if WordPress is already installed
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url=https://${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root
    
    # Create additional user
    echo "Creating additional user..."
    wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=subscriber --allow-root
    
    echo "WordPress installation completed!"
else
    echo "WordPress is already installed."
fi

# Fix permissions
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

echo "Starting PHP-FPM 8.2..."
exec php-fpm8.2 --nodaemonize