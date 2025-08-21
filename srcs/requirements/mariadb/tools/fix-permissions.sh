#!/bin/bash

# Wait for MariaDB to start
sleep 10

# Fix user permissions to allow connections from any host
mysql -uroot -p"$(cat /run/secrets/db_root_password)" <<SQL
DROP USER IF EXISTS '$MYSQL_USER'@'localhost';
DROP USER IF EXISTS '$MYSQL_USER'@'%';
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$(cat /run/secrets/db_password)';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
SQL

echo "Database permissions fixed!"