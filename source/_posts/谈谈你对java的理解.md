---
title: 谈谈你对java的理解
toc: true
date: 2022-08-31 16:04:30
tags: 
categories:
    - java面试
    - 面试
typora-root-url: 谈谈你对java的理解
---

# 六大方面

## 平台无关性

![image-20220831161853958](image-20220831161853958.png)

Java源码首先被编译成字节码，再由不同平台的JVM进行解析，Java语言在不同的平台上运行时不需要进行重新编译，Java虚拟机在执行字节码的时候，把字节码转换成具体平台上的机器指令。

### 为什么JVM不直接将源码解析成机器码去执行

1. 准备工作:每次执行都需要各种检查

2. 兼容性∶也可以将别的语言解析成字节码

#### JVM如何加载class文件

1. ![image-20220831165031840](image-20220831165031840.png)
2. Class Loader:依据特定格式，加载class文件到内存
3. Execution Engine :对命令进行解析
4. Native Interface:融合不同开发语言的原生库为Java所用
5. Runtime Data Area : JVM内存空间结构模型

## GC

## 语言特性

## 面向对象

## 类库

## 异常处理



# 


## 参考资料
> - []()
> - []()