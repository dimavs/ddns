#!/bin/bash

set -xe

DOMAIN_NAME=$(pass ddns/domain)
KEY=$(pass ddns/key)
IP_ADDRESS=$(dig +short myip.opendns.com @resolver1.opendns.com)
DDNS_CACHE="/tmp/ddns-${DOMAIN_NAME}"

if [ ! -f ${DDNS_CACHE} ]; then touch ${DDNS_CACHE}; fi
IP_CURRENT=$(<${DDNS_CACHE})

if [ "${IP_ADDRESS}" == "${IP_CURRENT}" ]; then exit 0; fi
echo ${IP_ADDRESS} > ${DDNS_CACHE}

curl "https://dyn.dns.he.net/nic/update" -d "hostname=${DOMAIN_NAME}" -d "password=${KEY}" -d "myip=${IP_ADDRESS}"
