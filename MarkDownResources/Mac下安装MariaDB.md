---
title: Mac下安装MariaDB
date: 2016-12-14 20:29:35
tags: [MariaDB]
---

## Mac下安装MariaDB
<!-- more -->
> 使用brew进行安装，安装brew后，检查brew是否安装成功;
> 执行`brew search mariadb`查找brew库中是否存在mariaDB;
> 执行`brew install mariadb`进行mariadb的安装操作;

## 查看MariaDB在Mac中的位置
> 执行`find /usr/ -iname "mysql"`
>
 ```
/usr//local/bin/mysql
/usr//local/Cellar/mariadb/10.1.19/bin/mysql
/usr//local/Cellar/mariadb/10.1.19/include/mysql
/usr//local/Cellar/mariadb/10.1.19/share/mysql
/usr//local/etc/init.d/mysql
/usr//local/etc/logrotate.d/mysql
/usr//local/include/mysql
/usr//local/share/mysql
/usr//local/var/mysql
/usr//local/var/mysql/mysql
find: /usr//sbin/authserver: Permission denied
```

## 启动MariaDB服务
> 执行`launchctl load /usr/local/opt/mariadb/homebrew.mxcl.mariadb.plist`启动MariaDB服务;

## 使用MariaDB
> 执行`mysql -uroot -p`进入数据库(默认安装完成后, 用户名为root, 密码为空);
> 此后可执行如`show databases;`等数据库操作;

## 停止MariaDB服务
> 执行`launchctl unload /usr/local/opt/mariadb/homebrew.mxcl.mariadb.plist`关闭MariaDB服务;
