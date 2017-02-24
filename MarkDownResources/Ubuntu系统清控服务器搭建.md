# Ubuntu系统清控服务器搭建

## Ubuntu系统安装

### 附加内容

下载工具的选择问题：

[Ubuntu镜像](https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/16.04.2/)
[BaiduExporter](https://github.com/acgotaku/BaiduExporter)
[aria2](http://ziahamza.github.io/webui-aria2/)

### 镜像源
* **[清华大学开源软件镜像站](https://mirrors.tuna.tsinghua.edu.cn/)**
* **[ubuntu-16.04.2-server-amd64.iso](https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/16.04.2/ubuntu-16.04.2-server-amd64.iso)**
* **[ubuntu-16.04.2-desktop-amd64.iso ](https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/16.04.2/ubuntu-16.04.2-desktop-amd64.iso)**

### 制作启动U盘

使用`UitralIso`或`Rufus`制作`Ubuntu16.04`的USB启动盘(*本次制作是使用UitralIso在Windows下进行的*)。

### Ubuntu系统安装过程

* F9进入`bios`->`system options`->`sata controller options`->`embedded sata configuration`->把`B120i`改成`enable sata ahci support`
* `PCI Device Enable/Disable`->`HP...B120i`的`Embedded`改为`Disabled`
* F10保存后重启，查看是`HP AHCI sata controller` 非`B120i`
* 之后借鉴该[参考](http://www.hpiss.com/4822.html)。
* 配置分区选择LVM的部分原因是LVM内部支持硬盘分区修改(包括多块硬盘之间的分区整合拆分)
* 关于在系统安装过程中出现的选择需要安装软件的选项，只需要在默认的基础上安装`OpenSSH Server`即可。
* GRUB boot loader是启动引导程序，需要安装并指定到系统所在硬盘，详细的介绍参考维基百科等。
* 安装完成重启时拔下启动盘。

**参考：[B系列阵列卡Gen8机型安装uBuntu 12.04](http://www.hpiss.com/4822.html)**

### ROOT用户密码设置

正常的经过上述的步骤安装完成后的系统是没有设置root用户的密码的，如果不确定root用户密码是否已经设定，可以使用su命令尝试，假如没有设置root用户的密码，使用以下步骤设置：

```
sudo passwd
```

之后输入当前用户的密码，终端会提示输入新密码，该密码就是root用户的密码，操作完成后root用户的密码设置成功。

### 修改apt源

---

## WEB服务器环境搭建

### 安装docker

参考[Ubuntu、Debian 系列安装 Docker](https://yeasy.gitbooks.io/docker_practice/content/install/ubuntu.html)

* 使用如下脚本自动安装

官方软件源：

```
curl -sSL https://get.docker.com/ | sh
```

阿里软件源：

```
curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
```

DaoCloud软件源：

```
curl -sSL https://get.daocloud.io/docker | sh
```

* 建立docker用户组

建立docker组：

```
sudo groupadd docker
```

将当前用户加入docker组：

```
sudo usermod -aG docker $USER
```

### 镜像加速器

`Ubuntu 16.04`和`CentOS`都是使用`systemctl`的系统，用 `systemctl enable docker` 启用服务后，编辑 `/etc/systemd/system/multi-user.target.wants/docker.service` 文件，找到 `ExecStart=` 这一行，在这行最后添加加速器地址 `--registry-mirror=<加速器地址>`，如：

```
ExecStart=/usr/bin/dockerd --registry-mirror=https://jxus37ad.mirror.aliyuncs.com
```

重新加载配置，并重新启动：

```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 安装Docker-Compose

* 使用`pip --version`查看pip是否安装，未安装则执行`sudo apt install python-pip`

* 安装Docker-Compose

```
sudo pip install -U docker-compose
```

注意，此处执行可能报如下错误：

```
Traceback (most recent call last):
  File "/usr/bin/pip", line 11, in <module>
    sys.exit(main())
  File "/usr/lib/python2.7/dist-packages/pip/__init__.py", line 215, in main
    locale.setlocale(locale.LC_ALL, '')
  File "/usr/lib/python2.7/locale.py", line 581, in setlocale
    return _setlocale(category, locale)
locale.Error: unsupported locale setting
```

解决方法，执行下面这句话

```
export LC_ALL=C
```

一波三折，中间可能又报pip版本问题，问题描述如下

```
You are using pip version 8.1.1, however version 9.0.1 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
```

* (补充)卸载Docker-Compose

```
sudo pip uninstall docker-compose
```

### 设置Docker-Compose代码补全

root用户下执行该脚本，否则会提示没有权限的错误

```
curl -L https://raw.githubusercontent.com/docker/compose/1.2.0/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
```

### Docker搭建Tomcat WEB环境

### 

原理：使用alpine版本的带openjdk的Tomcat官方镜像为基础镜像，在该镜像基础上设置时区，将war包添加到该tomcat镜像的webapps目录中，执行构建操作，构建成功后启动该tomcat容器即可完成工程的部署。
具体的操作步骤如下：

* 创建Dockerfile文件

```
touch Dockerfile
```

* 编辑该Dockerfile文件

```
FROM tomcat:9-jre8-alpine

RUN apk add --update --no-cache tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && apk del tzdata

ADD ./build/libs/ecopm.war /usr/local/tomcat/webapps/ecopm.war
```

* 将war包上传到Dockerfile中指定的目录，执行构建

```
docker build -t tomcat9-ecopm .
```

* 构建成功后查看是否创建了名为`tomcat9-ecopm`的镜像

```
docker image
```

* 首次启动`tomcat9-ecopm`容器，使用run命令，指定端口映射，指定别名

```
docker run -p 8080:8080 --name tomcat_ecopm tomcat9-ecopm
```

* 以后启动只需执行

```
docker start tomcat_ecopm
```

### Docker-Compose简化以上的操作步骤

* 创建docker-compose.yml文件，配置如下：

```
version: '2'
services:
  tomcat:
    restart: always
    build: ./
    image: tomcat9-ecopm
    container_name: tomcat_ecopm
    ports:
      - "8080:8080"
```

* 给`docker-compose.yml`执行权限：

```
chmod +x docker-compose.yml
```

* 执行构建

```
docker-compose up
```

## 使用Nginx实现多域名解析到同一阿里云服务器IP的需求

