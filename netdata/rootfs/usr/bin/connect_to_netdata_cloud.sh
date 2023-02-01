#!/usr/bin/env bashio

bashio::log.info "Waiting 10 seconds for Netdata to start..."
sleep 10 # Wait for 10 second for Netdata to start

NETDATA_HOSTNAME=$(bashio::config 'hostname')
NETDATA_CLOUD_URL=$(bashio::config 'claim_url')
NETDATA_CLOUD_TOKEN=$(bashio::config 'claim_token')
NETDATA_CLOUD_ROOMS=$(bashio::config 'claim_rooms')

COMMAND = ("sh /tmp/netdata-kickstart.sh")

if [ -n ${NETDATA_HOSTNAME} ]; then
  COMMAND+="--claim-hostname ${NETDATA_HOSTNAME}"
fi

if [ -n ${NETDATA_CLOUD_TOKEN} ]; then
  COMMAND+="--claim-token ${NETDATA_CLOUD_TOKEN}"
fi

if [ -n ${NETDATA_CLOUD_ROOMS} ]; then
  COMMAND+="--claim-rooms "${NETDATA_CLOUD_ROOMS}""
fi

if [ -n ${NETDATA_CLOUD_URL} ]; then
  COMMAND+="--claim-url "${NETDATA_CLOUD_URL}""
fi

bashio::log.info "Executing update command: ${COMMAND[@]}"

"${COMMAND[@]}"