FROM alpine:3.16

RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client \
    && rm -rf /var/cache/apk/*

COPY conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY tools/configure.sh /configure.sh

RUN chmod +x /configure.sh

EXPOSE 3306

VOLUME /var/lib/mysql

CMD ["sh", "-c", "/configure.sh && /usr/bin/mysqld_safe --datadir='/var/lib/mysql'"]