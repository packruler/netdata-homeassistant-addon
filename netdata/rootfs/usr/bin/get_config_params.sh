#!/usr/bin/env bashio

command=()

NETDATA_HOSTNAME=$(bashio::config 'hostname')
bashio::log.info "Netdata configuration: set hostname to ${NETDATA_HOSTNAME}"
command+="-W set global hostname ${NETDATA_HOSTNAME}"

NETDATA_PAGE_CACHE_SIZE=$(bashio::config 'page_cache_size')
bashio::log.info "Netdata configuration: set page_cache_size to ${NETDATA_PAGE_CACHE_SIZE}"
command+="-W set db dbengine page cache size ${NETDATA_PAGE_CACHE_SIZE}"

NETDATA_DBENGINE_DISK_SPACE=$(bashio::config 'dbengine_disk_space')
bashio::log.info "Netdata configuration: set page_cache_size to ${NETDATA_DBENGINE_DISK_SPACE}"
command+="-W set db dbengine disk space ${NETDATA_DBENGINE_DISK_SPACE}"

NETDATA_ENABLE_ALARM=$(bashio::config 'enable_alarm')
if [[ ${NETDATA_ENABLE_ALARM} == "false" ]]
then
    bashio::log.info "Netdata configuration: alarm is ${NETDATA_DISABLE_ALARM}"
    command+="-W set health enabled no"
fi

NETDATA_ENABLE_LOG=$(bashio::config 'enable_log')
if [[ ${NETDATA_ENABLE_LOG} == "false" ]]
then
    bashio::log.info "Netdata configuration: logging is ${NETDATA_DISABLE_LOG}"
    command+="-W set logs debug log none"
    command+="-W set logs error log none"
    command+="-W set logs access log none"
fi

$(IFS=" " ; echo "${command[*]}")
