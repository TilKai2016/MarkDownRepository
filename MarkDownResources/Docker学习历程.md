# Docker学习历程

## Mac下搭建Docker环境

参考[ 在OS X安装Docker](http://blog.csdn.net/jpiverson/article/details/50685817)

[docker官网](https://www.docker.com/products/docker-toolbox)下载文件，默认选项安装后，启动`Docker Quickstart Terminal`

成功的执行结果：

```
Creating CA: /Users/tilkai/.docker/machine/certs/ca.pem
Creating client certificate: /Users/tilkai/.docker/machine/certs/cert.pem
Running pre-create checks...
(default) Default Boot2Docker ISO is out-of-date, downloading the latest release...
(default) Latest release for github.com/boot2docker/boot2docker is v1.12.6
(default) Downloading /Users/tilkai/.docker/machine/cache/boot2docker.iso from https://github.com/boot2docker/boot2docker/releases/download/v1.12.6/boot2docker.iso...
(default) 0%....10%....20%....30%....40%....50%....60%....70%....80%....90%....100%
Creating machine...
(default) Copying /Users/tilkai/.docker/machine/cache/boot2docker.iso to /Users/tilkai/.docker/machine/machines/default/boot2docker.iso...
(default) Creating VirtualBox VM...
(default) Creating SSH key...
(default) Starting the VM...
(default) Check network to re-create if needed...
(default) Found a new host-only adapter: "vboxnet1"
(default) Waiting for an IP...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with boot2docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: /usr/local/bin/docker-machine env default
                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o           __/
             \    \         __/
              \____\_______/


docker is configured to use the default machine with IP 192.168.99.100
For help getting started, check out the docs at https://docs.docker.com
```

运行`docker run hello-world`查看是否一切运行良好，正常的返回结果：

```
➜  ~ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world

c04b14da8d14: Pull complete 
Digest: sha256:0256e8a36e2070f7bf2d0b0763dbabdd67798512411de4cdcf9431a1feb60fd9
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker Hub account:
 https://hub.docker.com

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/
```

## 关于镜像和容器

### 解释下`docker run hello-world`

1⃣️ (docker)告诉Docker运行docker program；
2⃣️ (run)Docker子命令创建，并运行docker容器；
3⃣️ (hello-world)告诉Docker容器中加载hell-world镜像；

### 通过对`whalesay`镜像的一系列操作进行具体的学习实践

[DockerHub官网](https://hub.docker.com)搜索`whalesay`，进入`docker/whalesay`详情页。

How to use this image中描述执行下面命令来运行：

```
docker run docker/whalesay cowsay boo
```

其中，`cowsay`为要运行的命令，`boo`为参数(像如果把参数改为`hello world!`，鲸鱼说话会变成`hello world!`具体看下面的执行结果)。

Docker 会先在本地查找有没有镜像，如果没有就从仓库中下载。

运行结果：

```
➜  ~ docker run docker/whalesay cowsay boo
Unable to find image 'docker/whalesay:latest' locally
latest: Pulling from docker/whalesay

e190868d63f8: Pull complete 
909cd34c6fd7: Pull complete 
0b9bfabab7c1: Pull complete 
a3ed95caeb02: Pull complete 
00bf65475aba: Pull complete 
c57b6bcc83e3: Pull complete 
8978f6879e2f: Pull complete 
8eed3712d2cf: Pull complete 
Digest: sha256:178598e51a26abbc958b8a2e48825c90bc22e641de3d31e18aaf55f3258ba93b
Status: Downloaded newer image for docker/whalesay:latest
 _____ 
< boo >
 ----- 
    \
     \
      \     
                    ##        .            
              ## ## ##       ==            
           ## ## ## ##      ===            
       /""""""""""""""""___/ ===        
  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~   
       \______ o          __/            
        \    \        __/             
          \____\______/   

```

### 查看本地镜像

运行`docker images`，运行结果：

```
➜  ~ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              c54a2cc56cbb        6 months ago        1.848 kB
docker/whalesay     latest              6b362a9f73eb        19 months ago       247 MB
```

## 构建自己的镜像

下面基于`Docker run docker/whalesay cowsay boo-boo`改进并构建一个新的版本。

构建自己的镜像需要经过以下的一系列操作：

### 创建DockerFile文件

#### 创建镜像环境目录文件

执行：

```
mkdir DockerBuild
```

`DockerBuild`可以自行命名定义，这个目录会相当于你构建镜像时的环境，里面会存放构建的镜像的所有东西。

进入该目录：

```
cd DockerBuild
```

创建Dockerfile文件：

```
touch Dockerfile
```

注意，`Dockerfile`文件无后缀。

这个名称因为刚学习，不确定是不是可以自定义名称，暂且不对文件名做其他操作。

`Dockerfile`中插入：

```
echo FROM docker/whalesay:latest
```

其中，`FROM`关键字告诉Docker你的镜像是根据哪个镜像构建的。

#### 添加fortunes程序到镜像

`Dockerfile`文件中插入：

```
echo RUN apt-get -y update && apt-get install -y fortunes
```

`fortunes`程序是一个让`whalesay`聪明的说出语句的命令，这一行使用了`apt-get`命令安装`fortunes`。

#### 通过 CMD 指定镜像载入之后需要执行的命令

`Dockerfile`中插入：

```
CMD /usr/games/fortune -a | cowsay
```

于是，最终`Dockerfile`的内容为：

```
FROM docker/whalesay:latest

RUN apt-get -y update && apt-get install -y fortunes

CMD /usr/games/fortune -a | cowsay
```

### 根据Dockerfile构建你的镜像

`DockerBuild`目录(你自己创建的镜像环境目录)下执行：

```
docker build -t docker-whale .
```

执行成功后，会创建名为`docker-whale`的镜像，可通过`docker images`命令查看。

完整的执行结果：

```
➜  DockerBuild docker build -t docker-whale .
Sending build context to Docker daemon 2.048 kB
Step 1 : FROM docker/whalesay:latest
 ---> 6b362a9f73eb
Step 2 : RUN apt-get -y update && apt-get install -y fortunes
 ---> Running in 60c69de9cbd1
Ign http://archive.ubuntu.com trusty InRelease
Get:1 http://archive.ubuntu.com trusty-updates InRelease [65.9 kB]
Get:2 http://archive.ubuntu.com trusty-security InRelease [65.9 kB]
Hit http://archive.ubuntu.com trusty Release.gpg
Hit http://archive.ubuntu.com trusty Release
Get:3 http://archive.ubuntu.com trusty-updates/main Sources [480 kB]
Get:4 http://archive.ubuntu.com trusty-updates/restricted Sources [5921 B]
Get:5 http://archive.ubuntu.com trusty-updates/universe Sources [216 kB]
Get:6 http://archive.ubuntu.com trusty-updates/main amd64 Packages [1172 kB]
Get:7 http://archive.ubuntu.com trusty-updates/restricted amd64 Packages [20.4 kB]
Get:8 http://archive.ubuntu.com trusty-updates/universe amd64 Packages [507 kB]
Get:9 http://archive.ubuntu.com trusty-security/main Sources [157 kB]
Get:10 http://archive.ubuntu.com trusty-security/restricted Sources [4621 B]
Get:11 http://archive.ubuntu.com trusty-security/universe Sources [55.9 kB]
Get:12 http://archive.ubuntu.com trusty-security/main amd64 Packages [711 kB]
Get:13 http://archive.ubuntu.com trusty-security/restricted amd64 Packages [17.0 kB]
Get:14 http://archive.ubuntu.com trusty-security/universe amd64 Packages [193 kB]
Hit http://archive.ubuntu.com trusty/main Sources
Hit http://archive.ubuntu.com trusty/restricted Sources
Hit http://archive.ubuntu.com trusty/universe Sources
Hit http://archive.ubuntu.com trusty/main amd64 Packages
Hit http://archive.ubuntu.com trusty/restricted amd64 Packages
Hit http://archive.ubuntu.com trusty/universe amd64 Packages
Fetched 3671 kB in 23s (154 kB/s)
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
The following extra packages will be installed:
  fortune-mod fortunes-min librecode0
Suggested packages:
  x11-utils bsdmainutils
The following NEW packages will be installed:
  fortune-mod fortunes fortunes-min librecode0
0 upgraded, 4 newly installed, 0 to remove and 92 not upgraded.
Need to get 1961 kB of archives.
After this operation, 4817 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu/ trusty/main librecode0 amd64 3.6-21 [771 kB]
Get:2 http://archive.ubuntu.com/ubuntu/ trusty/universe fortune-mod amd64 1:1.99.1-7 [39.5 kB]
Get:3 http://archive.ubuntu.com/ubuntu/ trusty/universe fortunes-min all 1:1.99.1-7 [61.8 kB]
Get:4 http://archive.ubuntu.com/ubuntu/ trusty/universe fortunes all 1:1.99.1-7 [1089 kB]
debconf: unable to initialize frontend: Dialog
debconf: (TERM is not set, so the dialog frontend is not usable.)
debconf: falling back to frontend: Readline
debconf: unable to initialize frontend: Readline
debconf: (This frontend requires a controlling tty.)
debconf: falling back to frontend: Teletype
dpkg-preconfigure: unable to re-open stdin: 
Fetched 1961 kB in 8s (225 kB/s)
Selecting previously unselected package librecode0:amd64.
(Reading database ... 13116 files and directories currently installed.)
Preparing to unpack .../librecode0_3.6-21_amd64.deb ...
Unpacking librecode0:amd64 (3.6-21) ...
Selecting previously unselected package fortune-mod.
Preparing to unpack .../fortune-mod_1%3a1.99.1-7_amd64.deb ...
Unpacking fortune-mod (1:1.99.1-7) ...
Selecting previously unselected package fortunes-min.
Preparing to unpack .../fortunes-min_1%3a1.99.1-7_all.deb ...
Unpacking fortunes-min (1:1.99.1-7) ...
Selecting previously unselected package fortunes.
Preparing to unpack .../fortunes_1%3a1.99.1-7_all.deb ...
Unpacking fortunes (1:1.99.1-7) ...
Setting up librecode0:amd64 (3.6-21) ...
Setting up fortune-mod (1:1.99.1-7) ...
Setting up fortunes-min (1:1.99.1-7) ...
Setting up fortunes (1:1.99.1-7) ...
Processing triggers for libc-bin (2.19-0ubuntu6.6) ...
 ---> fcc65b9434be
Removing intermediate container 60c69de9cbd1
Step 3 : CMD /usr/games/fortune -a | cowsay
 ---> Running in 02ceaeb0a6d3
 ---> 4af7ae2d516b
Removing intermediate container 02ceaeb0a6d3
Successfully built 4af7ae2d516b
```

使用`docker run docker-whale`命令看一下新建的镜像吧！，会输出类似如下的结果：

```
➜  DockerBuild docker run docker-whale
 ______________________________________ 
/ Creditor, n.:                        \
|                                      |
| A man who has a better memory than a |
\ debtor.                              /
 -------------------------------------- 
    \
     \
      \     
                    ##        .            
              ## ## ##       ==            
           ## ## ## ##      ===            
       /""""""""""""""""___/ ===        
  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~   
       \______ o          __/            
        \    \        __/             
          \____\______/   
```

### 构建过程剖析

`docker build -t docker-whale .`命令会使用当前目录下的`Dockerfile`文件构建一个名为`docker-whale`的镜像。

构建过程首先会检查需要构建的内容(Sending build context to Docker daemon 2.048 kB)，之后会根据Dockerfile文件中的命令分步执行操作。所以出现了上面的输出结果。

## Docker Hub使用

关于DockerHub中进行`pull``push``Tag`等操作后续补充！

待补充和实践的内容还包括Docker中搭建MariaDB和Python环境的操作。


