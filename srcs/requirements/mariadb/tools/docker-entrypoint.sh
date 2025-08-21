#!/bin/bash

set -e

echo "=== MariaDB Entrypoint Debug ==="
echo "MYSQL_DATABASE: $MYSQL_DATABASE"
echo "MYSQL_USER: $MYSQL_USER"
echo "MYSQL_PASSWORD: $MYSQL_PASSWORD"
echo "MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD"
echo "================================"

# Create necessary directories
mkdir -p /run/mysqld
mkdir -p /var/log/mysql
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /var/log/mysql

# Check if we need to run initialization
if [ -d "/var/lib/mysql/mysql" ]; then
    echo "Database already exists, ensuring user permissions are correct..."
    
    # Start temporary server to fix permissions
    mysqld --user=mysql --skip-networking --skip-grant-tables &
    pid="$!"
    
    # Wait for server to start
    sleep 5
    
    # Debug: Show current users
    echo "=== Current users before fix ==="
    mysql -e "SELECT User, Host FROM mysql.user;" || echo "Could not query users"
    
    # Always ensure the user exists with correct permissions
    echo "=== Fixing user permissions ==="
    mysql <<SQL
FLUSH PRIVILEGES;
-- Ensure database exists
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
-- Drop existing users with wrong hosts
DROP USER IF EXISTS '$MYSQL_USER'@'localhost';
DROP USER IF EXISTS '$MYSQL_USER'@'%';
-- Create user with access from any host
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
-- Grant privileges
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
SQL
    
    # Debug: Show users after fix
    echo "=== Current users after fix ==="
    mysql -e "SELECT User, Host FROM mysql.user;"
    
    # Stop temporary server
    kill -s TERM "$pid"
    wait "$pid"
    
else
    echo "Initializing new database..."
    
    # Initialize database
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start temporary server for initialization
    mysqld --user=mysql --skip-networking --skip-grant-tables &
    pid="$!"
    
    # Wait for server to start
    sleep 5
    
    # Run initialization commands
    mysql <<SQL
FLUSH PRIVILEGES;
-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';
-- Remove remote root access
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
-- Create database
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
-- Create user with access from any host
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
-- Grant privileges
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
SQL
    
    # Stop temporary server
    kill -s TERM "$pid"
    wait "$pid"
    
    echo "Database initialization completed!"
fi

# Start MariaDB normally
echo "Starting MariaDB..."
exec mysqld --user=mysql --console