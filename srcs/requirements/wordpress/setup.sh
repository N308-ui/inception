#!/bin/bash

# setup wordpress
cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

./wp-cli.phar core download --allow-root

# [WORDPRESS] created database user
./wp-cli.phar config create \
    --dbname=$WP_DB_NAME \
    --dbuser=$WP_DB_USERNAME \
    --dbpass=$WP_DB_USERPWD \
    --dbhost=mariadb \
    --allow-root

# [WORDPRESS] created an admin
./wp-cli.phar core install \
    --url=$DOMAIN_NAME \
    --title=inception \
    --admin_user=$WP_ADMIN_NAME \
    --admin_password=$WP_ADMIN_PWD \
    --admin_email=$WP_ADMIN_EMAIL \
    --allow-root

# [WORDPRESS] and a second user as required
./wp-cli.phar user create $WP_USR_NAME $WP_USR_EMAIL \
    --role=$WP_USR_ROLE \
    --user_pass=$WP_USR_PWD \
    --allow-root

# [WORDPRESS] install redis plugin !
# ./wp-cli.phar plugin install redis-cache --activate --allow-root

# creating a backup
cp /etc/php/8.2/fpm/pool.d/www.conf /etc/php/8.2/fpm/pool.d/www.conf.bck

# made php-fpm to listen to wordpress:9000
sed -i \
    -e 's|/run/php/php8.2-fpm.sock|wordpress:9000|' \
    /etc/php/8.2/fpm/pool.d/www.conf

# making sure the redis config doesn't exist
wp_config_path="/var/www/html/wp-config.php"

if ! grep -q "'WP_CACHE'," $wp_config_path; then
	echo "define( 'WP_CACHE', true );" >> $wp_config_path
fi

# if ! grep -q "'WP_REDIS_PORT'" $wp_config_path; then
# 	echo "define( 'WP_REDIS_PORT', 6379 );" >> $wp_config_path
# fi

# if ! grep -q "'WP_REDIS_HOST'" $wp_config_path; then
# 	echo "define( 'WP_REDIS_HOST', 'redis' );" >> $wp_config_path
# fi



exec php-fpm8.2 -F
