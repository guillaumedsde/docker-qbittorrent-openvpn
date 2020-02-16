#!/bin/bash

# Source our persisted env variables from container startup
. /etc/transmission/environment-variables.sh

# This script will be called with tun/tap device name as parameter 1, and local IP as parameter 4
# See https://openvpn.net/index.php/open-source/documentation/manuals/65-openvpn-20x-manpage.html (--up cmd)
echo "Up script executed with $*"
if [[ "$4" = "" ]]; then
  echo "ERROR, unable to obtain tunnel address"
  echo "killing $PPID"
  kill -9 $PPID
  exit 1
fi

# If transmission-pre-start.sh exists, run it
if [[ -x /scripts/transmission-pre-start.sh ]]; then
  echo "Executing /scripts/transmission-pre-start.sh"
  /scripts/transmission-pre-start.sh "$@"
  echo "/scripts/transmission-pre-start.sh returned $?"
fi

echo "Updating TRANSMISSION_BIND_ADDRESS_IPV4 to the ip of $1 : $4"
export TRANSMISSION_BIND_ADDRESS_IPV4=$4

echo "Generating qBittorrent qBittorrent.conf from env variables"
QBT_CONFIG_FILE=/config/qBittorrent/config/qBittorrent.conf

if [ -f "$QBT_CONFIG_FILE" ]; then
  # if Connection address line exists
  if grep -q 'Connection\\InterfaceAddress' "$QBT_CONFIG_FILE"; then
    # Set connection interface address to the VPN address
    sed -i -E 's/^.*\b(Connection.*InterfaceAddress)\b.*$/Connection\\InterfaceAddress='"$TRANSMISSION_BIND_ADDRESS_IPV4"'/' $QBT_CONFIG_FILE
  else
    # add the line for configuring interface address to the qBittorrent config file
    echo 'Connection\\InterfaceAddress='"$TRANSMISSION_BIND_ADDRESS_IPV4" >>"$QBT_CONFIG_FILE"
  fi
else
  # Ensure config directory is created
  mkdir -p /config/
  # Create the configuration file from a template and environment variables
  dockerize -template /etc/transmission/settings.tmpl:/config/qBittorrent/config/qBittorrent.conf
fi

if [[ ! -e "/dev/random" ]]; then
  # Avoid "Fatal: no entropy gathering module detected" error
  echo "INFO: /dev/random not found - symlink to /dev/urandom"
  ln -s /dev/urandom /dev/random
fi

. /etc/transmission/userSetup.sh

if [[ "true" = "$DROP_DEFAULT_ROUTE" ]]; then
  echo "DROPPING DEFAULT ROUTE"
  ip r del default || exit 1
fi

echo "STARTING QBITTORRENT"
exec su --preserve-environment ${RUN_AS} -s /bin/bash -c "/usr/bin/qbittorrent-nox --webui-port="8080" --profile=/config" &

# This is disabled for now as I have not implemented port forwarding configuration for qbittorrent

# if [[ "${OPENVPN_PROVIDER^^}" = "PIA" ]]
# then
#     echo "CONFIGURING PORT FORWARDING"
#     exec /etc/transmission/updatePort.sh &
# elif [[ "${OPENVPN_PROVIDER^^}" = "PERFECTPRIVACY" ]]
# then
#     echo "CONFIGURING PORT FORWARDING"
#     exec /etc/transmission/updatePPPort.sh ${TRANSMISSION_BIND_ADDRESS_IPV4} &
# else
#     echo "NO PORT UPDATER FOR THIS PROVIDER"
# fi

# If transmission-post-start.sh exists, run it
if [[ -x /scripts/transmission-post-start.sh ]]; then
  echo "Executing /scripts/transmission-post-start.sh"
  /scripts/transmission-post-start.sh "$@"
  echo "/scripts/transmission-post-start.sh returned $?"
fi

echo "qBittorrent startup script complete."
