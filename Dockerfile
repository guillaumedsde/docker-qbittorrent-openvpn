ARG ARCH=amd64

FROM ubuntu:rolling

ARG ARCH
ARG DOCKERIZE_VERSION=v0.6.1

ARG BUILD_DATE
ARG DOCKER_REPO
ARG VCS_REF

# Build-time metadata as defined at http://label-schema.org
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="$DOCKER_REPO" \
  org.label-schema.description="${ARCH} Docker container running qBittorrent torrent client with WebUI over an OpenVPN tunnel" \
  org.label-schema.url="https://guillaumedsde.gitlab.io/docker-qbittorrent-openvpn/" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/guillaumedsde/docker-qbittorrent-openvpn" \
  org.label-schema.vendor="guillaumedsde" \
  org.label-schema.schema-version="1.0.0-rc1"

VOLUME /data
VOLUME /config

RUN apt update \
  && apt install -y --no-install-recommends software-properties-common \
  && add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable \
  && apt install -y --no-install-recommends \
  curl \
  jq \
  bash \
  qbittorrent-nox \
  curl \
  ufw \
  iputils-ping \
  openvpn \
  bc \
  tzdata \
  tinyproxy \
  dumb-init \
  && curl -OL https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-${ARCH}-${DOCKERIZE_VERSION}.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-linux-${ARCH}-${DOCKERIZE_VERSION}.tar.gz \
  && apt purge -y software-properties-common \
  && apt-get autoremove -y --purge \
  && apt autoclean \
  && apt clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && groupmod -g 1000 users \
  && useradd -u 911 -U -d /config -s /bin/false abc \
  && usermod -G users abc

ADD openvpn/ /etc/openvpn/
ADD transmission/ /etc/transmission/
ADD scripts /etc/scripts/

ENV OPENVPN_USERNAME=**None** \
  OPENVPN_PASSWORD=**None** \
  OPENVPN_PROVIDER=**None** \
  GLOBAL_APPLY_PERMISSIONS=true \
  ENABLE_UFW=false \
  UFW_ALLOW_GW_NET=false \
  UFW_EXTRA_PORTS= \
  UFW_DISABLE_IPTABLES_REJECT=false \
  PUID= \
  PGID= \
  DROP_DEFAULT_ROUTE= \
  WEBPROXY_ENABLED=false \
  WEBPROXY_PORT=8888 \
  HEALTH_CHECK_HOST=google.com

HEALTHCHECK --interval=1m CMD /etc/scripts/healthcheck.sh

# Expose port and run
EXPOSE 8080
CMD ["dumb-init", "/etc/openvpn/start.sh"]
