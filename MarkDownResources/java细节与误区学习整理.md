---
title: java细节与误区学习整理
date: 2016-12-16 18:38:35
tags: Java
---

# Java几个细节和误区
<!-- more -->
## double 0.1 + double 0.2

```
System.out.println((double)0.1+(double)0.2);
```

输出结果


```
0.30000000000000004
```

追求高精度可以使用bigdecimal

## 死循环

```
for(float f = 10.1f; f != 11; f+=0.1f)
{
    System.out.println(f);
}
```

**导致原因：**
计算机使用二进制来存储数据，而很多小数都不能够准确地使用二进制来表示（事实上，大多数的小数都是近似的），就像使用十进制小数不能准确地表示1/3这样的分数一样。大多数的浮点型，在计算机中只是近似地存储其值，而不像整型那样准确地存储。

## i+++j问题

```
int i = 3,j = 2;
System.out.println(++i+j);
System.out.println(i+++j);
```

**java中i+++j的计算:**
java中依据贪心规则，前置++优于后置++，计算结果为(i++)+j

j=i++的底层实现:

  ```
  temp = i; i = i + 1； j = temp;
  ```

## 除以0


```
System.out.println(100/0);
```

输出结果

```
Exception in thread "main" java.lang.ArithmeticException: / by zero
```

```
System.out.println(100.0/0);
```

输出结果

```
Infinity
```

```
System.out.println(-100/0.0);
```

输出结果

```
-Infinity
```

```
System.out.println(0/0.0);
```

输出结果

```
NaN
```

**原因:**
浮点数有三个特殊值：
①正无穷大Infinity,任何一个正浮点数/0得到,所有正无穷大相等

```
System.out.println(100.0/0 == 99.0/0);
```

为

```
true
```

②负无穷大-Infinity,任何一个负浮点数/0得到,所有负无穷大相等;

③非数NaN,通过0.0/0得到,非数和包括自己的所有非数都不相等

```
System.out.println(0.0/0 == 0.0/0);
```

为

```
false
```

## 奇偶判断

```
i % 2 == 1
```

与

```
i % 2 != 0
```

的取舍
或者使用

```
(i & 1) != 0
```

由于`i % 2 == 1`不能有效判断负数的奇偶性，因此推荐`i % 2 != 0`和`(i & 1) != 0`的奇偶判断方式。