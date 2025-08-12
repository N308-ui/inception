FROM alpine:3.16

RUN apk update && apk add --no-cache \
    php81 \
    php81-fpm \
    php81-mysqli \
    php81-json \
    php81-curl \
    php81-dom \
    php81-exif \
    php81-fileinfo \
    php81-mbstring \
    php81-openssl \
    php81-xml \
    php81-zip \
    php81-phar \
    php81-session \
    wget \
    && rm -rf /var/cache/apk/*

COPY conf/www.conf /etc/php81/php-fpm.d/www.conf
COPY tools/configure.sh /configure.sh

RUN chmod +x /configure.sh

WORKDIR /var/www/html

EXPOSE 9000

CMD ["sh", "-c", "/configure.sh && /usr/sbin/php-fpm81 -F"]