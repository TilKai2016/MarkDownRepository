## 时间命令

```
# 查看当前时间
date
# 查看当前时间和时区
date -R
```

## 查看当前用户

```
who
```

## 查看线程

```
# 查看所有ssh连接
ps -aux | grep ssh
# 查看某个线程连接
ps -ef | grep collect
```

## 端口转发

```
ssh jieneng@113.208.115.190 -p 9022 -R 0.0.0.0:9999:localhost:9999
```

## mysql命令

```
# 登录mysql
mysql -uroot -p
# 查看数据库列表
show databases;
# 进入XXX数据库
use XXX;
# 查看数据表列表
show tables;
# 创建数据库
create database XXX;
# 导出整个数据库的表到sql文件
mysqldump -uroot -p XXX > XXX.sql
```

## 压缩解压命令

### tar 和 tar.gz

-c: 建立压缩档案
-x：解压
-t：查看内容
-r：向压缩归档文件末尾追加文件
-u：更新原压缩包中的文件

这五个是独立的命令，压缩解压都要用到其中一个，可以和别的命令连用但只能用其中一个。下面的参数是根据需要在压缩或解压档案时可选的。

-z：有gzip属性的
-j：有bz2属性的
-Z：有compress属性的
-v：显示所有过程
-O：将文件解开到标准输出

下面的参数-f是必须的

-f: 使用档案名字，切记，这个参数是最后一个参数，后面只能接档案名。

```
# 将所有sql文件打包到sql.tar包中去，-c表示产生新的包，-f指定包的文件名
tar -cf sql.tar *.sql
# 该命令将所有的.sql文件增加到sql.tar包中去。-r表示增加文件
tar -rf sql.tar *.sql
# 更新sql.tar包中的db_0101_sxqb.sql文件，-u表示更新
tar -uf sql.tar db_0101_sxqb.sql
# 列出sql.tar包中的所有文件 -t表示列出文件
tar -tf sql.tar
# 解出sql.tar包中所有文件，-t表示解开
tar -xf sql.tar
```
## 端口测试

```
# 测试端口 如：telnet 10.9.0.2 3306
telnet ip host
```

## -r -f

```
-r 递归操作
-f 强制操作
```

## who && whoami

```
# 显示在线登录用户
who
# 显示当前操作用户
whoami

```

## 显示主机名

```
# 显示主机名
hostname
```


