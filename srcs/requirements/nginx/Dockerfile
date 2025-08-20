FROM debian:bookworm

RUN apt update && apt upgrade -y && apt install -y \
    nginx openssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \ 
    -keyout /etc/ssl/private/g0dr1c.key \
    -out /etc/ssl/certs/g0dr1c.crt \
    -subj="/C=MA/ST=benguerir/L=benguerir/O=1337 School/OU=g0dr1c/CN=g0dr1c.42.fr"

COPY ./tools/certs.sh /tmp/certs.sh

RUN chmod +x /tmp/certs.sh

COPY ./conf/default /etc/nginx/sites-available/.

ENTRYPOINT ["/tmp/certs.sh"]