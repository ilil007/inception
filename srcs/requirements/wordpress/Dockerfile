FROM alpine:3.22

RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-cli \
    php82-curl \
    php82-gd \
    php82-mbstring \
    php82-xml \
    php82-zip \
    php82-phar \
    php82-json \
    php82-dom \
    php82-openssl \
    php82-iconv \
    curl \
    mariadb-client

# Create www-data user and group to match standard web server permissions
RUN set -x ; \
    addgroup -g 82 -S www-data ; \
    adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Alpine uses a different path for PHP-FPM pool config
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf

COPY tool/init-wordpress.sh /usr/local/bin/init-wordpress.sh

RUN chmod +x /usr/local/bin/init-wordpress.sh \
    && mkdir -p /run/php /var/www/html \
    && chown -R www-data:www-data /var/www/html

# Increase PHP memory limit so wp-cli download/extract doesn't crash.
RUN printf '%s\n' "memory_limit=256M" > /etc/php82/conf.d/99-wp-cli.ini

# Create symlink for php command if it doesn't exist
RUN ln -sf /usr/bin/php82 /usr/bin/php

WORKDIR /var/www/html

EXPOSE 9000

CMD ["/usr/local/bin/init-wordpress.sh"]