FROM rundqvist/supervisor:latest

LABEL maintainer="mattias.rundqvist@icloud.com"

WORKDIR /app

RUN apk --update --no-cache add certbot openssl

COPY root /

RUN chmod 755 /app/duckdns/authenticator.sh /app/duckdns/cleanup.sh /app/certbot/renew.sh

ENV DUCKDNS_TOKEN='' \
    CERT_DOMAIN='' \
    CERT_EMAIL='' \
    CERT_PASSWORD=''
