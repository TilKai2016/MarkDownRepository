---
title: Spring Data JPA事务与性能优化(1)
date: 2016-12-31 01:28:29
tags: [SpringDataJPA, JPA, Spring]
---

## Spring Data JPA事务与性能优化

### Spring Data JPA事务

#### 事务基础内容

#### 事务的基本概念(ACID)

&nbsp;&nbsp;&nbsp;&nbsp;**原子性**(Atomicity)：不可分割的执行单元，都做或都不做；

&nbsp;&nbsp;&nbsp;&nbsp;**隔离性**(Isolation)：事务的执行不应该被其他事务干扰；

&nbsp;&nbsp;&nbsp;&nbsp;**一致性**(Consistency)：事务要使数据库从一个一致性的状态变到另一个一致性的状态；

&nbsp;&nbsp;&nbsp;&nbsp;**持久性**(Durability)：事务提交对数据库中数据的改变是永久性的；

&nbsp;&nbsp;&nbsp;&nbsp;在Spring Data JPA中事务有两种，一种是**JTA**事务(分布式事务)，一种是**RESOURCE_LOCAL**事务(本地事务)；

#### 数据库事务并发带来的问题

&nbsp;&nbsp;&nbsp;&nbsp;**脏读**：数据库读取了其他并发事务还没有提交的数据；

&nbsp;&nbsp;&nbsp;&nbsp;**不可重复读**：同一事务先后两次及以上的相同查询，每次的查询结果不一样；

&nbsp;&nbsp;&nbsp;&nbsp;**幻读**：与**不可重复读**类似，区别在于**不可重复读**着重记录的值，**幻读**着重于记录的个数；

#### 事务的传播特性

&nbsp;&nbsp;&nbsp;&nbsp;事务的传播特性对应于方法之间调用时事务的处理策略。

以下是事务传播特性的几个定义：

```
/**
 * 方法必须在事务中运行，如果当前事务不存在，抛出异常
 * Support a current transaction, throw an exception if none exists.
 * Analogous to EJB transaction attribute of the same name.
 */
@Transactional(propagation = Propagation.MANDATORY)
```

```
/**
 * 该属性应该是应用于被调用者，如果当前存在事务，该方法将会在嵌套事务中运行，嵌套事务可以独立提交或回滚；
 * 嵌套事务的提交或回滚不会影响外层事务
 * Execute within a nested transaction if a current transaction exists,
 * behave like PROPAGATION_REQUIRED else. There is no analogous feature in EJB.
 * <p>Note: Actual creation of a nested transaction will only work on specific
 * transaction managers. Out of the box, this only applies to the JDBC
 * DataSourceTransactionManager when working on a JDBC 3.0 driver.
 * Some JTA providers might support nested transactions as well.
 * @see org.springframework.jdbc.datasource.DataSourceTransactionManager
 */
@Transactional(propagation = Propagation.NESTED)
```

```
/**
 * 注解该方法不能运行在事务中，如果运行在事务中，将抛出异常
 * Execute non-transactionally, throw an exception if a transaction exists.
 * Analogous to EJB transaction attribute of the same name.
 */
 @Transactional(propagation = Propagation.NEVER)
```

```
/**
 * 如果当前事务存在，就加入到当前事务中，负责新建一个事务
 * Support a current transaction, create a new one if none exists.
 * Analogous to EJB transaction attribute of the same name.
 * <p>This is the default setting of a transaction annotation.
 */
@Transactional(propagation = Propagation.REQUIRED)
```

```
/**
 * 该方法不需要事务支持，如果当前存在事务，就在当前事务中运行
 * Support a current transaction, execute non-transactionally if none exists.
 * Analogous to EJB transaction attribute of the same name.
 * <p>Note: For transaction managers with transaction synchronization,
 * PROPAGATION_SUPPORTS is slightly different from no transaction at all,
 * as it defines a transaction scope that synchronization will apply for.
 * As a consequence, the same resources (JDBC Connection, Hibernate Session, etc)
 * will be shared for the entire specified scope. Note that this depends on
 * the actual synchronization configuration of the transaction manager.
 * @see org.springframework.transaction.support.AbstractPlatformTransactionManager#setTransactionSynchronization
 */
@Transactional(propagation = Propagation.SUPPORTS)
```

#### 事务的隔离级别

&nbsp;&nbsp;&nbsp;&nbsp;设置事务的隔离级别，目的是解决事务并发可能导致的问题。

```
/**
 * 使用基础数据存储的默认隔离级别
 * Use the default isolation level of the underlying datastore.
 * All other levels correspond to the JDBC isolation levels.
 * @see java.sql.Connection
 */
 @Transactional(isolation = Isolation.DEFAULT)
```

```
/**
 * 允许读取并发事务尚未提交的事务(可能导致脏读、不可重复读、幻读)
 * A constant indicating that dirty reads, non-repeatable reads and phantom reads
 * can occur. This level allows a row changed by one transaction to be read by
 * another transaction before any changes in that row have been committed
 * (a "dirty read"). If any of the changes are rolled back, the second
 * transaction will have retrieved an invalid row.
 * @see java.sql.Connection#TRANSACTION_READ_UNCOMMITTED
 */
@Transactional(isolation = Isolation.READ_UNCOMMITTED)
```

```
/**
 * 允许读取并发事务已经提交的事务
 * A constant indicating that dirty reads are prevented; non-repeatable reads
 * and phantom reads can occur. This level only prohibits a transaction
 * from reading a row with uncommitted changes in it.
 * @see java.sql.Connection#TRANSACTION_READ_COMMITTED
 */
@Transactional(isolation = Isolation.READ_COMMITTED)
```

```
/**
 * 可重复读，对统一字段的多次读取结果是一致的
 * 用于防止脏读、幻读的产生
 * A constant indicating that dirty reads and non-repeatable reads are
 * prevented; phantom reads can occur. This level prohibits a transaction
 * from reading a row with uncommitted changes in it, and it also prohibits
 * the situation where one transaction reads a row, a second transaction
 * alters the row, and the first transaction rereads the row, getting
 * different values the second time (a "non-repeatable read").
 * @see java.sql.Connection#TRANSACTION_REPEATABLE_READ
 */
@Transactional(isolation = Isolation.REPEATABLE_READ)
```

```
/**
 * 完全服从ACID的事务隔离级别(最高隔离级别，并发的事务串行执行)
 * A constant indicating that dirty reads, non-repeatable reads and phantom
 * reads are prevented. This level includes the prohibitions in
 * {@code ISOLATION_REPEATABLE_READ} and further prohibits the situation
 * where one transaction reads all rows that satisfy a {@code WHERE}
 * condition, a second transaction inserts a row that satisfies that
 * {@code WHERE} condition, and the first transaction rereads for the
 * same condition, retrieving the additional "phantom" row in the second read.
 * @see java.sql.Connection#TRANSACTION_SERIALIZABLE
 */
@Transactional(isolation = Isolation.SERIALIZABLE)
```

## 以下还有待整理

### Spring Data JPA事务配置

### Spring Data JPA缓存

### Spring Data JPA批处理

### Spring Data JPA实体

