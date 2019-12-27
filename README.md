# OpenVPN and qBittorrent with WebUI

[![Docker build status](https://img.shields.io/docker/cloud/build/guillaumedsde/qbittorrent-openvpn)]()
[![](https://images.microbadger.com/badges/version/guillaumedsde/qbittorrent-openvpn.svg)](https://microbadger.com/images/guillaumedsde/qbittorrent-openvpn)
[![Docker Automated build](https://img.shields.io/docker/cloud/automated/guillaumedsde/qbittorrent-openvpn)]()
[![](https://images.microbadger.com/badges/image/guillaumedsde/qbittorrent-openvpn.svg)](https://microbadger.com/images/guillaumedsde/qbittorrent-openvpn)
[![Docker Pulls](https://img.shields.io/docker/pulls/guillaumedsde/qbittorrent-openvpn)]()
[![Docker Stars](https://img.shields.io/docker/stars/guillaumedsde/qbittorrent-openvpn)]()

This project is forked from [haugene/docker-transmission-openvpn](https://github.com/haugene/docker-transmission-openvpn) and is currently being adapted to work with qBittorrent instead of Transmision.

This repository was forked from GitHub, as such, the [main repository is on GitHub](https://github.com/guillaumedsde/docker-qbittorrent-openvpn) and a [mirror is on gitlab.com](https://gitlab.com/guillaumedsde/docker-qbittorrent-openvpn) mainly for building the documentation in a CI pipeline. The final images are available in [the docker hub](https://hub.docker.com/r/guillaumedsde/qbittorrent-openvpn/)

## Tags

- `latest` [![](https://images.microbadger.com/badges/image/guillaumedsde/qbittorrent-openvpn:ubuntu.svg)](https://microbadger.com/images/guillaumedsde/qbittorrent-openvpn:ubuntu) as small as an ubuntu image can be, with most up to date qbittorrent-nox

## Port Status

What is working:

- qBittorrent WebUI
- qBittorrent binds to the VPN IP address, this, plus Haugene's firewall configuration means that no data _should_ leak outside the VPN tunnel

What is not working:

- configuration of qBittorrent from ENV variables
- qBittorrent port forwarding

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

The full documentation is available at [https://guillaumedsde.gitlab.io/docker-qbittorrent-openvpn/](https://guillaumedsde.gitlab.io/docker-qbittorrent-openvpn/) .
