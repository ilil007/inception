#!/bin/bash

set -e

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld 2>/dev/null || true

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

if [ ! -d "/var/lib/mysql/${WP_DB_NAME}" ]; then
    echo "Starting temporary MySQL server..."
    mysqld --user=mysql --bootstrap <<-EOF
		USE mysql;
		FLUSH PRIVILEGES;
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
		CREATE DATABASE IF NOT EXISTS ${WP_DB_NAME};
		CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASS}';
		GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%';
		FLUSH PRIVILEGES;
	EOF
    echo "Database initialized successfully."
fi

echo "Starting MariaDB..."
exec mysqld --user=mysql --console
