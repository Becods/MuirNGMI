<div align="center">

# MuirNGSI

_✨ Muir下一代微服务架构 ✨_

开源 · 便携 · 多架构 · 安全 · 迅速

</div>

## Feature
- 微服务架构
- 源代码编译多版本
- 非特权用户身份运行
- 攻击面减少~~shell，UNIX工具，包管理器~~
- unix socks通信
- 持久化储存
- 高度可配置
- 开箱即用
- 一键部署

### Docker
使用 Docker 能够在让独立的服务或应用程序在不同的环境中得到相同的运行结果

### Microservices
微服务是一种软件架构风格，它是以专注于单一责任与功能的小型功能区块为基础，利用模块化的方式组合出复杂的大型应用程序。例如，以下每个微服务都将存在于一个 Docker 容器中：

- 在 Node.js 中运行的 Web 应用程序
- Redis 储存 Node.js Web应用程序的会话数据
- MongoDB 作为 Node.js Web应用程序的数据库
- Nginx 代理对 Node.js 的请求

## Currently supported microservice module
Please wait...

## Upcoming supported microservice modules
### Nginx
- 硬编码错误页面
- server头修改
- 0-RTT
- Lua模块支持
- brotli压缩
- NJS
- Cookie-Flag
- TLSv1.3
- BoringSSL
- Cloudflare fork of zlib
- **10mb超小体积**

### PHP
- 源代码编译超多稳定版本(5.6 7.0 7.1 7.2 7.3 7.4 8.0)
- 常用模块安装+可选模块
- **10mb超小体积**

### NodeJS
- 源代码编译多版本支持(12 14 16 17)
- 配套npm

### Python
- 源代码编译多版本支持(3.10 2.7)
- 自动安装所需库

### Mysql
- 源代码编译多版本支持(5.6 5.7 8.0)

### MongoDB
- 源代码编译最新版本

### PostgreSQL
- 源代码编译多版本支持(12.8 14.0)

### Redis
- 源代码编译最新版本

### Memcached
- 源代码编译最新版本

### Tomcat
- 源代码编译多版本支持(8.5.72 9.0.54 10.0.12)

### Java
+ 包含常用java发行版
  + temurin (8 11 17)
  + openj9 (8 11 17)
  + zulu (8 11 17)
  + dragonwell (8 11 17)

### Haproxy
- 源代码编译最新版本

## TODO
- 集群支持
- 分布式架构
- 性能优化
- 自动发现
- 控制面板
