#!/bin/sh

log -i "Generating certificates for domain: $(var CERT_DOMAIN).duckdns.org."

#
# Request certificate
#
if [ ! -f "/etc/letsencrypt/live/$(var CERT_DOMAIN).duckdns.org/cert.pem" ]
then

    log -i "Requesting certificate from letsencrypt."

# certbot certonly \
# --dry-run \
# --no-eff-email \
# --manual \
# --text \
# --agree-tos \
# --manual-public-ip-logging-ok \
# --email $(var CERT_EMAIL) \
# -d $(var CERT_DOMAIN).duckdns.org \
# --preferred-challenges=dns \
# --manual-auth-hook /app/duckdns/authenticator.sh \
# --manual-cleanup-hook /app/duckdns/cleanup.sh

certbot certonly \
--no-eff-email \
--manual \
--text \
--agree-tos \
--manual-public-ip-logging-ok \
--email $(var CERT_EMAIL) \
-d $(var CERT_DOMAIN).duckdns.org \
--preferred-challenges=dns \
--manual-auth-hook /app/duckdns/authenticator.sh \
--manual-cleanup-hook /app/duckdns/cleanup.sh

    if [ $? -eq 1 ]
    then   
        log -e "Certificate request failed."
        exit 1;
    else
        log -i "Certificate created successfully."
    fi
else
    log -i "Found existing certificate for domain: $(var CERT_DOMAIN).duckdns.org."
fi

version=$(readlink -f /etc/letsencrypt/live/$(var CERT_DOMAIN).duckdns.org/cert.pem | sed -e 's/.*cert\(.*\).pem/\1/g')
log -i "Current version: $version."

#
# Generate pfx
#
if [ ! -f "/etc/letsencrypt/archive/$(var CERT_DOMAIN).duckdns.org/cert$version.pfx" ]
then

log -i "Generating pfx."
#exit 0;
openssl pkcs12 -export \
    -out /etc/letsencrypt/archive/$(var CERT_DOMAIN).duckdns.org/cert$version.pfx \
    -inkey /etc/letsencrypt/live/$(var CERT_DOMAIN).duckdns.org/privkey.pem \
    -in /etc/letsencrypt/live/$(var CERT_DOMAIN).duckdns.org/cert.pem \
    -certfile /etc/letsencrypt/live/$(var CERT_DOMAIN).duckdns.org/chain.pem \
    -name "$(var CERT_DOMAIN).duckdns.org" \
    -passout pass:$(var CERT_PASSWORD)

    if [ $? -eq 1 ]
    then   
        log -e "Pfx generation failed."
        exit 1;
    else
        log -i "Pfx generated successfully."
    fi

    ln -s ../../archive/$(var CERT_DOMAIN).duckdns.org/cert$version.pfx /etc/letsencrypt/live/$(var CERT_DOMAIN).duckdns.org/cert.pfx
else
    log -i "Found existing pfx."
fi
