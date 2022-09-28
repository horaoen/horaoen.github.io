---
title: 阿里云效maven私服
toc: true
date: 2022-09-21 10:16:09
tags: 
categories:
    - java技术
    - 开发环境
typora-root-url: 阿里云效maven私服
---

> 前段时间写了一个starter(spring boot), 有另外一个web项目要引用， 本地跑跑还可以但是当我将代码推送到远程仓库时触发的jenkins构建任务就会失败，原因是这个starter只存在于本地maven仓库，我需要将它推送到一个可被访问的远程仓库上才能被别的项目拉取依赖，我用github packages实现了这个需求，现在又发现了一个更加简单的方法，利用阿里云效。

# 基本环境准备

1. 首先你需要注册阿里云效的账号 [云效](https://devops.aliyun.com/)
2. 然后需要有可以实验的项目，这里我准备了两个个人项目供实验
   1. https://gitee.com/horaoen/sailor-cms.git
   2. https://gitee.com/horaoen/sailor-cms-core.git
3. 本地maven、jdk环境，这个就不用多说。

# 推送

1.  ![image-20220921103510978](image-20220921103510978.png)

2. ![image-20220921103606919](image-20220921103606919.png)

3. ![image-20220921103639921](image-20220921103639921.png)

4. ![image-20220921103747018](image-20220921103747018.png)

5. 推送方式有两种，如果你本地配置了其它远程库那么就只能用修改的方法，如果没有建议直接覆盖，还可以顺便修改阿里maven源，按照文档将settings.xml放在指定位置

6. 配置项目的推送目标地址，以需要上面那个sailor-cms-core的项目为例，我们需要在根pom.xml中添加如下配置![image-20220921104236804](image-20220921104236804.png)

   这里我附上模板文件

   ```xml
   <distributionManagement>
           <repository>
               <id>rdc-releases</id>
               <name>Release Deploy</name>
               <url>https://packages.aliyun.com/maven/repository/****-release-kjYWpG</url>
           </repository>
           <snapshotRepository>
               <id>rdc-snapshots</id>
               <name>Snapshot Deploy</name>
               <url>https://packages.aliyun.com/maven/repository/****-snapshot-0GTZRF</url>
           </snapshotRepository>
       </distributionManagement>
   ```

7. 配置参数可以在setting.xml中找到![image-20220921104647253](image-20220921104647253.png)

8. 如图先打包再推送![image-20220921110720611](image-20220921110720611.png)

9. 这里有注意点：阿里云效maven默认不允许覆盖，支持覆盖需要如图开启配置![image-20220921105204186](image-20220921105204186.png)

10. 结果如下![image-20220921111031589](image-20220921111031589.png)

# 拉取

拉取就很简单了，如果在本地你可以直接配置<denpendencies></denpendencies>节点引入依赖，在远程服务器打包时需要将maven环境配置与本地相同也就是用同样的方法覆盖settings.xml

看看效果：

由于我本地maven仓库已经有了sailor-cms-core这个包，想要复现下载过程需要先删除。

重新mvn install, 成功了![image-20220922091600050](image-20220922091600050.png)

这里我push代码看一下jenkins的构建过程（需要先改jenkins上实用的maven配置，同上settings.xml)

![image-20220922092053947](image-20220922092053947.png) 构建任务也成功。
