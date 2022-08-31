---
title: test
date: 2022-08-31 12:07:58
tags: jvm
categories:
    - java面试
    - jvm
    - test
---

```java
/**
 * @author horaoen
 */
public class SyncTest {
    private int num = 0;
    
    public void test() {
        for (int i = 0; i < 1000; i++) {
            synchronized (this) {
                System.out.println("thread:" + Thread.currentThread().getId() + " num:" + num++);
            }
        }
    }

    public static void main(String[] args) {
        Thread t1 = new Thread(() -> new SyncTest().test());
        Thread t2 = new Thread(() -> new SyncTest().test());
        t1.start();
        t2.start();
    }
}
```

![image-20220831135827544](image-20220831135827544.png)