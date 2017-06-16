# mysql问题及设置等汇总

## 解决mysql中sql_mode设置的问题

### 原因

由于sql_mode中设置了`ONLY_FULL_GROUP_BY`属性，导致使用类似如下sql时报错：

```
SELECT
     SUM(total_power) AS total_power
    ,FROM_UNIXTIME(record_time, '%d') AS time  
FROM
     chiller_state  
WHERE
     record_time  
IN (
     SELECT
        A.record_time
     FROM
        (SELECT
           MAX(record_time) AS record_time
          ,FROM_UNIXTIME(record_time, '%Y-%m-%d') AS time
         FROM
           chiller_state
         WHERE
           1=1
         AND
           record_time >= 1490976000
         and
           object_id in(1)
        GROUP BY
           FROM_UNIXTIME(record_time, '%Y-%m-%d')
         ORDER BY
           record_time) AS A
     )
  GROUP BY
     FROM_UNIXTIME(record_time, '%Y-%m-%d');
```

### 解决方法

#### 解决方法一

执行:

```
SELECT @@GLOBAL.sql_mode;
SELECT @@SESSION.sql_mode;
```

查询sql_mnode的配置信息，结果如下：

```
ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
```

使用如下命令将`ONLY_FULL_GROUP_BY`设置清除：

```
set @@global.sql_mode ='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
set @@session.sql_mode ='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
```

重新设置成功。

**注意：**该方法在重启mysql服务后会失效，只能算暂时性修改。

#### 解决方法二

编辑`/etc/mysql/my.cnf`文件，插入:

```
[mysqld]
#set the SQL mode to strict
#sql-mode="modes..." 
sql-mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
```

之后重启mysql服务，该配置生效。


### 解释sql-mode中几个参数的用途

```
# ONLY_FULL_GROUP_BY参数使对于GROUP BY聚合操作，如果在SELECT中的列，没有走GROUP BY中出现，则该SQL不合法，因为查询的列不在GROUP BY从句中。
ONLY_FULL_GROUP_BY
```

```
# NO_AUTO_VALUE_NO_ZERO参数影响自增长列的插入。默认设置下，插入0或者NULL代表生成下一个自增长值。如果用户希望插入的值为0，而该列又是自增长的，该参数就可以实现。
NO_AUTO_VALUE_NO_ZERO
```

```
# NO_ZERO_DATE设置该值，mysql数据库不允许插入零日期，插入零日期会抛出错误而不是警告
NO_ZERO_DATE
```

```
# STRICT_TRANS_TABLES 在该模式下，如果一个值不能插入到一个事务表中，则中断当前的操作，对非事务表不做限制。
STRICT_TRANS_TABLES
```

```
# ERROR_FOR_DIVISION_BY_ZERO 在INSERT或UPDATE过程中，如果数据被零除，则产生错误而非警告。如 果未给出该模式，那么数据被零除时MySQL返回NULL
ERROR_FOR_DIVISION_BY_ZERO
```

```
# NO_AUTO_CREATE_USER 禁止GRANT创建密码为空的用户
NO_AUTO_CREATE_USER
```

```
# 如果需要的存储引擎被禁用或未编译，那么抛出错误。不设置此值时，用默认的存储引擎替代，并抛出一个异常。
NO_ENGINE_SUBSTITUTION
```

```
# PIPES_AS_CONCAT 将"||"视为字符串的连接操作符而非或运算符，这和Oracle数据库是一样的，也和字符串的拼接函数Concat相类似
PIPES_AS_CONCAT
```

```
# ANSI_QUOTES启用ANSI_QUOTES后，不能用双引号来引用字符串，因为它被解释为识别符。
ANSI_QUOTES
```

//todo: mysql双机热备


