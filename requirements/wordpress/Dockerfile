FROM debian:bookworm

# Install dependencies and add PHP repository
RUN apt update && apt upgrade -y && \
    apt install -y curl ca-certificates gnupg && \
    curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ bookworm main" > /etc/apt/sources.list.d/php.list && \
    apt update

# Install PHP and extensions (including mysqli)
RUN apt install -y php8.2-fpm php8.2-mysql php8.2-mysqli && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY www.conf /etc/php/8.2/fpm/pool.d/

COPY script.sh .
RUN chmod +x script.sh

CMD [ "./script.sh" ]