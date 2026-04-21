#!/bin/bash

set -e

echo "Waiting for MariaDB to be ready..."
until mysql -h${DB_HOST} -u${WP_DB_USER} -p${WP_DB_PASS} ${WP_DB_NAME} -e "SELECT 1" >/dev/null 2>&1; do
echo "MariaDB is unavailable - sleeping"
sleep 3
done

echo "MariaDB is up - continuing..."

cd /var/www/html

if wp core is-installed --allow-root 2>/dev/null; then
    echo "WordPress is already installed - skipping installation."
else
    echo "Installing WordPress for the first time..."

    wp core download --allow-root || echo "WordPress files might already exist."

    if [ ! -f "wp-config.php" ]; then
        wp config create \
            --dbname=${WP_DB_NAME} \
            --dbuser=${WP_DB_USER} \
            --dbpass=${WP_DB_PASS} \
            --dbhost=${DB_HOST} \
            --force \
            --allow-root

        echo "Database configured successfully."
    fi

    if ! wp core is-installed --allow-root 2>/dev/null; then
        wp core install \
            --url=https://${DOMAIN_NAME} \
            --title="${WP_TITLE}" \
            --admin_user=${WP_ADMIN_USER} \
            --admin_password=${WP_ADMIN_PASS} \
            --admin_email=${WP_ADMIN_EMAIL} \
            --skip-email \
            --allow-root

        echo "WordPress core installed successfully."

        wp user create ${WP_NORMAL_USER} ${WP_NORMAL_EMAIL} \
            --user_pass=${WP_NORMAL_PASS} \
            --role=author \
            --allow-root

        echo "Normal user created successfully."
    fi

    chown -R www-data:www-data /var/www/html

    echo "WordPress installed successfully."
fi
exec php-fpm8.2 -F