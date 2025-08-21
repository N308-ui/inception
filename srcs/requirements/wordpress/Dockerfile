FROM debian:bookworm-slim

# Install PHP 8.2 and required extensions
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-zip \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    curl \
    mariadb-client \
    netcat-openbsd \
    msmtp && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM
RUN sed -i 's/listen = .*/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's/;listen.owner = www-data/listen.owner = www-data/' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's/;listen.group = www-data/listen.group = www-data/' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's/;listen.mode = 0660/listen.mode = 0660/' /etc/php/8.2/fpm/pool.d/www.conf

# Configure msmtp as sendmail replacement
RUN ln -sf /usr/bin/msmtp /usr/sbin/sendmail && \
    ln -sf /usr/bin/msmtp /usr/lib/sendmail

# Create PHP-FPM run directory
RUN mkdir -p /run/php

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Set working directory
WORKDIR /var/www/html

# Copy and prepare the script
COPY ./tools/script.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/script.sh

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/script.sh"]