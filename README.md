# docker squeezebox


Logitech Media Server : http://www.mysqueezebox.com/update/?version=7.9.0&revision=1&geturl=1&os=deb

OS : debian 8 (official)
Installed : curl wget supervisor perl faad flac lame sox libio-socket-ssl-perl

RUN :

docker run -d \
  --name <name_for_container> \
  -p 3483:3483 -p 9000:9000 -p 9090:9090 -p 3483:3483/udp \
  -v <data_dir>:/config \
  -v <music_dir>:/share/Music \
  tonykuo2002/docker-squeezebox:latest
