## 关于AQS、独占锁、共享锁、ReadWrite


## 简单介绍

**以下基于JDK1.8**

直接继承自Object，所属于`java.util.concurrent`包下。CountDownLacth可用给定计数初始化，允许一个或多个线程等待，直到在其他线程中执行的一组操作完成的线程同步辅助类。

详细讲解[Java多线程系列--“JUC锁”09之 CountDownLatch原理和示例](http://www.cnblogs.com/skywang12345/p/3533887.html)

## 函数列表

### Constructors

```
# 用给定计数器初始化该线程同步辅助类
CountDownLatch(int count)
```

### Method

* await()

```
# 除非当前线程被中断，使当前线程等待，直到锁中计数器变为0
public void await()
```

* await(long timeout, TimeUnit unit)

```
# 除非当前线程被中断或超时，使当前线程等待，直到锁中计数器变为0
# 计数器变为0立即返回true(returns immediately with the value true.)
public boolean await(long timeout, TimeUnit unit) throws InterruptedException
```

* countDown()

```
# 递减锁计数，计数为0时释放所有等待的线程
public void countDown()
```

* getCount()

```
# 返回当前计数
public int getCount()
```

* toString()

```
# 返回一个标识该锁存器和状态的字符串
public String toString()
```

