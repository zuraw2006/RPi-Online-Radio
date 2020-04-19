# RPi Online Radio

This Docker image allows you to change your Raspberry Pi into an online radio player that you can manage by web interface.

## How to use this image

```shell
docker run -d \
  --name my-rpi-radio \
  -p 8080:4567 \
  -v </path/to/playlist>:/usr/src/app/playlist \
  --device /dev/snd \
  zuraw2006/rpi-online-radio
```

Where ```</path/to/playlist>``` is for example ```$PWD/playlist```\
Playlist is a folder for ```.m3u``` and ```.pls``` - online radio file format supported by this docker image. \
Web interface: ```</your/raspberryPi/Url>```:8080

## Sound Device

RPi Online Radio requires access to host's sound device to function correctly which can be achieved using the ```--device /dev/snd``` flag.

## Raspberry Pi

This Docker image has been tested on Raspberry Pi 3 Model B+ and Raspbian OS 
