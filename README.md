# Docker Squeezebox Server
![](https://img.shields.io/badge/logitechmediaserver-v7.9.1-007EC7.svg?style=flat-square) ![](https://img.shields.io/docker/automated/davewongillies/squeezebox.svg?maxAge=2592000) ![](https://img.shields.io/docker/build/davewongillies/squeezebox.svg?maxAge=2592000)

OS: Debian 8 (official)
Installed:
 * [Logitech Media Server 7.9.1](http://www.mysqueezebox.com/update/?version=7.9.1&revision=1&geturl=1&os=deb)
 * [Unofficial Google Music API](https://github.com/simon-weber/gmusicapi) python module

## Running the container
```
# docker run -d \
  --name <name_for_container> \
  --net=host \
  -p 3483:3483 -p 9000:9000 -p 9090:9090 -p 3483:3483/udp \
  -v <data_dir>:/config \
  -v <music_dir>:/share/Music \
  davewongillies/squeezebox:latest
```
