+++
title = "积木报表"
date = "2025-03-10"
+++

1. 依赖冲突问题，与mybatis-plus冲突
```
 <dependency>
    <groupId>org.jeecgframework.jimureport</groupId>
    <artifactId>jimureport-spring-boot-starter</artifactId>
    <exclusions>
        <exclusion>
            <groupId>com.github.jsqlparser</groupId>
            <artifactId>jsqlparser</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

2. 实现JmReportTokenServiceI类可自定义接口权限，积木默认会在所有接口请求中携带token
3. mongodb依赖启动报错，不需要mongodb可以屏蔽MongoAutoConfiguration
```yml
spring:
  autoconfigure:
    exclude: org.springframework.boot.autoconfigure.mongo.MongoAutoConfiguration
```