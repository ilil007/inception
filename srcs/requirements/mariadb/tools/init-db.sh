#!/bin/sh

set -e

chown -R mysql:mysql /var/lib/mysql /run/mysqld 2>/dev/null || true

: "${WP_DB_NAME:?Missing WP_DB_NAME}"
: "${WP_DB_USER:?Missing WP_DB_USER}"
: "${WP_DB_PASS:?Missing WP_DB_PASS}"
: "${DB_ROOT_PASSWORD:?Missing DB_ROOT_PASSWORD}"

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Creating MariaDB system tables..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql >/dev/null
fi

echo "Ensuring WP database and user are configured..."
mysqld --user=mysql --bootstrap <<-EOF
	USE mysql;
	FLUSH PRIVILEGES;

	CREATE DATABASE IF NOT EXISTS \`${WP_DB_NAME}\`;
	CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASS';
	ALTER USER '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASS';
	GRANT ALL PRIVILEGES ON \`${WP_DB_NAME}\`.* TO '$WP_DB_USER'@'%';

	CREATE USER IF NOT EXISTS '$WP_DB_USER'@'localhost' IDENTIFIED BY '$WP_DB_PASS';
	ALTER USER '$WP_DB_USER'@'localhost' IDENTIFIED BY '$WP_DB_PASS';
	GRANT ALL PRIVILEGES ON \`${WP_DB_NAME}\`.* TO '$WP_DB_USER'@'localhost';

	ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
	FLUSH PRIVILEGES;
EOF
echo "WP Database ($WP_DB_NAME) ensured."

echo "Launching MariaDB daemon in foreground..."
exec mariadbd --user=mysql --console
