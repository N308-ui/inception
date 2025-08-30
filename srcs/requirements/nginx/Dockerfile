FROM debian:bookworm

RUN apt update && apt upgrade && apt install -y nginx openssl

RUN cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak && \
    rm -rf /etc/nginx/sites-available/default

COPY default /etc/nginx/sites-available/
COPY setup.sh .

RUN chmod +x setup.sh

EXPOSE 80
EXPOSE 443

CMD [ "./setup.sh" ]
