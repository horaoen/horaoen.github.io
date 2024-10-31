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