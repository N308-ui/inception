FROM debian:bookworm

RUN apt update && \
    apt upgrade && \
    apt install mariadb-server -y

COPY setup.sh .

RUN chmod +x setup.sh

CMD [ "./setup.sh" ]
