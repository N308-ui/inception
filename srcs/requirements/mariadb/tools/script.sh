#!/bin/bash

set -e

# Create necessary directories
mkdir -p /run/mysqld
mkdir -p /var/log/mysql
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /var/log/mysql

# Start MariaDB
echo "Starting MariaDB..."
exec mysqld --user=mysql --console