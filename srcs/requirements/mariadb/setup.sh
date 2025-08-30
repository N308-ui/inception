#!/bin/bash

# Only create init.sql if it doesn't exist or is empty
if [ ! -f /etc/mysql/init.sql ] || [ ! -s /etc/mysql/init.sql ]; then
    cat << EOF > /etc/mysql/init.sql
CREATE DATABASE IF NOT EXISTS $WP_DB_NAME;
CREATE USER IF NOT EXISTS "$WP_DB_USERNAME"@"%" IDENTIFIED BY "$WP_DB_USERPWD";
GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO "$WP_DB_USERNAME"@"%";
FLUSH PRIVILEGES;
EOF
fi

# Backup config only if backup doesn't exist
if [ ! -f /etc/mysql/mariadb.conf.d/50-server.cnf.bck ]; then
    cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.bck
fi

# Apply configuration changes
sed -i \
    -e '15s/#//' \
    -e '18,19s/#//' \
    -e '15s/mysql/root/' \
    -e '27s/127.0.0.1/mariadb/' \
    -e '7c\\ninit_file = /etc/mysql/init.sql\n' \
    /etc/mysql/mariadb.conf.d/50-server.cnf

mkdir -p /run/mysqld

# Only run mysql_install_db if mysql database doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=root --ldata=/var/lib/mysql/
else
    echo "MySQL database already exists, skipping installation..."
fi

exec mysqld
