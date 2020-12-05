#!/bin/sh

log -i "Cleaning DNS (TXT) record for domain: $CERTBOT_DOMAIN"

log -d "CERTBOT_DOMAIN: $CERTBOT_DOMAIN"
log -d "CERTBOT_VALIDATION: $CERTBOT_VALIDATION"
log -d "CERTBOT_TOKEN: $CERTBOT_TOKEN"

response=$(wget "https://www.duckdns.org/update?domains=$CERTBOT_DOMAIN&token=$(var DUCKDNS_TOKEN)&txt=$CERTBOT_VALIDATION&clear=true" -O - -q 2>/dev/null)

if [ "$response" = "OK" ]
then
    log -i "Record cleaned."
else
    log -e "Failed to clean record."
fi
