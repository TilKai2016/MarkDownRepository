## Centos中jar文件开机自启和挂掉重启

参考于jescp、某次数据采集程序。
编辑wdog.sh文件，设置jar文件的开机自启动脚本，

将collect-server.service放到/usr/lib/systemd/system/下面，

设置开机自启动：

```
systemctl enable collect-server.services
```

## SpringBoot生成的jar包如何后台执行

### java -jar *.jar 直接执行

```
java -jar collect-server.jar
```

特点 : 当前ssh窗口被锁定, 可按`CTRL + C`或直接关闭窗口打断程序运行。

### java -jar *.jar & 后台执行

```
java -jar collect-server.jar &
```

`&`代表在后台运行。
特定 : 当前ssh窗口不被锁定, 但是当窗口关闭时, 程序中止运行。

### 改进, 如何让窗口关闭时程序仍然运行?

#### nohup命令

语法 : `nohup Command [ Arg ... ] [　& ]`
描述 : nohup 命令运行由 Command 参数和任何相关的 Arg 参数指定的命令，忽略所有挂断（SIGHUP）信号。在注销后使用 nohup 命令运行后台中的程序。要运行后台中的 nohup 命令，添加 & （ 表示“and”的符号）到命令的尾部。
`nohup java -jar *.jar &`
nohup 意思是不挂断运行命令,当账户退出或终端关闭时,程序仍然运行。

在本次工作中，使用的是如下命令：

```
nohup ./wdog.sh &
```

#### 指定输出文件

默认输出到nohup.out文件
`nohup java -jar *.jar >output 2>&1 &`
解释：
操作系统中有三个常用的流：
0：标准输入流 stdin
1：标准输出流 stdout
2：标准错误流 stderr
一般当我们用 > output，实际是 1>output的省略用法；< input ，实际是 0 < input 的省略用法。
带&的命令行，即使terminal（终端）关闭，或者电脑死机程序依然运行（前提是你把程序递交到服务器上)；
2>&1的意思
这个意思是把标准错误（2）重定向到标准输出中（1），而标准输出又导入文件output里面，所以结果是标准错误和标准输出都导入文件output里面了。
至于为什么需要将标准错误重定向到标准输出的原因，那就归结为stderr没有缓冲区，而stdout有。这就会导致 >output 2>output 文件output被两次打开，而stdout和stderr将会竞争覆盖。
这就是为什么有人会写成：nohup ./command.sh >output 2>output出错的原因了。
jobs命令 查看后台运行任务
fg命令 将某个作业调回前台控制。

### 系统服务

在Spring Boot的Maven插件中，还提供了构建完整可执行程序的功能，什么意思呢？就是说，我们可以不用java -jar，而是直接运行jar来执行程序。这样我们就可以方便的将其创建成系统服务在后台运行了。

主要步骤如下：

1、在`pom.xml`中添加Spring Boot的插件，并注意设置executable配置

```
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <executable>true</executable>
    </configuration>
</plugin>
```

2、在完成上述配置后，使用mvn package进行打包，构建一个可执行的jar包
3、给jar包授权
`chmod u+x app.jar`
4、创建软连接到/etc/init.d/目录下
`ln -s /usr/local/app/app.jar /etc/init.d/app`
5、在完成软连接创建之后，我们就可以通过如下命令对app.jar应用来控制启动、停止、重启操作了
`service app start|stop|restart|status`
默认的应用pid：`/var/run/app/app.pid`
默认的日志目录：`/var/log/app.log`

自定义配置

在jar包相同路径下创建一个.conf文件，名称应该与.jar的名称相同，如app.conf
在其中配置相关变量，如：

```
LOG_FOLDER=/usr/local/app/logs/console //指定控制台输出到文件
RUN_ARGS=--server.port=8080
JAVA_OPTS="-Ddubbo.registry.address=127.0.0.1:2181 -Ddubbo.protocol.port=20887 -Ddubbo.application.name=j-provider -Ddubbo.monitor.protocol=registry"
```

安全设置

为服务创建一个独立的用户bootapp，同时该用户的shell绑定为`/usr/sbin/nologin`
把app.jar的所有者设为bootapp：`chown booapp:bootapp app.jar`
赋予最小权限：`chmod 500 app.jar`
禁止修改：`chattr +i app.jar`
对app.conf文件做如下处理： `chmod 400 app.conf;chown root:root app.conf`
FAQ:

1、`Unable to find Java`

解决方法：建立java命令的软链接到/sbin，如：`ln -s /usr/local/jdk/bin/java /sbin/java`

参考：
http://blog.csdn.net/qq_30739519/article/details/51115075
http://www.cnblogs.com/zq-inlook/p/3577003.html
http://blog.didispace.com/spring-boot-run-backend/

http://www.jianshu.com/p/563497a6e1a7

## 使用docker执行该jar文件

### 使用Dockerfile生成镜像执行

Dockerfile内容:

```
FROM openjdk:8-jre-alpine

RUN apk add --update --no-cache tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && apk del tzdata

ADD ./collect-server-*.jar /opt/collect-server.jar

ENTRYPOINT ["java", "-jar", "/opt/collect-server.jar", "--spring.profiles.active=prod,docker"]
```

注:`apk`是`alpine(一种面向安全的轻量Linux发行版)`的包管理工具。

用到的docker命令：

```
# 基于Dockerfile生成Docker镜像
docker build -t collect-server .

# 基于生成的镜像启动jar文件容器(后台、自动启动、别名)
docker run -d --restart=always --name collect-server collect-server

# 基于生成的镜像启动jar文件容器(交互界面、MQ-HOST、别名)
docker run -it -e SPRING_RABBITMQ_HOST=172.17.0.2 --name collect-server collect-server
```

出现的问题：

在本地执行与在服务器执行的结果不同，不同点是时间的格式，服务器是12小时制，解决方案，使用docker容器环境。


