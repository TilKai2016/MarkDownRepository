# Docker学习总结

## Mac下搭建Docker环境

1. 使用homebrew执行`brew cask install docker`安装，或访问[docker官网](https://www.docker.com/products/docker-toolbox)下载安装文件，按照默认选项安装。

2. 运行`docker run hello-world`测试`docker`是否能够正常运行，正常的返回结果：

```
➜  ~ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 ...
```

如果以上教程在阅读上有问题，详细的安装操作在网上还有好多，比如参考[ 在OS X安装Docker](http://blog.csdn.net/jpiverson/article/details/50685817)。

## 关于Docker镜像、容器和仓库的概念

*以下关于docker镜像、容器和仓库的概念摘自GitBoot中[Docker — 从入门到实践](https://www.gitbook.com/book/yeasy/docker_practice/details)，该链接地址提供PDF下载以及关于docker元素更加详细的定义。*

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

## Docker具体使用及常用命令解释

### 解释`docker run hello-world`命令

1. `docker` : 告诉`Docker`运行`docker program`；
2. `run` : `Docker`子命令，创建并运行`docker`容器；
3. `hello-world` : 告诉`Docker`容器中加载`hell-world`镜像；

### 实例1：运行`whalesay`镜像进行具体的学习实践

1. 通过[DockerHub官网](https://hub.docker.com)搜索`whalesay`，进入`docker/whalesay`详情页(或执行`docker search whalesay`查找`docker/whalesay`镜像)；
2. 执行`docker pull docker/whalesay`拉取`docker/whalesay`镜像到本地；
3. 执行`docker images`查看本地镜像；
4. 执行`docker run docker/whalesay cowsay boo`运行`docker/whalesay`镜像；

Docker命令`docker run docker/whalesay cowsay boo`中，`cowsay`为要运行的命令，`boo`为参数(像如果把参数改为`hello world!`，鲸鱼说话会变成`hello world!`具体看下面的执行结果)。

Docker 会先在本地查找有没有镜像，如果没有就从仓库中下载。

运行结果：

```
➜  ~ docker run docker/whalesay cowsay boo
Unable to find image 'docker/whalesay:latest' locally
latest: Pulling from docker/whalesay

e190868d63f8: Pull complete 
...
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

### 示例2：使用Docker运行RabbitMQ服务

```
# 查找rabbitMQ镜像
docker search rabbitmq
```

```
# 下载rabbitMQ镜像(不带web管理插件的镜像)
docker pull rabbitmq
# 下载rabbitMQ镜像(带web管理插件的镜像)
docker pull rabbitmq:management
```

```
# 查看下载的镜像
docker images
```

```
# 启动rabbitMQ镜像(不带web管理插件)
docker run -d --publish 5671:5671 rabbitmq
# 启动rabbitMQ(带web管理插件)
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

### 示例3：使用Docker运行MySql服务

```
# 下载镜像
docker pull mysql
```

```
# 查看下载的镜像
docker images
```

```
# 运行MySql实例
docker run --name first-mysql -p 3306:3306 -e MYSQL\_ROOT\_PASSWORD=123456 -d mysql 
```

此时，使用MySql客户端可以连接到MySql服务。

## 使用Docker-compose定义、运行多个Docker容器

[利用docker搭建一个mysql + java service + nginx](http://www.jb51.net/article/96042.htm)

>`Docker-compose`是容器编排工具，其使用`*.yml`文件作为配置文件，根据配置启动、停止、重启一组容器。

参考自[Docker 产品全解析之 docker-compose](http://www.jianshu.com/p/15a809b7b068)

### 如何安装Docker-compose

> 安装Docker
> 执行`$ curl -L "https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`下载安装`docker-compose`
> 执行`chmod +x /usr/local/bin/docker-compose`
> 测试`docker-compose`是否安装成功`docker-compose --version`

参考自[Install Docker Compose](https://docs.docker.com/compose/install/)

### docker-compose.yml配置文件

以下参考自[Docker Compose 配置文件详解](http://www.jianshu.com/p/2217cfed29d7)。

> 举个标准的配置文件的例子：

```
version: '2'
services:
  web:
    image: dockercloud/hello-world
    ports:
      - 8080
    networks:
      - front-tier
      - back-tier

  redis:
    image: redis
    links:
      - web
    networks:
      - back-tier

  lb:
    image: dockercloud/haproxy
    ports:
      - 80:80
    links:
      - web
    networks:
      - front-tier
      - back-tier
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock 

networks:
  front-tier:
    driver: bridge
  back-tier:
    driver: bridge
```

> 从上述配置文件可以看到，一个标准的`docker-compose.yml`配置文件中，应该包括`version`,`services`,`networks`三部分。

#### services部分的书写规则

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

**注意**，`build`标签指定的为`dockerfile`文件的目录，指定某个`dockerfile`文件需要在`build`下的`dockerfile`标签指定。
如果同时指定了`image`和`build`标签，那么compose会构建镜像，并把镜像命名为`image`标签后的名字。
举个简单的例子，根据下面的`Dockerfile`文件构建名为`whalesay`，标签为`test`的镜像：

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

执行`docker-compose up`后，执行`docker images`命令查看镜像创建结果(如下)。

```
➜  DockerBuildTest docker-compose up
Building whalesay
Step 1/3 : FROM docker/whalesay:latest
 ---> 6b362a9f73eb
Step 2/3 : RUN apt-get -y update && apt-get install -y fortunes
 ---> Using cache
 ---> fcc65b9434be
Step 3/3 : CMD /usr/games/fortune -a | cowsay
 ---> Using cache
 ---> 4af7ae2d516b
Successfully built 4af7ae2d516b
WARNING: Image for service whalesay was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating dockerbuildtest_whalesay_1
Attaching to dockerbuildtest_whalesay_1
whalesay_1  |  ______________________________________
whalesay_1  | / <Overfiend_> Intel. Bringing you the \
whalesay_1  | | cutting-edge technology of 1979      |
whalesay_1  | |                                      |
whalesay_1  | \ for 22 years now.                    /
whalesay_1  |  --------------------------------------
whalesay_1  |     \
whalesay_1  |      \
whalesay_1  |       \
whalesay_1  |                     ##        .
whalesay_1  |               ## ## ##       ==
whalesay_1  |            ## ## ## ##      ===
whalesay_1  |        /""""""""""""""""___/ ===
whalesay_1  |   ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
whalesay_1  |        \______ o          __/
whalesay_1  |         \    \        __/
whalesay_1  |           \____\______/
dockerbuildtest_whalesay_1 exited with code 0
```

```
➜ DockerBuildTest docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
whalesay            test                4af7ae2d516b        4 weeks ago         275 MB
```

在`docker-compose.yml`中定义构建任务，可以使用`args`标签指定构建过程中的环境变量，但是在构建成功后取消。

例如在`docker-compose.yml`中支持以下两种`args`标签的定义方式：

```
# 方式1
build:
  context: .
  args:
    buildno: 1
    password: secret
```

```
# 方式2
build:
  context:
    args:
      - buildno=1
      - password=secret
```

**注意**：YAML 的布尔值（true, false, yes, no, on, off）必须要使用引号引起来（单引号、双引号均可），否则会当成字符串解析。

##### command

使用 command 可以覆盖容器启动后默认执行的命令。

如：

```
command: bundle exec thin -p 3000
```

或写成类似 Dockerfile 中的格式：

```
command: [bundle, exec, thin, -p, 3000]
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

和 --dns 参数一样用途，格式如下：

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

##### entrypoint

在 Dockerfile 中有一个指令叫做 ENTRYPOINT 指令，用于指定接入点，第四章有对比过与 CMD 的区别。
在 docker-compose.yml 中可以定义接入点，覆盖 Dockerfile 中的定义：

```
entrypoint: /code/entrypoint.sh
```

格式和 Docker 类似，不过还可以写成这样

```
entrypoint:
    - php
    - -d
    - zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so
    - -d
    - memory_limit=-1
    - vendor/bin/phpunit
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

##### labels

向容器添加元数据，和Dockerfile的LABEL指令一个意思，格式如下：

```
labels:
  com.example.description: "Accounting webapp"
  com.example.department: "Finance"
  com.example.label-with-empty-value: ""
labels:
  - "com.example.description=Accounting webapp"
  - "com.example.department=Finance"
  - "com.example.label-with-empty-value"
```

##### links

解决容器的链接顺序的问题：

```
links:
 - db
 - db:database
 - redis
```

##### logging

用于配置日志服务。格式如下：

```
logging:
  driver: syslog
  options:
    syslog-address: "tcp://192.168.0.42:123"
```

##### pid

将PID模式设置为主机PID模式，跟主机系统共享进程命名空间。容器使用这个标签将能够访问和操纵其他容器和宿主机的名称空间。

```
pid: "host"
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

##### security_opt

为每个容器覆盖默认的标签。简单说来就是管理全部服务的标签。比如设置全部服务的user标签值为USER:

```
security_opt:
  - label:user:USER
  - label:role:ROLE
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

##### cap_add, cap_drop

添加或删除容器的内核功能。

```
cap_add:
  - ALL

cap_drop:
  - NET_ADMIN
  - SYS_ADMIN
```

##### cgroup_parent

指定一个容器的父级cgroup。

```
cgroup_parent: m-executor-abcd
```

##### devices

设备映射列表。与Docker client的--device参数类似。

```
devices:
  - "/dev/ttyUSB0:/dev/ttyUSB0"
```

##### extends

这个标签可以扩展另一个服务，扩展内容可以是来自在当前文件，也可以是来自其他文件，相同服务的情况下，后来者会有选择地覆盖原有配置。

```
extends:
  file: common.yml
  service: webapp
```
  
用户可以在任何地方使用这个标签，只要标签内容包含file和service两个值就可以了。file的值可以是相对或者绝对路径，如果不指定file的值，那么Compose会读取当前YML文件的信息。

##### network_mode

网络模式，与Docker client的--net参数类似，只是相对多了一个service:[service name] 的格式。

```
network_mode: "bridge"
network_mode: "host"
network_mode: "none"
network_mode: "service:[service name]"
network_mode: "container:[container name/id]"
```

可以指定使用服务或者容器的网络。

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

### 最基础的 ExpressJS + MongoDB 组成的 web 应用

```
mongodb:  // 容器名
  image: mongo:3.0.7  // 使用的镜像
  volumes:
    - ./mongodb/data/db:/data/db  // 挂载目录，宿主机目录:容器内目录
  ports:
    - 27017:27017  // 端口映射，宿主机端口:容器内端口
  command: /bin/bash -c "mongod"  // 容器启动命令
nodejs:
  image: nodejs:5.1.0
  volumes:
    - ./nodejs/code:/code
  ports:
    - 3000:3000
  command: /bin/bash -c "cd /code && npm install && npm start"
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

`docker build -t docker-whale .`命令会使用当前目录下的`Dockerfile`文件构建一个名为`docker-whale`的镜像。

构建过程首先会检查需要构建的内容(Sending build context to Docker daemon 2.048 kB)，之后会根据Dockerfile文件中的命令分步执行操作。所以出现了上面的输出结果。

## 使用Docker搭建自己的Docker仓库

## Docker Hub使用

关于DockerHub中进行`pull``push``Tag`等操作后续补充！

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


