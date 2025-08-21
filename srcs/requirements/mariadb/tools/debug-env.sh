#!/bin/bash

echo "Environment variables in MariaDB container:"
env | grep MYSQL
echo "Secrets files:"
ls -la /run/secrets/
if [ -f /run/secrets/db_password ]; then
    echo "db_password secret content: $(cat /run/secrets/db_password)"
fi
if [ -f /run/secrets/db_root_password ]; then
    echo "db_root_password secret content: $(cat /run/secrets/db_root_password)"
fi