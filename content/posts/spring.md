+++
title = "spring"
date = "2024-10-15"
+++

# Bean 缓存

```java
@Nullable
protected Object getSingleton(String beanName, boolean allowEarlyReference) {
    // 查询一级缓存
    Object singletonObject = this.singletonObjects.get(beanName);
    // 如果一级缓存不存在且当前 bean 正在创建
    if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
        // 查询二级缓存
        singletonObject = this.earlySingletonObjects.get(beanName);
        // 如果二级缓存不存在且允许提前引用
        if (singletonObject == null && allowEarlyReference) {
            synchronized (this.singletonObjects) {
                // Consistent creation of early reference within full singleton lock
               // 一级缓存重新获取 
                singletonObject = this.singletonObjects.get(beanName);
                if (singletonObject == null) {
                    // 二级缓存重新获取
                    singletonObject = this.earlySingletonObjects.get(beanName);
                    if (singletonObject == null) {
                        // 三级缓存获取
                        ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);
                        if (singletonFactory != null) {
                            singletonObject = singletonFactory.getObject();
                            this.earlySingletonObjects.put(beanName, singletonObject);
                            this.singletonFactories.remove(beanName);
                        }
                    }
                }
            }
        }
    }
    return singletonObject;
}
```

### Spring事务实效原因

1. private、static、final
2. 同一个类中方法调用
3. 对象没有代理，不是一个Bean
4. myisam
5. 多线程，@Trancation 基于Treadlocal存储事务上下文

### 动态代理

1. jdk动态代理，必须实现一个或多个接口
2. cglib动态代理

### 过滤器和拦截器的区别

1. 过滤器和拦截器作用和生效位置不同
2. 在Tomcat中，一次请求会先进入到Tomcat容器，然后经过Filter的处理，处理通过之后才会进入到Servlet容器，进入到Servlet容器之后，才会在Servlet执行的前后执行Intercepter。
