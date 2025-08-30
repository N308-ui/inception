FROM debian:bookworm

RUN apt update && apt upgrade -y && \
    apt install -y curl php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

COPY setup.sh .
RUN chmod +x setup.sh

CMD [ "./setup.sh" ]
