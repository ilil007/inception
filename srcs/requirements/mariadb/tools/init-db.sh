#!/bin/sh

set -e

chown -R mysql:mysql /var/lib/mysql /run/mysqld 2>/dev/null || true

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Creating MariaDB system tables..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql >/dev/null
fi

if [ ! -d "/var/lib/mysql/$WP_DB_NAME" ]; then
    echo "Running bootstrap script for WP Database..."
    mysqld --user=mysql --bootstrap <<-EOF
		USE mysql;
		FLUSH PRIVILEGES;
		
		CREATE DATABASE IF NOT EXISTS $WP_DB_NAME;
		CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASS';
		GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO '$WP_DB_USER'@'%';
		
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
		FLUSH PRIVILEGES;
EOF
    echo "WP Database ($WP_DB_NAME) crafted successfully."
fi

echo "Launching MariaDB daemon in foreground..."
exec mysqld --user=mysql --console
