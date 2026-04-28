FROM alpine:3.19

RUN apk update && apk add --no-cache nginx openssl \
    && mkdir -p /etc/nginx/ssl /var/www/html

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=liliu.42.fr"

RUN adduser -S -G www-data www-data || true \
    && chown -R www-data:www-data /var/www/html

COPY conf/nginx.conf /etc/nginx/http.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
