#!/bin/bash

# Wait for MariaDB to be ready without prompting for password
echo "Waiting for MariaDB..."
while ! nc -z mariadb 3306; do
    echo "MariaDB not ready yet, waiting..."
    sleep 5
done

# Additional wait to ensure MariaDB is fully ready
echo "MariaDB port is open, waiting for full startup..."
sleep 10

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
    # Try multiple times in case MariaDB is still initializing
    for i in {1..5}; do
        if wp config create \
            --dbname=${MYSQL_DATABASE} \
            --dbuser=${MYSQL_USER} \
            --dbpass=${MYSQL_PASSWORD} \
            --dbhost=mariadb \
            --allow-root; then
            echo "wp-config.php created successfully!"
            break
        else
            echo "Attempt $i: Failed to create wp-config.php, retrying..."
            sleep 5
        fi
    done
fi

# Check if WordPress is already installed
if [ -f wp-config.php ] && wp core is-installed --allow-root; then
    echo "WordPress is already installed."
else
    echo "Installing WordPress..."
    for i in {1..5}; do
        if wp core install \
            --url=${DOMAIN_NAME} \
            --title="Inception" \
            --admin_user=${WP_ADMIN_USER} \
            --admin_password=${WP_ADMIN_PASSWORD} \
            --admin_email=${WP_ADMIN_EMAIL} \
            --allow-root; then
            echo "WordPress installed successfully!"
            
            # Create additional user
            echo "Creating additional user..."
            wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=subscriber --allow-root
            break
        else
            echo "Attempt $i: Failed to install WordPress, retrying..."
            sleep 5
        fi
    done
fi

# Start PHP-FPM
echo "Starting PHP-FPM 8.2..."
exec php-fpm8.2 -F