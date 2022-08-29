#!/bin/bash

inotify(){
	inotifywait -rq --timefmt '[%Y/%m/%d %H:%M:%S]' --format '%T %w%f' -e create,delete,modify,attrib "$NGINX_INOTIFY_PATHs"
	/usr/bin/nginx -t > /nginx-test.log 2>&1
	if [[ "$?" -eq "0" ]] ; then
		/usr/bin/nginx -s reload
		echo "["`date +"%Y-%m-%d %T"`"] $0: 配置已更改，Nginx重载成功" > /proc/1/fd/1
	else
		echo "["`date +"%Y-%m-%d %T"`"] $0: 配置已更改，Nginx重载失败，报错如下：" > /proc/1/fd/1
		cat /nginx-test.log > /proc/1/fd/1
	fi
	sleep 5s
	inotify
}

init(){
    if [[ "$NGINX_INOTIFY" = "true" ]]; then
        echo "["`date +"%Y-%m-%d %T"`"]$0: 正在启动自动热重载服务"
        nohup /scripts/inotify.sh inotify >> /dev/null 2>&1 &
        echo "["`date +"%Y-%m-%d %T"`"]$0: 自动热重载服务启动成功"
    else
        exit 0
    fi
    if [[ -n "$NGINX_INOTIFY_PATH" ]];then
        NGINX_INOTIFY_PATHs="/etc/nginx/conf.d"
    elif [ "$(ls -A $NGINX_INOTIFY_PATH)" ]; then
        NGINX_INOTIFY_PATHs=$NGINX_INOTIFY_PATH
    else
        echo "["`date +"%Y-%m-%d %T"`"]$0: 在设置变量 NGINX_INOTIFY_PATH 的时候出现了错误，也许变量 NGINX_INOTIFY_PATH 所设置的目录为空或不存在"
    fi
}

case "$1" in
	inotify)inotify;;
    *)init;;
esac
