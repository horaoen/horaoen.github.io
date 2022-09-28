---
title: ClassLoader
toc: true
date: 2022-08-31 17:43:18
tags: jvm ClassLoader
categories: 
    - java面试
    - jvm
typora-root-url: ClassLoader
---

# 类加载器的层级关系

- JVM支持两种类型的类加载器，分别为引导类加载器(Bootstrap ClassLoader)和自定义类加载器（User-Defined ClassLoader)。
- 从概念上来讲，自定义类加载器一般指的是程序中由开发人员自定义的一类加载器，但是Java虚拟机规范却没有这么定义，而是将**所有派生于抽象类ClassLoader的类加载器都划分为自定义类加载器。**
- 无论类加载器的类型如何划分，在程序中我们最常见的类加载器始终只有3
  个，ClassLoader 的paren关系以及继承关系如下图所示：

![image-20220831181959406](image-20220831181959406.png)



![image-20220831183147074](image-20220831183147074.png)

- 启动类加载器（BootstrapClassLoader) 加载java核心类库包括ExtClassLoader、AppClassLoader。

- 扩展类加载器 (ExtClassLoader) 继承自ClassLoader，可加载用户放在jre/lib/ext目录下的jar包 或java.ext.dirs系统属性所指定的目录加载类库。
- 系统类加载器(AppClassLoader) 加载用户自定义类



```java
/**
 * @author horaoen
 */
public class ClassLoaderTest {
    public static void main(String[] args) {
        ClassLoader systemClassLoader = ClassLoader.getSystemClassLoader();
        System.out.println("systemClassLoader: " + systemClassLoader);
        //systemClassLoader: sun.misc.Launcher$AppClassLoader@18b4aac2
        
        ClassLoader extClassLoader = systemClassLoader.getParent();
        System.out.println("extClassLoader: " + extClassLoader);
        //extClassLoader: sun.misc.Launcher$ExtClassLoader@1b6d3586
        
        ClassLoader bootstrapClassLoader = extClassLoader.getParent();
        System.out.println("bootstrapClassLoader: " + bootstrapClassLoader);
        //bootstrapClassLoader: null c/c++编写 无法加载
    }
   
}
```



# 参考资料

> - [bilibili-尚硅谷jvm-ClassLoader](https://www.bilibili.com/video/BV1PJ411n7xZ?p=31&vd_source=7ab43036b8c368bf0578c31e9437d6ed)

