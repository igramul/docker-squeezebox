FROM debian:8

LABEL maintainer="Dave Gillies <dave.gillies@gmail.com>" 

ENV DEBIAN_FRONTEND noninteractive
ENV CURRENT_VERSION 2017-12-11
ENV lms_version 7.9.1
# `debamd64` debs are still `all` arch
ENV lms_os debamd64

# Update system and install dependencies
RUN apt-get -qq update && \
    apt-get -qq -y install curl \
    perl faad flac lame sox libio-socket-ssl-perl \
    locales python-dev python-pip cpanminus git python-lxml

# Set locale to UTF-8
RUN locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

# Install Google Music dependencies
RUN pip install git+https://github.com/simon-weber/gmusicapi.git@develop && \
   cpanm --notest Inline; \
   cpanm --notest Inline::Python

# Fetch and install Logitech Media Server
RUN curl -s -o /tmp/logitechmediaserver.deb \
    $(curl -s "http://www.mysqueezebox.com/update/?version=${lms_version}&revision=1&geturl=1&os=${lms_os}") && \
    dpkg --install /tmp/logitechmediaserver.deb ; \
    rm -f /tmp/logitechmediaserver.deb

# Clean up
RUN apt-get remove -qq -y locales python-dev python-pip cpanminus git python-lxml && \
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
