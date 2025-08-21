#!/bin/bash

# Wait for MariaDB using PHP connection check
echo "Waiting for MariaDB..."
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if php /usr/local/bin/check-db.php; then
        echo "MariaDB is ready!"
        break
    fi
    attempt=$((attempt + 1))
    echo "Attempt $attempt/$max_attempts: MariaDB not ready yet, waiting..."
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo "Failed to connect to MariaDB after $max_attempts attempts"
    exit 1
fi

echo "Setting up WordPress..."

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
        --url=${DOMAIN_NAME} \
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

# Start PHP-FPM
echo "Starting PHP-FPM 8.2..."
exec php-fpm8.2 -F