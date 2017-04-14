# 浅谈Docker

## 认识Docker

### 什么是Docker?

Docker是一个开源平台，包括Docker引擎和DockerHub注册服务器。
>* **Docker容器引擎**：该引擎可以让开发者打包他们的应用和依赖包到一个可移植的容器中，然后将其发布到任何流行的Linux机器上。
>* **Docker Hub注册服务器**：用户可以在该服务器上创建自己的镜像库来存储、管理和分享镜像。利用Docker，可以实现软件的一次配置、处处运行。

一般称Docker为“应用程序执行容器”或“软件工业上的集装箱技术”。

<!-- more -->

### Docker解决了什么问题?

用比较多的专业名词来描述-Docker产生的目的就是为了解决以下问题:
>* **环境管理复杂**: 从各种OS到各种中间件再到各种App，一款产品能够成功发布，作为开发者需要关心的东西太多，且难于管理，这个问题在软件行业中普遍存在并需要直接面对。Docker可以简化部署多种应用实例工作，比如Web应用、后台应用、数据库应用、大数据应用比如Hadoop集群、消息队列等等都可以打包成一个Image部署。
>
>* **云计算时代的到来**: 亚马逊云服务(AWS)的成功, 引导开发者将应用转移到云上, 解决了硬件管理的问题，然而软件配置和管理相关的问题依然存在 (AWS cloudformation是这个方向的业界标准, 样例模板可[参考这里](https://s3-us-west-2.amazonaws.com/cloudformation-templates-us-west-2/LAMP_Single_Instance.template))。Docker的出现正好能帮助软件开发者开阔思路，尝试新的软件管理方法来解决这个问题。
>
>* **虚拟化手段的变化**: 云时代采用标配硬件来降低成本，采用虚拟化手段来满足用户按需分配的资源需求以及保证可用性和隔离性。然而无论是KVM(kernel-based virtual machine)还是Xen(虚拟机监视器)，在 Docker 看来都在浪费资源，因为用户需要的是高效运行环境而非OS, GuestOS既浪费资源又难于管理, 更加轻量级的LXC(Linux Containers)更加灵活和快速。
>
>* **LXC的便携性**: LXC在 Linux 2.6 的 Kernel 里就已经存在了，但是其设计之初并非为云计算考虑的，缺少标准化的描述手段和容器的可便携性，决定其构建出的环境难于分发和标准化管理(相对于KVM之类image和snapshot的概念)。Docker就在这个问题上做出了实质性的创新方法。

通俗来讲-Docker的出现，解决了如下问题：
>* **更高效的利用系统资源**: 由于容器不需要进行硬件虚拟以及运行完整操作系统等额外开销，Docker 对系统资源的利用率更高。无论是应用执行速度、内存损耗或者文件存储速度，都要比传统虚拟机技术更高效。因此，相比虚拟机技术，一个相同配置的主机，往往可以运行更多数量的应用。
>
>* **更快速的启动时间**: 传统的虚拟机技术启动应用服务往往需要数分钟，而 Docker 容器应用，由于直接运行于宿主内核，无需启动完整的操作系统，因此可以做到秒级、甚至毫秒级的启动时间。大大的节约了开发、测试、部署的时间。
>
>* **一致的运行环境**: 开发过程中一个常见的问题是环境一致性问题。由于开发环境、测试环境、生产环境不一致，导致有些 bug 并未在开发过程中被发现。而 Docker 的镜像提供了除内核外完整的运行时环境，确保了应用运行环境一致性，从而不会再出现 “这段代码在我机器上没问题啊” 这类问题。
>
>* **持续交付和部署**: 对开发和运维（[DevOps](https://zh.wikipedia.org/wiki/DevOps)）人员来说，最希望的就是一次创建或配置，可以在任意地方正常运行。
>使用 Docker 可以通过定制应用镜像来实现持续集成、持续交付、部署。开发人员可以通过 [Dockerfile](https://docs.docker.com/engine/reference/builder/) 来进行镜像构建，并结合 持续集成(Continuous Integration) 系统进行集成测试，而运维人员则可以直接在生产环境中快速部署该镜像，甚至结合 持续部署(Continuous Delivery/Deployment) 系统进行自动部署。
>而且使用 Dockerfile 使镜像构建透明化，不仅仅开发团队可以理解应用运行环境，也方便运维团队理解应用运行所需条件，帮助更好的生产环境中部署该镜像。
>
>* **更轻松的迁移**: 由于 Docker 确保了执行环境的一致性，使得应用的迁移更加容易。Docker 可以在很多平台上运行，无论是物理机、虚拟机、公有云、私有云，甚至是笔记本，其运行结果是一致的。因此用户可以很轻易的将在一个平台上运行的应用，迁移到另一个平台上，而不用担心运行环境的变化导致应用无法正常运行的情况。
>
>* **更轻松的维护和扩展**: Docker 使用的分层存储以及镜像的技术，使得应用重复部分的复用更为容易，也使得应用的维护更新更加简单，基于基础镜像进一步扩展镜像也变得非常简单。此外，Docker 团队同各个开源项目团队一起维护了一大批高质量的[官方镜像](https://hub.docker.com/explore/)，既可以直接在生产环境使用，又可以作为基础进一步定制，大大的降低了应用服务的镜像制作成本。
>
>* 对比传统虚拟机总结:

| 特性 | 容器 | 虚拟机 |
| --- | --- | --- |
| 启动 | 秒级 | 分钟级 |
| 硬盘使用 | 一般为MB | 一般为GB |
| 性能 | 接近原生 | 弱于原生 |
| 系统支持量 | 单机支持上千个容器 | 一般几十个 |

### Docker的组成

Docker为C/S架构，由以下几部分组成：
* `Docker Client`：CLI客户端
* `Docker Server`：Docker守护进程，通过`Remote API`实现与`Docker Client`通信。
* `Docker images`：镜像，`docker run`后变为容器
* `Docker Registry`：`Docker images`的中央存储仓库(pull/push)

## Docker环境搭建

### Mac下搭建Docker环境

1. 使用homebrew执行`brew cask install docker`安装(**推荐**)
或访问[docker官网](https://www.docker.com/products/docker-toolbox)下载安装文件，按照默认选项安装。

2. 运行`docker run hello-world`测试`docker`是否能够正常运行，正常的返回结果：

```
➜  ~ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 ...
```

Mac下Docker的安装操作在网上有很多，比如参考[ 在OS X安装Docker](http://blog.csdn.net/jpiverson/article/details/50685817)。

## 关于Docker镜像、容器和仓库的概念

### Docker镜像

>Docker 镜像是一个特殊的文件系统，除了提供容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的一些配置参数（如匿名卷、环境变量、用户等）。镜像不包含任何动态数据，其内容在构建之后也不会被改变。

### Docker容器

>镜像（Image）和容器（Container）的关系，就像是面向对象程序设计中的类和实例一样，镜像是静态的定义，容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等

### Docker仓库

>镜像构建完成后，可以很容易的在当前宿主上运行，但是，如果需要在其它服务器上使用这个镜像，我们就需要一个集中的存储、分发镜像的服务，Docker Registry 就是这样的服务。

>一个 Docker Registry 中可以包含多个仓库（Repository）；每个仓库可以包含多个标签（Tag）；每个标签对应一个镜像。

>一般而言，一个仓库包含的是同一个软件的不同版本的镜像，而标签则用于对应于软件的的不同版本。我们可以通过 <仓库名>:<标签> 的格式来指定具体是哪个版本的镜像。如果不给出标签，将以 latest 作为默认标签。

>以 Ubuntu 镜像 为例，ubuntu 是仓库的名字，其内包含有不同的版本标签，如，14.04, 16.04。我们可以通过 ubuntu:14.04，或者 ubuntu:16.04 来具体指定所需哪个版本的镜像。如果忽略了标签，比如 ubuntu，那将视为 ubuntu:latest。

>仓库名经常以 两段式路径 形式出现，比如 jwilder/nginx-proxy，前者往往意味着 Docker Registry 多用户环境下的用户名，后者则往往是对应的软件名。但这并非绝对，取决于所使用的具体 Docker Registry 的软件或服务。

*以上关于docker镜像、容器和仓库的概念摘自GitBoot中[Docker — 从入门到实践](https://www.gitbook.com/book/yeasy/docker_practice/details)，该链接地址提供PDF下载以及关于docker元素更加详细的定义。*

---

## Docker实践

### 解释<font color='#43BC9F'>`docker run hello-world`</font>命令

* <font color='red'>`docker`</font> : 告诉`Docker`运行`docker program`；
* <font color='red'>`run`</font> : `Docker`子命令，创建并运行`docker`容器；
* <font color='red'>`hello-world`</font> : 告诉`Docker`容器中加载`hell-world`镜像；

### 示例 - Ubuntu14.04

*本示例将启动Ubuntu服务，分别在Mac和Ubuntu服务下执行`uname -a`命令，查看当前机器(虚拟机)的内核、操作系统、CPU信息，比较二者的不同。*

**在Mac环境下**

* <font color='green'>执行：</font>

```
uname -a
```

* <font color='green'>结果：</font>

```
Darwin ***deMBP.lan 16.4.0 Darwin Kernel Version 16.4.0: Thu Dec 22 22:53:21 PST 2016; root:xnu-3789.41.3~3/RELEASE_X86_64 x86_64
```

**拉取ubuntu:14.04后在交互式终端验证结果**

* <font color='green'>拉取ubiuntu:14.04镜像：</font>

```
docker pull ubuntu:14.04
```

* <font color='green'>启动容器，在交互式终端执行`uname -a`命令：</font>

```
docker run -it ubuntu:14.04 uname -a
```

* <font color='green'>输出结果：</font>

```
Linux 353b8a582143 4.9.4-moby #1 SMP Wed Jan 18 17:04:43 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
```

**从输出结果可看出二者所处的环境已经发生了变化。**

解释下<font color='#43BC9F'>`docker run -it ubuntu:14.04 uname -a`</font>命令参数：
><font color='red'>`-it`</font>:里面包含两个参数，<font color='red'>`-i`</font>指交互式操作(interaction)，<font color='red'>`-t`</font>指终端(terminal);
><font color='red'>`ubuntu:14.04`</font>:指用`ubuntu:14.04`为基础启动容器；
><font color='red'>`uname -a`</font>：放在镜像后面的语句是命令；

*参考[获取镜像](https://yeasy.gitbooks.io/docker_practice/content/image/pull.html)*

### 示例 - RabbitMQ

* <font color='green'>查找rabbitMQ镜像：</font>

```
docker search rabbitmq
```

* <font color='green'>下载rabbitMQ镜像(不带web管理插件的镜像)：</font>

```
docker pull rabbitmq
```

* <font color='green'>下载rabbitMQ镜像(带web管理插件的镜像)：</font>

```
docker pull rabbitmq:management
```

* <font color='green'>查看下载的镜像：</font>

```
docker images
```

* <font color='green'>启动rabbitMQ镜像(不带web管理插件)：</font>

```
docker run -d --publish 5671:5671 rabbitmq
```

* <font color='green'>启动rabbitMQ(带web管理插件)：</font>

```
docker run -d --publish 5671:5671 \
 --publish 5672:5672 --publish 4369:4369 --publish 25672:25672 --publish 15671:15671 --publish 15672:15672 \
rabbitmq:management
```

PS：

1. docker run命令中参数的含义:

    
| Name | Default | Description |
| --- | --- | --- |
| -d, --detach | false | Run container in background and print container ID(服务挂在后台，以守护进程的方式运行) |
| -p, --publish |  | Publish a container’s port(s) to the host(端口映射，如123:456，代表容器的456端口映射到服务器的123端口) |

更多的参数可以从dash中查找使用。

2. 关于RabbitMQ的几个内部端口代表的意义：

```
4369:epmd(Erlang Port Mapper Daemon)相当于DNS作用
25672:Erlang distribution
5672, 5671:AMQP 0-9-1 without and with TLS
15672:if management plugin is enabled
61613, 61614:if STOMP is enabled
1883, 8883:if MQTT is enabled
```

### 示例 - MySql

* <font color='green'>下载镜像：</font>

```
docker pull mysql
```

* <font color='green'>查看下载的镜像：</font>

```
docker images
```

* <font color='green'>运行MySql实例：</font>

```
docker run --name first-mysql -p 3306:3306 -e MYSQL\_ROOT\_PASSWORD=123456 -d mysql 
```

(或指定数据库、用户名和密码:)

```
docker run \
  --name=gitlab_mysql \
  -tid \
  -e 'DB_NAME=gitlabhq_production' \
  -e 'DB_USER=gitlab' \
  -e 'DB_PASS=password' \
  -v /Users/tilkai/data/docker/gitlab/mysql:/var/lib/mysql \
  sameersbn/mysql:latest
```

* <font color='green'>此时，使用MySql客户端可以连接到MySql服务。</font>

---

## 使用Docker-Compose定义、运行多个Docker容器

### Docker-Compose是什么

>`Docker-compose`是容器编排工具，其使用`*.yml`文件作为配置文件，根据配置启动、停止、重启一组容器。

参考自[Docker 产品全解析之 docker-compose](http://www.jianshu.com/p/15a809b7b068)

### 如何安装Docker-compose(Mac下无需安装，可直接使用)

> 安装Docker
> 执行`$ curl -L "https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`下载安装`docker-compose`
> 执行`chmod +x /usr/local/bin/docker-compose`
> 测试`docker-compose`是否安装成功`docker-compose --version`

参考自[Install Docker Compose](https://docs.docker.com/compose/install/)

### 通过搭建一个GitLab服务来学习Docker-Compose

参考：
[sameersbn/docker-gitlab](https://github.com/sameersbn/docker-gitlab/blob/master/docker-compose.yml#L8)
[sameersbn/gitlab](https://hub.docker.com/r/sameersbn/gitlab/)

docker-compose.yml配置文件：

```
version: '2'
services:
  redis:
    restart: always
    image: sameersbn/redis:latest
    volumes:
      - /Users/tilkai/data/docker/gitlab/redis:/var/lib/redis:Z
  mysql:
    restart: always
    image: sameersbn/mysql
    ports:
      - "3307:3306"
    environment:
      - DB_NAME==gitlabhq_production
      - DB_USER=gitlab
      - DB_PASS=password
    volumes:
      - /Users/tilkai/data/docker/gitlab/mysql:/var/lib/mysql
  gitlab:
    restart: always
    image: sameersbn/gitlab:8.11.7
    container_name: gitlab
    depends_on:
      - mysql
      - redis
    ports:
      - "8022:8022"
      - "8043:8043"
    environment:
      - DEBUG=false

      - DB_TYPE=mysql
      - DB_ADAPTER=mysql2
      - DB_USER=gitlab
      - DB_PASS=password
      - DB_NAME=gitlabhq_production
      - DB_HOST=mysql

      - REDIS_HOST=redis
      - REDIS_PORT=6379
```

### docker-Compose模版文件

以下参考自：
[Docker Compose 配置文件详解](http://www.jianshu.com/p/2217cfed29d7)。
[Compose 模板文件](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html)

模板文件是使用 Compose 的核心，默认的模板文件名称为 docker-compose.yml，格式为 YAML 格式。

#### 简单介绍部分docker-compose.yml中常见的指令。

##### image

```
services:
  web:
    image: dockercloud/hello-world
    ...
    
  redis:
    image: redis
    ...
```

`services`下的二级标签，如第一个二级标签`web`，第二个二级标签`redis`，这个标签是用户自定义的名字，为服务的名称。
可以理解为`docker run --name(-n)`中的`--name(-n)`属性。

`image`指服务的镜像名称或镜像ID，如果镜像在本地不存在，Compose会尝试拉取这个镜像。
举例几个可行的`image`格式：

```
image: redis
image: mysql:5
image: tutum/influxdb
image: example-registry.com:4000/postgresql
image: a4bc65fd
```

##### build

`docker-compose`除了基于`image`外，还可以基于一份`dockerfile`文件，在使用`up`命令启动时执行构建任务。

* 可以是绝对路径：

```
build: /path/to/build/dir
```

* 可以是相对路径：

```
build: ./dir
```

* 也可以设定上下文根目录，然后以该目录为准指定`dockerfile`：

```
build:
  context: ../
  dockerfile: path/of/Dockerfile
```

**注意**，`build`标签指定的是`dockerfile`文件的所在目录，假如要指定某个`dockerfile`文件需要在`build`下的`dockerfile`标签指定。
如果同时指定了`image`和`build`标签，那么compose会构建镜像，并把镜像命名为`image`标签后的名字。
举个简单的例子，根据下面的`Dockerfile`文件可构建名为`whalesay`，标签为`test`的镜像：

```
#Dockerfile文件的内容
FROM docker/whalesay:latest

RUN apt-get -y update && apt-get install -y fortunes

CMD /usr/games/fortune -a | cowsay
```

```
# docker-compose.yml文件的内容
version: '2'
services:
  whalesay:
    build: ./
    image: whalesay:test
```

##### command

使用 command 可以覆盖容器启动后默认执行的命令。

如：

```
command: echo "hello,world!"
```

##### container_name

如指定容器的名称为`mysql`：

```
container_name: mysql
```

ps:
默认Compose的容器名称格式是：<项目名称><服务名称><序号>

##### depends_on

`depends_on`标签的存在是为了解决容器的依赖问题，像web服务依赖数据库服务这种服务依赖关系是非常常见的，假如直接从上到下的启动容器，很可能导致因容器的依赖问题而启动失败。

于是，**`depends_on`标签解决了容器依赖和启动顺序的问题。**

例如下面容器会先启动 redis 和 db 两个服务，最后才启动 web 服务：

```
version: '2'
services:
  web:
    build: .
    depends_on:
      - db
      - redis
  redis:
    image: redis
  db:
    image: postgres
```

注意的是，默认情况下使用 docker-compose up web 这样的方式启动 web 服务时，也会启动 redis 和 db 两个服务，因为在配置文件中定义了依赖关系。

##### dns

自定义dns服务器，和 --dns 参数一样用途，格式如下：

```
dns: 8.8.8.8
```

也可以是一个列表：

```
dns:
  - 8.8.8.8
  - 9.9.9.9
```

##### tmpfs

挂载临时目录到容器内部，与 run 的参数一样效果：

```
tmpfs: /run
tmpfs:
  - /run
  - /tmp
```

##### env_file

`.env`文件可以设置compose变量，`docker-compose.yml`中可以定义一个专门存放变量的文件。
如果通过 docker-compose -f FILE 指定了配置文件，则 env_file 中路径会使用配置文件路径。

如果有变量名称与 environment 指令冲突，则以后者为准。格式如下：

```
env_file: .env
```

或者根据 docker-compose.yml 设置多个：

```
env_file:
  - ./common.env
  - ./apps/web.env
  - /opt/secrets.env
```

注意的是这里所说的环境变量是对宿主机的 Compose 而言的，如果在配置文件中有 build 操作，这些变量并不会进入构建过程中，如果要在构建中使用变量还是首选前面刚讲的 arg 标签。

##### environment

`environment`用于设置镜像变量，它可以保存变量到镜像里面，也就是说启动的容器也会包含这些变量设置，这是与`arg`最大的不同。

一般`arg`标签的变量仅用在构建过程中。而`environment`和`Dockerfile `中的`ENV`指令一样会把变量一直保存在镜像、容器中，类似`docker run -e`的效果。

```
environment:
  MYSQL_ROOT_PASSWORD: password
```

```
environment:
  - MYSQL_ROOT_PASSWORD=password
```

##### expose

这个标签与Dockerfile中的EXPOSE指令一样，用于指定暴露的端口，但是只是作为一种参考，实际上docker-compose.yml的端口映射还得ports这样的标签。

```
expose:
 - "3000"
 - "8000"
```

##### external_links

在使用Docker过程中，我们会有许多单独使用docker run启动的容器，为了使Compose能够连接这些不在docker-compose.yml中定义的容器，我们需要一个特殊的标签，就是external_links，它可以让Compose项目里面的容器连接到那些项目配置外部的容器（前提是外部容器中必须至少有一个容器是连接到与项目内的服务的同一个网络里面）。
格式如下：

```
external_links:
 - redis_1
 - project_db_1:mysql
 - project_db_1:postgresql
```

##### links

解决容器的链接顺序的问题：

```
links:
 - db
 - db:database
 - redis
```

##### extra_hosts

添加主机名的标签，就是往/etc/hosts文件中添加一些记录，与Docker client的--add-host类似：

```
extra_hosts:
 - "somehost:162.242.195.82"
 - "otherhost:50.31.209.229"
```

##### ports

映射端口的标签。
使用HOST:CONTAINER格式或者只是指定容器的端口，宿主机会随机映射端口:

```
ports:
 - "3000"
 - "8000:8000"
 - "49100:22"
 - "127.0.0.1:8001:8001"
```

##### stop_signal

设置另一个信号来停止容器。在默认情况下使用的是SIGTERM停止容器。设置另一个信号可以使用stop_signal标签。

```
stop_signal: SIGUSR1
```

##### volumes

挂载一个目录或者一个已存在的数据卷容器，可以直接使用 [HOST:CONTAINER] 这样的格式，或者使用 [HOST:CONTAINER:ro] 这样的格式，后者对于容器来说，数据卷是只读的，这样可以有效保护宿主机的文件系统。
Compose的数据卷指定路径可以是相对路径，使用 . 或者 .. 来指定相对目录。
数据卷的格式可以是下面多种形式：

```
volumes:
  // 只是指定一个路径，Docker 会自动在创建一个数据卷（这个路径是容器内部的）。
  - /var/lib/mysql

  // 使用绝对路径挂载数据卷
  - /opt/data:/var/lib/mysql

  // 以 Compose 配置文件为中心的相对路径作为数据卷挂载到容器。
  - ./cache:/tmp/cache

  // 使用用户的相对路径（~/ 表示的目录是 /home/<用户目录>/ 或者 /root/）。
  - ~/configs:/etc/configs/:ro

  // 已经存在的命名的数据卷。
  - datavolume:/var/lib/mysql
```

如果你不使用宿主机的路径，你可以指定一个volume_driver。

```
volume_driver: mydriver
```

##### volumes_from

从其它容器或者服务挂载数据卷，可选的参数是 :ro或者 :rw，前者表示容器只读，后者表示容器对数据卷是可读可写的。默认情况下是可读可写的。

```
volumes_from:
  - service_name
  - service_name:ro
  - container:container_name
  - container:container_name:rw
```

##### extends

这个标签可以扩展另一个服务，扩展内容可以是来自在当前文件，也可以是来自其他文件，相同服务的情况下，后来者会有选择地覆盖原有配置。

```
extends:
  file: common.yml
  service: webapp
```
  
用户可以在任何地方使用这个标签，只要标签内容包含file和service两个值就可以了。file的值可以是相对或者绝对路径，如果不指定file的值，那么Compose会读取当前YML文件的信息。

##### networks

加入指定网络，格式如下：

```
services:
  some-service:
    networks:
     - some-network
     - other-network
```

关于这个标签还有一个特别的子标签aliases，这是一个用来设置服务别名的标签，例如：

```
services:
  some-service:
    networks:
      some-network:
        aliases:
         - alias1
         - alias3
      other-network:
        aliases:
         - alias2
```

相同的服务可以在不同的网络有不同的别名。

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
FROM docker/whalesay:latest
```

其中，`FROM`关键字告诉Docker你的镜像是根据哪个镜像构建的。

#### 添加fortunes程序到镜像

`Dockerfile`文件中插入：

```
RUN apt-get -y update && apt-get install -y fortunes
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

使用`docker run docker-whale`命令看查看新建的镜像，会输出类似如下的结果：

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

`docker build -t docker-whale .`命令会使用当前目录下的`Dockerfile`文件构建一个名为`docker-whale`的镜像(`build`表示构建，`-t`表示给构建的镜像起名字)。

`docker build -t`命令涉及到`docker image`的命名规则：
>* 完整命名：registry_url/namespace/image_name:image_version
>* 

构建过程首先会检查需要构建的内容(Sending build context to Docker daemon 2.048 kB)，之后会根据Dockerfile文件中的命令分步执行操作。所以出现了上面的输出结果。

### 简单介绍Dockerfile文件

`Dockerfile`文件中包含了许多shell脚本，通过下面这个用于构建CentOS镜像的Dockerfile文件来了解部分常见构建语法：

```
#
# MAINTAINER        Carson,C.J.Zeong <zcy@nicescale.com>
# DOCKER-VERSION    1.6.2
#
# Dockerizing CentOS7: Dockerfile for building CentOS images
#
FROM       centos:centos7.1.1503
MAINTAINER Carson,C.J.Zeong <zcy@nicescale.com>

ENV TZ "Asia/Shanghai"
ENV TERM xterm

ADD aliyun-mirror.repo /etc/yum.repos.d/CentOS-Base.repo
ADD aliyun-epel.repo /etc/yum.repos.d/epel.repo

RUN yum install -y curl wget tar bzip2 unzip vim-enhanced passwd sudo yum-utils hostname net-tools rsync man && \
    yum install -y gcc gcc-c++ git make automake cmake patch logrotate python-devel libpng-devel libjpeg-devel && \
    yum install -y --enablerepo=epel pwgen python-pip && \
    yum clean all

RUN pip install supervisor
ADD supervisord.conf /etc/supervisord.conf

RUN mkdir -p /etc/supervisor.conf.d && \
    mkdir -p /var/log/supervisor

EXPOSE 22

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
```

* `FROM`：指定父镜像；
* `MAINTAINER`：指定维护者信息；
* `ENV`：全名`environment`，指定环境，如`ENV TZ "Asia/Shanghai"`使用Linux下的TZ环境变量指定了时区为上海；
* `ADD`：Dockerfile提供了两个指令用于文件拷贝，`ADD`、`COPY`，作用都是复制文件到Container中(关于`ADD`和`COPY`命令的区别，自行Google)；
* `RUN`：跟shell命令；
* `EXPOSE`：指定Host-Container的端口映射；
* `ENTRYPOINT`：Container每次启动时要执行的命令；

## Docker Hub使用

### 本地配置docker登录

```
docker login hub.docker.com
```

命令执行后将提示您输入用户名，这将成为你的公共存储库的空间名称。如果你的名字可用，docker会提示您输入一个密码和你的邮箱。然后他会自动记录下。你现在可以提交和推送你的镜像到Docker Hub的你的存储库。

注：你的身份验证凭证将被存储在你本地目录的.dockercfg文件中。

关于DockerHub中进行`pull` `push` `Tag`等操作后续补充！

待补充和实践的内容还包括Docker中搭建MariaDB和Python环境的操作。

### 常用Docker命令
#### 查看本地镜像

```
docker images
```

#### 搜索并下载可用的docker镜像

```
docker search 镜像名字
```

```
docker pull 用户名/镜像名
```

#### 启动／停止／删除Docker容器

```
# 启动
docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

```
# 停止
docker stop [OPTIONS] CONTAINER [CONTAINER...]
```

```
# 删除
docker rm [OPTIONS] CONTAINER [CONTAINER...]
```

#### Docker清理命令集合
[Docker 清理命令集锦](http://www.jb51.net/article/56051.htm)

```
# 杀死所有正在运行的容器
docker kill $(docker ps -a -q)
# 删除所有已经停止的容器
docker rm $(docker ps -a -q)
# docker rmi $(docker images -q -f dangling=true)
删除所有未打 dangling 标签的镜像
# 删除所有镜像
docker rmi $(docker images -q)
# 删除某个镜像
docker rmi [REPOSITORY:TAG]
```

#### Docker-compose常用命令

```
# 启动所有容器
docker-compose up
# 后台启动并运行所有容器
docker-compose up -d
# 不重新创建已经停止的容器
docker-compose up --no-recreate -d
# 只启动test2这个容器
docker-compose up -d test2
# 停止容器
docker-compose stop
# 启动容器
docker-compose start
# 重启容器
docker-compose restart
# 停止并销毁容器
docker-compose down
# 删除容器
docker-compose rm  // 出现删除确认提示，y: 确认删除，n: 取消删除
```

* up
构建，（重新）创建，启动，链接一个服务相关的容器。
链接的服务都将会启动，除非他们已经运行。
默认情况， docker-compose up 将会整合所有容器的输出，并且退出时，所有容器将会停止。
如果使用 docker-compose up -d ，将会在后台启动并运行所有的容器。
默认情况，如果该服务的容器已经存在， docker-compose up 将会停止并尝试重新创建他们（保持使用 volumes-from挂载的卷），以保证 docker-compose.yml 的修改生效。如果你不想容器被停止并重新创建，可以使用 docker-compose up --no-recreate。如果需要的话，这样将会启动已经停止的容器。

* start
启动一个已经存在的服务容器。

* stop
停止一个已经运行的容器，但不删除它。通过 docker-compose start 可以再次启动这些容器。


几个参考链接：

[利用docker搭建一个mysql + java service + nginx](http://www.jb51.net/article/96042.htm)


