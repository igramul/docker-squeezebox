FROM ubuntu:20.04

LABEL maintainer="Lukas Burger <lukas.burger@igramul.ch>" 

ENV DEBIAN_FRONTEND noninteractive
ENV lms_version 7.9.3
# `debamd64` debs are still `all` arch
ENV lms_os all
ENV lms_ref 3a188b1a5aaa9ccffa2ad11fcee5f763b71bc122
ENV lms_ts 1590655312
ENV lms_deb_file http://downloads.slimdevices.com/nightly/7.9/sc/${lms_ref}/logitechmediaserver_${lms_version}~${lms_ts}_${lms_os}.deb
# Update system and install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install curl \
    faad flac lame sox libio-socket-ssl-perl \
    locales python3-pip libinline-python-perl

# Set locale to UTF-8
RUN /usr/sbin/locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

# Install Google Music dependencies
RUN python3 -m pip install --no-cache-dir gmusicapi==13.0.0

# Fetch and install Logitech Media Server
RUN set -e; curl -s -o /tmp/logitechmediaserver.deb ${lms_deb_file}; \
    dpkg --install /tmp/logitechmediaserver.deb; \
    rm /tmp/logitechmediaserver.deb

# Clean up
RUN apt-get remove -y locales python3-pip python3-dev && \
    apt-get autoremove -y; \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /config && chown squeezeboxserver. /config

# Container data volume
VOLUME ["/config"]
WORKDIR /config

# Expose ports
EXPOSE 3483/tcp 3483/udp 9000/tcp 9090/tcp

ENV LANG C.UTF-8
USER squeezeboxserver
CMD ["/usr/sbin/squeezeboxserver", "--prefsdir", "/config/prefs", "--logdir", "/config/logs", "--cachedir", "/config/cache", "--charset=utf8"]

