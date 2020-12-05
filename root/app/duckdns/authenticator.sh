#!/bin/sh

log -i "Updating DNS (TXT) record for domain: $CERTBOT_DOMAIN"

log -d "CERTBOT_DOMAIN: $CERTBOT_DOMAIN"
log -d "CERTBOT_VALIDATION: $CERTBOT_VALIDATION"
log -d "CERTBOT_TOKEN: $CERTBOT_TOKEN"

response=$(wget "https://www.duckdns.org/update?domains=$CERTBOT_DOMAIN&token=$(var DUCKDNS_TOKEN)&txt=$CERTBOT_VALIDATION" -O - -q 2>/dev/null)

if [ "$response" = "OK" ]
then
    log -i "Record updated."
else
    log -e "Failed to update record."
    exit 1;
fi

log -i "Sleeping 5s to allow DNS record replication..."
sleep 5s
