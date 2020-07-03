# Docker Squeezebox Server
![](https://img.shields.io/badge/logitechmediaserver-v7.9.3-007EC7.svg?style=flat-square)

OS: Ubuntu Focal 20.04 (official)
Installed:
 * [Logitech Media Server 7.9.3](http://www.mysqueezebox.com/update/?version=7.9.3&revision=1&geturl=1&os=deb)
 * [gmusicapi 13.0.0](https://github.com/simon-weber/gmusicapi) python module

## Running the container
```
# docker run -d \
  --name <name_for_container> \
  --net=host \
  -p 3483:3483 -p 9000:9000 -p 9090:9090 -p 3483:3483/udp \
  -v <data_dir>:/config \
  -v <music_dir>:/share/Music \
  igramul/squeezebox:latest
```

If you've got `docker-compose` installed:
```
# docker-compose up -d
```

By default it looks for `config` and `music` directories in the current directory. To start with other directories:
```
# docker-compose up -d -e LMS_CONFIG_DIR=<path_to_config_directory> -e LMS_MUSIC_DIR=<path_to_music_directory>
```
