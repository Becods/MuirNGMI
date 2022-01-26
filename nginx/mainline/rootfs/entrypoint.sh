#!/bin/bash

set -e

if [[ $NGINX_ENTRYPOINT_QUIET_LOGS = "true" ]]; then
    exec 3>/dev/null
else
    exec 3>&1
fi

if [ "$1" = "nginx" ]; then
    if /usr/bin/find "/scripts/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
        find "/scripts/" -follow -type f -print | sort -V | while read -r f; do
            case "$f" in
                *.sh)
                    if [ -x "$f" ]; then
                        "$f"
                    fi
                    ;;
            esac
        done
    fi
    if /usr/bin/find "/entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
        echo >&3 "$0: 在 /entrypoint.d/ 下找到以下的脚本文件，即将逐个尝试运行"
        find "/entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
            case "$f" in
                *.sh)
                    if [ -x "$f" ]; then
                        echo >&3 "$0: 正在运行 $f";
                        "$f"
                    else
                        echo >&3 "$0: $f 无执行权限，忽略";
                    fi
                    ;;
                *) echo >&3 "$0: 忽略 $f";;
            esac
        done
        echo >&3 "$0: 脚本运行完成，即将启动Nginx"
    else
        echo >&3 "$0: 未在 /entrypoint.d/ 下找到脚本文件，即将启动Nginx"
    fi
fi

exec "$@"