
FROM alpine:3.16

RUN apk update && apk add --no-cache \
    nginx \
    openssl \
    && rm -rf /var/cache/apk/*

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/configure.sh /configure.sh
COPY tools/generate_certs.sh /generate_certs.sh

RUN chmod +x /configure.sh /generate_certs.sh

EXPOSE 443

CMD ["sh", "-c", "/configure.sh && nginx -g 'daemon off;'"]