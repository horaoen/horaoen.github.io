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