#!/bin/bash

set -e

if [ ! -d "/etc/cron.d/" ]; then
	echo "["`date +"%Y-%m-%d %T"`"] $0: 未找到cron文件，请挂载cron文件到/etc/cron.d/后再重试";
	exit 0
fi
for i in `ls /etc/cron.d/`;do
	echo "["`date +"%Y-%m-%d %T"`"] $0: 正在激活 $i";
	crontab "/etc/cron.d/"$i
done
crontab -l
echo "===================="
exec "$@"