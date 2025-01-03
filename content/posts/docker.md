+++
title = "docker"
date = "2024-12-24"
+++

## 拉取镜像报错清理缓存
```
docker system prune -a
```

## 启动mysql
```shell
docker run --name mysql-3307 -e MYSQL_ROOT_PASSWORD=123456 -p 3307:3306 -d mysql:latest
```

## 进入容器实例
```shell
docker exec -it {container-name} bash
```