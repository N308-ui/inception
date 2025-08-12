#!/bin/sh

if [ ! -f "/var/www/html/wp-config.php" ]; then
    wp core download --allow-root
    wp config create \
        --dbname=${WORDPRESS_DB_NAME} \
        --dbuser=${WORDPRESS_DB_USER} \
        --dbpass=$(cat ${WORDPRESS_DB_PASSWORD_FILE}) \
        --dbhost=mariadb \
        --allow-root
    wp core install \
        --url=https://${DOMAIN_NAME} \
        --title=${WP_TITLE} \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=$(cat ${WP_ADMIN_PASSWORD_FILE}) \
        --admin_email=${WP_ADMIN_EMAIL} \
        --skip-email \
        --allow-root
fi

chown -R nobody:nobody /var/www/html