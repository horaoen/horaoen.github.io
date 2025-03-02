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

### ReadView & UndoLog
InnoDB中MVCC可以通过ReadView和UndoLog实现，UndoLog保存了历史快照，ReadView用来判断具体哪个快照可读
当前事务查询一条记录符合ReadView的规则直接返回，不符合查询UndoLog

#### ReadView
在RC下，事务每次select都会获取一个ReadView, 在RR下，一个事务只会在第一次select获取ReadView

### B+
1. 特点：平衡树、关键字在叶子节点顺序排放、非页子节点不存放数据可以存放更多索引数据、叶子节点双向链表
2. 支持范围查询、排序；节点分裂、合并IO操作少、有利于磁盘预读、有利于缓存。

### MySQL执行过程
1. 连接器建立通讯连接
2. 检查是否开启缓存
3. 解析器=》解析树 ， 预处理器检查语法是否合法
4. 优化器生成执行计划，根据索引看看是否可以优化
5. 执行器执行语句


