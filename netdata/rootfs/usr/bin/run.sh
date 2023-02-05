#!/usr/bin/with-contenv bashio
bashio::log.info "Configuring Netdata..."
# /usr/bin/config_netdata.sh

# bashio::log.info "Claiming agent to Netdata cloud... (may take a few seconds to show up in https://app.netdata.cloud)"
# # /usr/bin/connect_to_netdata_cloud.sh &

# bashio::log.info "Starting Netdata..."
# # exec /opt/netdata/bin/netdata -p 19999 -D -c /data/netdata/netdata.conf

# tail -f /dev/null

config_commands=()
config_commands+=("-W set global hostname \"$(bashio::config 'hostname')\"")
config_commands+=("-W set db \"page cache size MB\" \"$(bashio::config 'page_cache_size')\"")
config_commands+=("-W set db \"dbengine multihost disk space MB\" \"$(bashio::config 'dbengine_disk_space')\"")

bashio::log.info "Netdata configuration: alarm is $(bashio::config 'enable_alarm')"
if [[ "$(bashio::config 'enable_alarm')" == "false" ]]
then
    config_commands+=("-W set health \"enabled\" no")
fi

NETDATA_ENABLE_LOG=$(bashio::config 'enable_log')
bashio::log.info "Netdata configuration: logging is ${NETDATA_ENABLE_LOG}"
if [[ ${NETDATA_ENABLE_LOG} == "false" ]]
then
    config_commands+=("-W set logs \"debug\" none")
    config_commands+=("-W set logs \"error\" none")
    config_commands+=("-W set logs \"access\" none")
fi


NETDATA_HOSTNAME=$(bashio::config 'hostname')
NETDATA_CLOUD_URL=$(bashio::config 'claim_url')
NETDATA_CLOUD_TOKEN=$(bashio::config 'claim_token')
NETDATA_CLOUD_ROOMS=$(bashio::config 'claim_rooms')

claim_config=()
connectable=true


if [ -n "${NETDATA_CLOUD_TOKEN}" ]; then
    # command+=("--claim-token ${NETDATA_CLOUD_TOKEN}")
    claim_config+=("-token ${NETDATA_CLOUD_TOKEN}")

    if [ -n "${NETDATA_HOSTNAME}" ]; then
        # command+=("--claim-hostname ${NETDATA_HOSTNAME}")
        claim_config+=("-hostname ${NETDATA_HOSTNAME}")
    fi

    if [ -n "${NETDATA_CLOUD_ROOMS}" ]; then
        # command+=("--claim-rooms "${NETDATA_CLOUD_ROOMS}"")
        claim_config+=("-rooms "${NETDATA_CLOUD_ROOMS}"")
    fi

    if [ -n "${NETDATA_CLOUD_URL}" ]; then
        # command+=("--claim-url \"${NETDATA_CLOUD_URL}\"")
        claim_config+=("-url '${NETDATA_CLOUD_URL}'")
    fi

    bashio::log.info "Claiming node with new configuration"

    # sh /tmp/netdata-kickstart.sh "${command[@]}" --claim-only
    # cat /etc/netdata/netdata.conf
    
    # bashio::log.info "Starting Netdata..."
    # command=$(IFS=" " ; echo "${command[*]}")
    config_commands+=("-W \"claim ${claim_config[@]}\"")
    bashio::log.info "Done handling claim updates"

else
  bashio::log.info "No claim token provided"
fi

echo "${config_commands[@]}"

/bin/bash -c "/opt/netdata/bin/netdata -p 19999 -D -c /data/netdata/netdata.conf ${config_commands[@]}"
