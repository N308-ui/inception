#!/bin/bash

set -e

echo "=== Starting MariaDB Initialization ==="

# Create necessary directories
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# Initialize database if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing new database..."
    
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start temporary server for initialization
    mysqld --user=mysql --skip-networking --skip-grant-tables &
    pid="$!"
    
    sleep 5
    
    # Run initialization commands
    mysql <<SQL
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
SQL
    
    kill -s TERM "$pid"
    wait "$pid"
    
    echo "Database initialization completed!"
else
    echo "Database already exists."
fi

echo "=== Starting MariaDB ==="
exec mysqld --user=mysql --console