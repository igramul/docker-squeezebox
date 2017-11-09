FROM debian:8

MAINTAINER Tony Kuo <tonykuo2002@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV CURRENT_VERSION 2017-11-08

# Update system and install dependencies
RUN apt-get update && \
  apt-get -y install curl wget supervisor perl faad flac lame sox libio-socket-ssl-perl && \
  apt-get clean

# Fetch and install Logitech Media Server
RUN wget -O /tmp/logitechmediaserver.deb \
    $(wget -q -O - "http://www.mysqueezebox.com/update/?version=7.9.0&revision=1&geturl=1&os=deb") && \
  dpkg --install /tmp/logitechmediaserver.deb

# File system fixes
RUN rm -f /tmp/logitechmediaserver.deb && \
  mkdir -p /config /var/log/supervisor

# Add start script
COPY logitechmediaserver.conf /etc/supervisor/conf.d/logitechmediaserver.conf

# Container data volume
VOLUME ["/config"]
WORKDIR /config

# Expose ports
EXPOSE 3483/tcp 3483/udp 9000/tcp 9090/tcp

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
