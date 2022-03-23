#!/bin/bash

docker run -it --rm \
 -e TZ=Asia/Shanghai \
 -v /data/wwwroot:/var/www/html \
 -v /data/composer/bash_history.81:/home/www/.bash_history \
 becod/composer:8.1