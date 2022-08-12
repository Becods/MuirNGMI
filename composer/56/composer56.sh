#!/bin/bash

docker run -it --rm \
 -e TZ=Asia/Shanghai \
 -v /data/wwwroot:/var/www/html \
 -v /data/composer/bash_history.56:/home/www/.bash_history \
 becod/composer:5.6