## ls命令

命令格式:

```
ls [选项] [目录名]
```

常用参数
> * -a 列出当前目录包含.开头的隐藏文件的所有文件
> * -A 同-a, 但不包含.和..目录
> * -h 以K, M, G等单位显示文件大小, 如: `ls -alh`

## cd命令

* 跳转到进入此目录之前所在的目录：

```
cd -
```

## pwd

* 当目录为链接时，输出实际路径，而非链接路径

```
pwd -P
```

## mkdir

* 递归创建目录

```
mkdir -p dir1/dir2/dir3
```

* 创建目录权限为777的目录

```
mkdir -m 777 dir1
```

* 创建目录并显示创建信息

```
mkdir -v dir1
```

* 使用一个命令创建项目的目录结构

```
mkdir -vp scf/{lib/,bin/,doc/{info,product},logs/{info,product},service/deploy/{info,product}}
```

## rm命令

### 命令参数

```
# 强制删除，忽略不存在的文件，从不给出提示
-f --force
# 递归执行删除操作
-r --recursive
# 交互式删除
-i --interactive
# 详细显示进行的步骤
-v --verbose
```

# rmdir命令

用于删除文件夹，但不能删除非空目录

```
rmdir dir1
```

* 如果删除某个目录的子目录后使得该目录变成空目录，则一并将该目录删除
rmdir -p dir1/dir2

## mv命令

```
mv sourceFile/Directory targetFile/Directory
```

* 命令参数

```
# 如果需要覆盖文件，则覆盖前先行备份
-b
# force 强制
-f
# 如果目标资源已经存在，提示是否覆盖
-i
```

## 时间命令

```
# 查看当前时间
date
# 查看当前时间和时区
date -R
```

## 查看用户

* 查看当前用户

```
whoami
```

* 查看目前登入系统的用户信息

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

## 查看端口占用

### netstat命令

netstat命令用于展示网络信息，常用参数如下：

> * -a(all) 显示所有选项，默认不现实LISTEN相关，如列出所有端口:`netstat -a`
> * -t(tcp) 仅展示tcp相关选项，如列出所有tcp端口:`netstat -at`
> * -u(udp) 仅展示udp相关选项，如列出所有udp端口:`netstat -au`
> * -n 拒绝显示别名，能显示数字的全部转化为数字
> * -l 仅列出有在Listen的服务状态，如列出所有处于监听状态的端口:`netstat -l`
> * -p 显示建立相关链接的程序名
> * -r 显示路由信息，路由表
> * -e 显示扩展信息，如uid等
> * -s 按各个协议进行统计
> * -c 每隔固定时间，执行该netstat命令，如每隔一秒执行一次该netstat:`netstat -c`

```
netstat -an | grep port
```

### lsof命令

lsof：list open files 用于列出当前系统打开文件的工具。

格式：

```
lsof [参数][文件]
```

常用参数：

> * -a 列出打开文件存在的进程
> * -c<进程名> 列出指定进程所打开的文件
> * -g  列出GID号进程详情
> * -d<文件号> 列出占用该文件号的进程
> * +d<目录>  列出目录下被打开的文件
> * +D<目录>  递归列出目录下被打开的文件
> * -n<目录>  列出使用NFS的文件
> * -i<条件>  列出符合条件的进程。（4、6、协议、:端口、 @ip ）
> * -p<进程号> 列出指定进程号所打开的文件
> * -u  列出UID号进程详情
> * -h 显示帮助信息
> * -v 显示版本信息

```
lsof -i
lsof -i:port
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

## chown

命令格式：

```
chown [选项]... [所有者]:[组]文件...
```

该命令用于改变文件的拥有者和群组。

## Ubuntu16.04防火墙相关

### ufw防火墙

**参考1**:[UFW防火墙简单设置](http://wiki.ubuntu.org.cn/UFW%E9%98%B2%E7%81%AB%E5%A2%99%E7%AE%80%E5%8D%95%E8%AE%BE%E7%BD%AE)

**参考2**:[如何在Ubuntu 16.04上使用UFW设置防火墙](https://www.howtoing.com/how-to-set-up-a-firewall-with-ufw-on-ubuntu-16-04/)

* 安装ufw防火墙

```
 sudo apt-get install ufw
```

* 查看ufw防火墙状态

```
sudo ufw status
sudo ufw status verbose
```

* 防火墙开启80端口

```
# 允许外部访问80端口
sudo ufw allow 80
```

* 按实际规则删除某个防火墙规则

```
# 删除80端口规则(禁止外部访问80端口)
sudo ufw delete allow 80
```

* 按规则编号后删除某个防火墙规则

```
# 按规则编号
sudo ufw status numbered
# 删除编号为2的规则
sudo ufw delete 2
```

* 允许某个IP访问所有本机端口

```
sudo ufw allow from 192.168.1.1
```

* 允许某个IP访问特定端口

```
允许192.168.1.1访问22端口
sudo ufw allow from 192.168.1.1 to any port 22
```

* 允许特定端口范围

```
# 允许6000-6007端口范围开放
sudo ufw allow 6000:6007/tcp
sudo ufw allow 6000:6007/udp
```

* 防火墙重启

```
sudo ufw reload
```

* 启用ufw

```
# 启用
sudo ufw enable
# 默认拒绝访问
sudo ufw defult deny
```

* 关闭ufw

```
sudo ufw disable
```

* 拒绝某个ip的连接

```
# 拒绝来自192.168.1.1的所有连接
sudo ufw deny from 192.168.1.1
```

## docker中apt-get命令

以下安装命令执行前先执行`apt-get`更新:

```
apt-get update
```

* 安装`ping`和`ifconfig`:

```
# 安装ping
apt-get install inetutils-ping
# 安装ifconfig
apt-get install net-tools
# Dockerfile中安装ifconfig
apt-get install -y net-tools
```

* 安装`vim`:

```
apt-get install vim
```

