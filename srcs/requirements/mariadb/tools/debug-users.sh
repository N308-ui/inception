#!/bin/bash

echo "Checking MariaDB users..."
mysql -uroot -p"$(cat /run/secrets/db_root_password)" -e "SELECT User, Host FROM mysql.user;"
echo ""
echo "Checking database privileges..."
mysql -uroot -p"$(cat /run/secrets/db_root_password)" -e "SHOW GRANTS FOR '$MYSQL_USER'@'%';"