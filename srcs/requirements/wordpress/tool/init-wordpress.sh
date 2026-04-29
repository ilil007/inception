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
        install_output=$(wp core install \
            --url=https://${DOMAIN_NAME} \
            --title="${WP_TITLE}" \
            --admin_user="${WP_ADMIN_USER}" \
            --admin_password="${WP_ADMIN_PASS}" \
            --admin_email="${WP_ADMIN_EMAIL}" \
            --skip-email \
            --allow-root 2>&1) || install_status=$?

        if [ -n "${install_status}" ]; then
            if echo "${install_output}" | grep -qi "email address is already used"; then
                echo "Admin email already used; assuming WordPress is already installed."
                if ! wp core is-installed --allow-root 2>/dev/null; then
                    echo "Core installation failed and site is not installed."
                    echo "${install_output}"
                    exit 1
                fi
            else
                echo "Core installation failed."
                echo "${install_output}"
                exit "${install_status}"
            fi
        else
            echo "Core installation complete."
        fi

    fi
fi

if wp core is-installed --allow-root 2>/dev/null; then
    admin_id=""
    if wp user get "${WP_ADMIN_USER}" --field=ID --allow-root >/dev/null 2>&1; then
        admin_id=$(wp user get "${WP_ADMIN_USER}" --field=ID --allow-root)
    else
        admin_id=$(wp user list --search="${WP_ADMIN_EMAIL}" --search-columns=user_email --field=ID --allow-root | head -n 1)
    fi

    if [ -n "${admin_id}" ]; then
        wp user update "${admin_id}" \
            --user_login="${WP_ADMIN_USER}" \
            --user_pass="${WP_ADMIN_PASS}" \
            --user_email="${WP_ADMIN_EMAIL}" \
            --role=administrator \
            --allow-root
    else
        wp user create "${WP_ADMIN_USER}" "${WP_ADMIN_EMAIL}" \
            --user_pass="${WP_ADMIN_PASS}" \
            --role=administrator \
            --allow-root
    fi

    if [ "${WP_NORMAL_EMAIL}" = "${WP_ADMIN_EMAIL}" ]; then
        echo "Normal user email matches admin email; skipping normal user sync."
    else
        if ! wp user get "${WP_NORMAL_USER}" --field=ID --allow-root >/dev/null 2>&1; then
            if wp user list --search="${WP_NORMAL_EMAIL}" --search-columns=user_email --field=ID --allow-root | grep -q '[0-9]'; then
                echo "Normal user email already used; updating login, password, and role."
                existing_id=$(wp user list --search="${WP_NORMAL_EMAIL}" --search-columns=user_email --field=ID --allow-root | head -n 1)
                wp user update "${existing_id}" \
                    --user_login="${WP_NORMAL_USER}" \
                    --user_pass="${WP_NORMAL_PASS}" \
                    --user_email="${WP_NORMAL_EMAIL}" \
                    --role=editor \
                    --allow-root
            else
                wp user create "${WP_NORMAL_USER}" "${WP_NORMAL_EMAIL}" \
                    --user_pass="${WP_NORMAL_PASS}" \
                    --role=editor \
                    --allow-root
            fi
        fi
    fi
fi

chown -R www-data:www-data /var/www/html
echo "Access permissions verified."

exec php-fpm82 -F
