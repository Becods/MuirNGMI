#!/bin/bash

inotify(){
	inotifywait -rq --timefmt '[%Y/%m/%d %H:%M:%S]' --format '%T %w%f' --event modify "$NGINX_INOTIFY_PATHs"
	if [[ "$?" -eq "MODIFY" ]] ; then
		/bin/nginx -s reload
	fi
	sleep 5s
	inotify
}

init(){
    if [[ "$NGINX_INOTIFY" = "true" ]]; then
        echo "$0: 正在启动自动热重载服务"
        nohup inotify.sh inotify >> /dev/null 2>&1 &
        echo "$0: 自动热重载服务启动成功"
    else
        exit 0
    fi
    if [[ -n "$NGINX_INOTIFY_PATH" ]];then
        NGINX_INOTIFY_PATHs="/etc/nginx/conf.d"
    elif [ "$(ls -A $NGINX_INOTIFY_PATH)" ]; then
        NGINX_INOTIFY_PATHs=$NGINX_INOTIFY_PATH
    else
        echo "$0: 在设置变量 NGINX_INOTIFY_PATH 的时候出现了错误，也许变量 NGINX_INOTIFY_PATH 所设置的目录为空或不存在"
    fi
}

case "$1" in
	inotify)inotify;;
    *)init;;
esac
