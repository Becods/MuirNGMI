<div align="center">

# MuirNGSI

_✨ Muir下一代微服务架构 ✨_

开源 · 便携 · 多架构 · 安全 · 迅速

</div>

## Feature
- 微服务架构
- 非特权用户身份运行
- unix socks通信<sup>示例默认</sup>
- 持久化储存
- 高度可配置
- 开箱即用
- 一键部署
- 脚本配置

更多特性请点击对应模块

### Docker
使用 Docker 能够在让独立的服务或应用程序在不同的环境中得到相同的运行结果

### Microservices
微服务是一种软件架构风格，它是以专注于单一责任与功能的小型功能区块为基础，利用模块化的方式组合出复杂的大型应用程序。例如，以下每个微服务都将存在于一个 Docker 容器中：

- 在 PHP 中运行的 Web 应用程序
- Redis 储存 PHP Web应用程序的会话数据
- Mysql 作为 PHP Web应用程序的数据库
- Nginx 代理对 PHP 的请求

## Currently supported microservice module
- Nginx
- PHP
- Composer
- cron

## Upcoming supported microservice modules

### Java
+ 包含常用java发行版
  + temurin (8 11 17)
  + openj9 (8 11 17)
  + zulu (8 11 17)
  + dragonwell (8 11 17)

## TODO
- 集群支持
- 分布式架构
- 性能优化
- 自动发现
- 控制面板