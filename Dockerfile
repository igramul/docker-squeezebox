FROM ubuntu:bionic

LABEL maintainer="Dave Gillies <dave.gillies@gmail.com>" 

ENV DEBIAN_FRONTEND noninteractive
ENV CURRENT_VERSION 2017-12-23
ENV lms_version 7.9.2
# `debamd64` debs are still `all` arch
ENV lms_os all
ENV lms_ref b84cade9c077104144ee60085c2a9a07786b40d9
ENV lms_ts 1554450933

# Update system and install dependencies
RUN apt-get update && \
    apt-get -y install curl \
    faad flac lame sox libio-socket-ssl-perl \
    locales python-pip libinline-python-perl ; \
    apt-get dist-upgrade -y

# Set locale to UTF-8
RUN locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

# Install Google Music dependencies
RUN pip install --no-cache-dir gmusicapi==12.0.0

# Fetch and install Logitech Media Server
RUN curl -s -o /tmp/logitechmediaserver.deb \
     http://downloads.slimdevices.com/nightly/7.9/sc/${lms_ref}/logitechmediaserver_${lms_version}~${lms_ts}_${lms_os}.deb && \
    dpkg --install /tmp/logitechmediaserver.deb ; \
    rm -f /tmp/logitechmediaserver.deb

# Clean up
RUN apt-get remove -y locales python-pip python-dev && \
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
