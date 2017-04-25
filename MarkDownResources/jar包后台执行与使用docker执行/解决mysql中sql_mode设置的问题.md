# 解决mysql中sql_mode设置的问题

原因：由于sql_mode中设置了`ONLY_FULL_GROUP_BY`属性，导致使用类似如下sql时报错：

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

## 解决方法

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

