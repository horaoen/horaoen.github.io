+++
title = "JUC"
date = "2024-10-15"
+++

1. [AQS CLH](https://mp.weixin.qq.com/s/jEx-4XhNGOFdCo4Nou5tqg)
```java
public class CLH {
    private final ThreadLocal<Node> node = ThreadLocal.withInitial(Node::new);
    private final AtomicReference<Node> tail = new AtomicReference<>(new Node());
    private static class Node {
        private volatile boolean locked;
    }
    
    public void lock() {
        Node current = node.get();
        current.locked = true;
        Node pre = tail.getAndSet(current);
        while (pre.locked);
    }
    
    public void unlock() {
        Node current = node.get();
        current.locked = false;
        this.node.set(new Node());
    }
}
```