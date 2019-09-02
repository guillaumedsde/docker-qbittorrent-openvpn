# OpenVPN and qBittorrent with WebUI

[![Docker Automated build](https://img.shields.io/docker/automated/guillaumedsde/qbittorrent-openvpn.svg)](https://hub.docker.com/r/guillaumedsde/qbittorrent-openvpn/)
[![Docker Pulls](https://img.shields.io/docker/pulls/guillaumedsde/qbittorrent-openvpn.svg)](https://hub.docker.com/r/guillaumedsde/qbittorrent-openvpn/)

This project is forked from [haugene/docker-transmission-openvpn](https://github.com/haugene/docker-transmission-openvpn) and is currently being adapted to work with qBittorrent instead of Transmision.

## Quick Start

This container contains OpenVPN and qBittorrent with a configuration
where qBittorrent is running only when OpenVPN has an active tunnel.
It bundles configuration files for many popular VPN providers to make the setup easier.

```
$ docker run --cap-add=NET_ADMIN -d \
              -v /your/storage/path/:/data \
              -v /etc/localtime:/etc/localtime:ro \
              -e CREATE_TUN_DEVICE=true \
              -e OPENVPN_PROVIDER=PIA \
              -e OPENVPN_CONFIG=CA\ Toronto \
              -e OPENVPN_USERNAME=user \
              -e OPENVPN_PASSWORD=pass \
              -e WEBPROXY_ENABLED=false \
              -e LOCAL_NETWORK=192.168.0.0/16 \
              --log-driver json-file \
              --log-opt max-size=10m \
              -p 8080:8080 \
              guillaumedsde/qbittorrent-openvpn
```

## Documentation
The full documentation is available at https://guillaumedsde.github.io/docker-qbittorrent-openvpn/.
