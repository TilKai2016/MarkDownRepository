---
title: 新MAC软件安装清单
date: 2016-12-25 18:27:00
tags: [MAC]
---

<1>. 安装homebrew:

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

<!-- more -->
<2>. 安装wegt:

```
brew install wget
```

<3>. 安装alfred+有道插件
<4>. 安装MWeb
<5>. 安装idea(内部破解idea.xxxxx.cn)
<6>. 安装cheatsheet
<7>. 安装搜狗输入法(官网下载)
<8>. 配置Git(此处适配公司内部GitLab)

①.配置用户名、邮箱
>

```
> <!--配置用户名，可用git config -l查看配置结果-->
> git config --global user.name "chxlxxxhxx"
> <!--配置邮箱-->
> git config --global user.email "chxlxxxhxx@thsxlxr.com"
```

②.配置ssh key
>运行`cd ~/.ssh`查看是否已有SSH密钥，如果没有，则无此目录；如果有，则备份该目录后删除之；
>生产SSH Key
>运行`ssh-keygen -t rsa -C "chxlxxxhxx@thsxlxr.com"`，连按三次回车，密码为空；
>执行结果:

```
Your identification has been saved in /Users/tilkai/.ssh/id_rsa.
Your public key has been saved in /Users/tilkai/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:lwEIRS/9FhGixvJ3tshyQNllQ+FkNP4aiAwomNFRpyA chilonghai@thsolar.com
The key's randomart image is:
+---[RSA 2048]----+
|E.o........o     |
|.+.o .......     |
|+ . ....+ =      |
| .   ...   ....  |
|      = ...   .. |
|       + ....    |
|      ......     |
|    ......       |
|                 |
+----[SHA256]-----+
```

>此时，在`~/.ssh/`目录下生成了`id_rsa`和`id_rsa.pub`两个文件，执行`cat id_rsa.pub`，拷贝其中的全部内容，添加到Git上。

<9>. 执行`wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh`安装oh-my-zsh;
新建terminal窗口，查看是否已切换到zsh，如果没有切换，尝试执行`chsh -s /usr/local/bin/zsh`
<10>. 定制zsh配置
参考[oh-my-zsh配置你的zsh提高shell逼格终极选择](http://yijiebuyi.com/blog/b9b5e1ebb719f22475c38c4819ab8151.html)，因现有的zsh配置足够，后期配置时再整理。
<11>. 安装Noizio
<12>. 安装chrome浏览器
<13>. 安装1password
<14>. 安装office套装
<15>. 安装postman
<16>. 安装Dash
<17>. 安装Resilio-Sync
<18>. 数据库可视化工具(navicat-premium)
<19>. 安装MariaDB服务
<20>. 安装Snagit
<21>. 安装teamviewer
<22>. 安装文本编辑器
<23>. 配置VIM



