#!/bin/sh
set -e

echo "Ensuring MariaDB is accessible..."
while ! mysql -h${DB_HOST} -u${WP_DB_USER} -p${WP_DB_PASS} ${WP_DB_NAME} -e "SELECT 1" >/dev/null 2>&1; do
    echo "waiting for DB..."
    sleep 2
done

cd /var/www/html

if wp core is-installed --allow-root 2>/dev/null; then
    echo "WP setup skipped (already done)."
else
    echo "Running first-time WordPress setup..."

    wp core download --allow-root || echo "WP core files exist already."

    if [ ! -f "wp-config.php" ]; then
        wp config create \
            --dbname=${WP_DB_NAME} \
            --dbuser=${WP_DB_USER} \
            --dbpass=${WP_DB_PASS} \
            --dbhost=${DB_HOST} \
            --force \
            --allow-root

        echo "Created wp-config.php"
    fi

    if ! wp core is-installed --allow-root 2>/dev/null; then
        wp core install \
            --url=https://${DOMAIN_NAME} \
            --title="${WP_TITLE}" \
            --admin_user="${WP_ADMIN_USER}" \
            --admin_password="${WP_ADMIN_PASS}" \
            --admin_email="${WP_ADMIN_EMAIL}" \
            --skip-email \
            --allow-root

        echo "Core installation complete."

        wp user create "${WP_NORMAL_USER}" "${WP_NORMAL_EMAIL}" \
            --user_pass="${WP_NORMAL_PASS}" \
            --role=editor \
            --allow-root

        echo "Standard WP user added."
    fi

    chown -R www-data:www-data /var/www/html
    echo "Access permissions verified."
fi

exec php-fpm82 -F
