#!/bin/bash

# Start temporary server to check users
mysqld --user=mysql --skip-networking --skip-grant-tables &
pid="$!"
sleep 3

echo "=== Current MariaDB Users ==="
mysql -e "SELECT User, Host FROM mysql.user;"
echo ""
echo "=== User Grants ==="
mysql -e "SHOW GRANTS FOR '$MYSQL_USER'@'%';" || echo "User $MYSQL_USER@% does not exist"
echo "=== Database exists? ==="
mysql -e "SHOW DATABASES LIKE '$MYSQL_DATABASE';"

kill -s TERM "$pid"
wait "$pid"