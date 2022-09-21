---
title: JUC
toc: true
date: 2022-09-01 09:30:48
tags: JUC
categories: 
  - java面试
  - java基础
  - JUC
typora-root-url: JUC

---

# 基本概念

1. 进程线程
   1. 进程：资源分配的最小单位 
   2. 线程：程序执行的最小单位
2. 线程的状态
   1. ![image-20220901095155241](image-20220901095155241.png)
3. wait和sleep
4. 并发和并行
5. 管程（monitor)
6. 用户线程和守护线程

# lock接口

1. Synchronized 

2. 创建线程的多种方式

   1. 继承Tread类
   2. 实现Runnable接口
   3. 使用Callable接口
   4. 使用线程池

3. 案例（售票）

   > ```java
   > /**
   >  * @author horaoen
   >  */
   > public class  SaleTicket{
   >     public static void main(String[] args) {
   >         Ticket ticket = new Ticket();
   >         final int ticketNum = 30;
   >         new Thread(() -> {
   >             for (int i = 0; i < ticketNum; i++) {
   >                 ticket.sale();
   >             }
   >         },"窗口1").start();
   >         
   >         new Thread(() -> {
   >             for (int i = 0; i < ticketNum; i++) {
   >                 ticket.sale();
   >             }
   >         },"窗口2").start();
   >         
   >         new Thread(() -> {
   >             for (int i = 0; i < ticketNum; i++) {
   >                 ticket.sale();
   >             }
   >         },"窗口3").start();
   >     }
   >    
   > }
   > 
   > ```

   1. synchronized方式

      ```java
      public class Ticket {
          private int number = 30;
      
          public synchronized void sale() {
              if (number > 0) {
                  System.out.println(Thread.currentThread().getName() + "卖出第" + (30 - number + 1) + "张票");
                  number--;
              } else {
                  System.out.println("票已售完");
              }
          }
      }
      ```
   
      
   
   2. 可重入锁ReentrantLock
   
      ```java
      import java.util.concurrent.locks.Lock;
      import java.util.concurrent.locks.ReentrantLock;
      
      /**
       * @author horaoen
       */
      public class Ticket {
          private int number = 30;
      
          private final Lock lock = new ReentrantLock();
          public void sale() {
              lock.lock();
              try {
                  if (number > 0) {
                      System.out.println(Thread.currentThread().getName() + "卖出第" + (30 - number + 1) + "张票");
                      number--;
                  } else {
                      System.out.println("票已售完");
                  }
              } catch (Exception e) {
                  e.printStackTrace();
              } finally {
                  lock.unlock();
              }
             
          }
      }
      ```
      
      
      

# 参考资料

> - [尚硅谷-JUC]([02.尚硅谷_JUC-JUC概述和进程线程概念（1）_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Kw411Z7dF?p=2&spm_id_from=pageDriver&vd_source=7ab43036b8c368bf0578c31e9437d6ed))
