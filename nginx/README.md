# Nginx

## Tags
```
nginx - mainline - full - 220115
  ↑        ↑         ↑       ↑
Nginx    branch   feature buildtime
```

## Currently supported microservice module
- HTTP/2支持 <sup>all</sup>
- brotli压缩 <sup>all</sup>
- TLSv1.3 <sup>all</sup>
- Zlib of cloudflare fork <sup>mainline</sup>
- OpenSSL 3.0 <sup>mainline</sup>
- Lua模块支持 <sup>all</sup>
- 超多模块可选 <sup>mainlline quic</sup>
- 自动热重载 <sup>inotify</sup>

## Upcoming supported microservice modules
- HTTP/3支持 <sup>quic</sup>
- Boringssl <sup>mainline quic</sup>

## Feature
### full
- 全模块完整版`需要手动引用`

### hard
- 硬编译全模块完整版

## ENVs

|  环境变量 | 参数类型 | 默认 | 作用 |
|  ---- | ---- | ---- | ---- |
| NGINX_ENTRYPOINT_QUIET_LOGS  | 布尔值 | false | 禁用/启用启动脚本的提示 |
| NGINX_INOTIFY | 布尔值 | true | 禁用/启用自动热重载 |
| NGINX_INOTIFY_PATH | 字符串 | `/etc/nginx/conf.d` | 自动热重载检测路径 |