+++
title = "mysql"
date = "2024-10-12"
+++

## 索引
### 索引未命中的情况
1. 字段字符集编码不一致

## MVVC
Multiversion Concurrency Control
读-读并发一般没有问题、写-写并发加锁、读-写并发通过MVCC解决

### 快照读
快照读是MVCC实现的基础、当前读是悲观锁实现的基础

### 乐观锁/悲观锁
1. 乐观锁，数据提交时检测，主要通过CAS实现
2. 悲观锁，基于数据库锁机制（查询时添加互斥锁）

### 读写锁
1. 读锁（共享锁）允许T读取一行，阻止其它事务获取该行排它锁。事务T
2. 写锁（排它锁、互斥锁）允许T读取和修改、阻止其它事务获取读写锁

### MySQL DDL、DML、DQL、DCL
1. DDL: Data Definition Language, 数据定义语言
2. DML: Data Manipulation Language, 数据操纵语言
3. DQL: Data Query Language, 数据查询语言
4. DCL: Data Control Language, 数据控制语言, 主要是用来设置/更改数据库用户权限

### ACID
1. 原子性（Atomicity）
2. 一致性（Consistency）
3. 隔离性（Isolation）
4. 持久性（Durability）

### 隔离级别

| 事务隔离级别                 | 脏读 | 不可重复读 | 幻读 |
| ---------------------------- | ---- | ---------- | ---- |
| 读未提交（read-uncommitted） | 是   | 是         | 是   |
| 不可重复读（read-committed） | 否   | 是         | 是   |
| 可重复读（repeatable-read）  | 否   | 否         | 是   |
| 串行化（serializable）       | 否   | 否         | 否   |
