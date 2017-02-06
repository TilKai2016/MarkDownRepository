## RabbitMQ+Docker

参考：
[docker环境下的RabbitMQ部署，Spring AMQP使用](http://www.jianshu.com/p/c40166cb4e86)
[RabbitMQ在分布式系统中的应用](http://www.jianshu.com/p/f2d3c544d3c7)

### Docker安装

### RabbitMQ镜像

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
docker run -d --name rabbitmq --publish 5671:5671 \
 --publish 5672:5672 --publish 4369:4369 --publish 25672:25672 --publish 15671:15671 --publish 15672:15672 \
rabbitmq:management
```

```
# 查看端口占用
lsof -i tcp:5671
```


带管理插件的RabbitMQ启动后可访问`http://localhost:15672/`，默认的用户名为`guest`密码为`guest`

## hpvm项目启动

切换到amqp分支

```
git checkout -b rabbitmq-example origin/rabbitmq-example
```


