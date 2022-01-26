#!/bin/bash

print(){
    echo "============= `date +'%Y%m%d'` ==============="
    echo " $1"
    echo "======================================"
}

print [Info]正在准备Nginx环境
docker build . -t nginx:builder -f Dockerfile.builder
print [Info]正在打包nginx
docker build . -t nginx -f Dockerfile
print [Info]正在准备Nginx模块环境
docker build . -t nginx:modules -f Dockerfile.modules
print [Info]正在打包nginx:full
docker build . -t nginx:full -f Dockerfile.full
print [Info]正在制作nginx:fixed
docker build . -t nginx:fixed -f Dockerfile.fixed
print [Info]nginx制作完成
