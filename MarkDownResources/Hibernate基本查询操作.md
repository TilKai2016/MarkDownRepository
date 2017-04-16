---
title: Hibernate基本查询操作
date: 2016-12-11 23:49:16
tags: [Hibernate]
---

## 查询实体类全部属性的所有实例对象(查询所有记录)
<!-- more -->
```
try {
    Session session = HibernateUtils.getSession();
    Transaction transaction = session.beginTransaction();
    // User 实体类名称 可以写类的全限定名
    // from User 等同于 SQL中 select * from user;
    String hql = "FROM User";
    Query query = session.createQuery(hql);
    List<User> list = (List<User>)query.list();
    transaction.commit();
} catch (HibernateException e) {
    if (transaction != null) {
        transaction.rollback();
    }
}

```

## 查询实体类全部属性的单个实例对象(查询一条记录)

```
Sring hql = "FROM User";
// 查询唯一的一条记录 (满足条件的第一条)
session.createQuery(hql).setMaxResults(1).uniqueResult();
```

## 查询实体类的部分属性(投影查询)

```
// id name 为 User对象中的id name属性
Query query = session.createQuery("SELECT id, name FROM User");
List<Object[]> list = query.list();
```

注意,这种查询返回的是List<Object[]>.

## 实例化投影查询结果

直接投影查询出来的List<Object[]>可能不好使用,可以在对应实体类中添加初始化这些属性的构造方法,可以把投影查询出来的某几列数据放在某个对象里,这样得到的将是一个一个的对象,而非Object[].

```
// 如需要查询User实体的userName, age属性, 可在User类中添加如下构造方法
public User (String userName, int age) {
    this.userName = userName;
    this.age = age;
}
```

查询语句修改为:

```
// 解析HQL语句: 将查询出的userName, age放入User对象中
String hql = "SELECT new User(a.userName, a.age) FROM User a";
Query query = session.creatQuery(hql);
List<User> list = (List<User>)query.list();

```

## 指定待查询实体类的别名

```
// 使用关键字AS指定实体类的别名,也可以直接加别名(如: FROM User a)
String hql = "SELECT a.userName, a.age FROM User AS a";
```

查询User实体所有属性所有记录也可以使用如下写法:

```
String hql = "SELECT u FROM User u";
```

## WHERE条件语句
WHERE条件中可使用的运算符:

<1>. .号(别名.属性)
<2>. 比较运算符(= || > || >= || < || <= || <> || is null || is not null )
<3>. 范围运算符(in || not in || between || not between)
<4>. 模式匹配符(like "字符串")
<5>. 逻辑运算符(and(与) || or(或) || not(非))
<6>. 集合运算符(is empty || is not empty)

案例:

```
// 注意临界值 此处为包括1但不包括10 具体临界值建议自行执行HQL尝试整理归纳(我也不确定)
String hql = "FROM User a WHERE a.id not between (1 and 10)";
```

## HQL函数库

常见:
<1>. 字符串相关
<2>. 数字相关
<3>. 集合相关
<4>. 时间、日期

### 字符串相关
>upper(s) : 转化成大写
>lower(s) : 转化成小写
>concat(s1, s2) : 连接
>substring(s, offset, length) : 截取字符串
>length(s)
>trim([[both|leading|trailing] char [from]] s)
>locate(search, s, offset)

### 数字相关
>abs(n) : 绝对值
>sart(n) : 取余
>mod(dividend, divisor)

### 集合相关
>size(c) : 返回集合中元素个数

### 时间、日期
>current_date() : 返回当前系统日期
>current_time() : 返回当前系统时间
>current_timestamp() : 返回当前系统时间戳
>year(d) || month(d) || day(d) || hour(d) || minute(d) || second(d) : 获取参数d的指定数值(d的年||月||日||时||分||秒)

### 案例

```
// 投影查询User实体中userName、age属性的所有记录,并对查询出的userName做大写转化, 对查询出的age属性做取绝对值操作
String hql = "SELECT new User(upper(u.userName), abs(u.age)) FROM User u)";
```

## WHERE子句参数绑定
由于WHERE子句中经常需要动态设置查询参数, Hibernate提供了了两种参数绑定方式.

### 按照参数名称绑定

```
// 可能注意的地方 =:id之间可不可以加空格, 加在哪边不会出问题(请自行测试)
String hql = "FROM User u WHERE u.id =:id AND u.userName =:userName";
Session session = HibernateUtils.getSession();
Query query = session.createQuery(hql);
query.setInteger("id", 3);
query.setString("userName", "tilkai");
List<User> list = List<User>query.list();
```

### 按照参数位置绑定(按照?占位符下标绑定)

```
String hql = "FROM User u WHERE u.id = ? or a.userName = ?";
Session session = HibernateUtils.getSession();
Query query = session.creatQuery(hql);
// 0为占位符的下标
query.setInteger(0, 3);
// 1为占位符的下标
query.setString(1, "tilkai");
List<User> list = List<User>query.list();
```

## 去重(DISTINCT关键字)

```
// Hibernate中DISTINCT关键字只能去掉数据库中所有记录信息都相同的记录(如存在两个完全相同的user为tilkai的记录则可以去重,如果两个tilkai年龄不同,则不能去重)
String hql = "SELECT DISTINCT u.userName FROM User u";
```

## 排序(ORDER BY关键字)

```
// 默认升序
String hql = "FROM User ORDER BY id DESC";
```

## 聚合函数
查询结果作为long返回.
有5个聚合函数.
<1>. CONUT()
统计符合条件的记录条数
<2>. SVG()
求平均值
<3>. SUM()
求和
<4>. MAX()
求最大值
<5>. MIN()
求最小值

### 案例

```
String hql = "SELECT MAX(u.id) FROM User u";
```

## GROUP BY
分组查询,经常与聚合函数组合使用

```
String hql = "SELECT COUNT(u.id), u.age FROM User u GROUP BY u.age";
```

## HAVING
搭配GROUP BY关键字使用, 对分组后的记录进行筛选

```
// 按年龄分组, 将每组平均年龄>20的组查询出来
String hql = "SELECT u.age FROM User u GROUP BY u.age HAVING AVG(u.age) > 10";
```

## 分页查询
Query接口提供了两个用于分页展示查询结果的方法:
<1>. setFirstResult(int firstResult) : 设置开始查询的开始记录的位置;
<2>. setMaxResult(int maxResults) : 每页显示的最大记录的条数;

```
Query query = session.createQuery("FROM User");
List list = query.setFirstResult(9)
    .setMaxResult(10)
    .list();
```

## 批量更新删除
Hibernate3之后, HQL新增update和delete语句

```
// 在DELETE操作时,DELETE FROM User也可以(FROM关键字不是必须的)
String delHql = "DELETE User WHERE userName LIKE :userName";

Query delQuery = session.createQuery(delHql);
delQuery.setString("userName", "til");
// i > 0, delete success; i <=0 delete field;
int i = delQuery.executeUpdate();
```

```
String uptHql = "UPDATE User SET userName = 'tilkai' WHERE id=:id"
```

## 命名查询
命名查询 : 将HQL查询语句编写在关系映射文件中, 在程序中通过session的getNameQuery()方法获取该查询语句.

### 命名查询的配置

```
<!-- Account.hbm.xml -->
<!-- CDATA告诉XML解析器, 不要对其中内容进行解析 -->
<query name = "accountHql">
    <![CDATA[FROM Account]]>
</query>
```

命名查询语句可以为HQL或SQL语句,程序代码也不区分命名查询语句的类型, 一律通过Session的getNameQuery()方法来获得查询语句.
具体应用:

```
// 参数为query标签的name属性
Query query = session.getNameQuery("accountHql");
```


