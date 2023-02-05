#!/usr/bin/env bashio

NETDATA_HOSTNAME=$(bashio::config 'hostname')
NETDATA_CLOUD_URL=$(bashio::config 'claim_url')
NETDATA_CLOUD_TOKEN=$(bashio::config 'claim_token')
NETDATA_CLOUD_ROOMS=$(bashio::config 'claim_rooms')

command=()
connectable=true


if [ -n "${NETDATA_CLOUD_TOKEN}" ]; then
  # command+="--claim-token ${NETDATA_CLOUD_TOKEN}"
  command+="-token ${NETDATA_CLOUD_TOKEN}"

  if [ -n "${NETDATA_HOSTNAME}" ]; then
    # command+="--claim-hostname ${NETDATA_HOSTNAME}"
    command+="-hostname ${NETDATA_HOSTNAME}"
  fi

  if [ -n "${NETDATA_CLOUD_ROOMS}" ]; then
    # command+="--claim-rooms "${NETDATA_CLOUD_ROOMS}""
    command+="-rooms "${NETDATA_CLOUD_ROOMS}""
  fi

  if [ -n "${NETDATA_CLOUD_URL}" ]; then
    # command+="--claim-url \"${NETDATA_CLOUD_URL}\""
    command+="-url \"${NETDATA_CLOUD_URL}\""
  fi

  existing_conf=""

  if [ -e "/data/existing.conf" ]; then
    existing_conf=$(cat /data/existing.conf)
  fi

  if [ "${existing_conf}" == "${command[@]}" ]; then
    bashio::log.info "No claim updates required"
  else
    bashio::log.info "Claiming node with new configuration"

    # sh /tmp/netdata-kickstart.sh "${command[@]}" --claim-only
    # cat /etc/netdata/netdata.conf
    
    bashio::log.info "Starting Netdata..."
    # command=$(IFS=" " ; echo "${command[*]}")
    # command=("-W \"claim ${command[*]}\"")
    /opt/netdata/bin/netdata -p 19999 -D -W "claim ${command[@]}" -c /data/netdata/netdata.conf 
    bashio::log.info "/data/netdata"

    bashio::log.info "Done handling claim updates"
  fi

else
  bashio::log.info "No claim token provided"
fi

# echo "${command[@]}" > /data/existing.conf

# $(IFS=" " ; echo "${command[*]}")
