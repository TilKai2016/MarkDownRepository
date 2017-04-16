---
title: 基于SpringBoot实现MotanDemo
date: 2016-12-08 23:28:35
tags: [SpringBoot, Motan]
---

## 首先了解RPC
<!-- more -->
参考 : [知乎-谁能用通俗的语言解释一下什么是 RPC 框架？](https://www.zhihu.com/question/25536695)
![引用RPC工作流程图片](http://ohx3k2vj3.bkt.clouddn.com/RPCStructure.jpg)

(身份验证可能使用Netty实现。)
将函数的参数和要调用的函数的名称作为协议的一部分，达成RPC.
表现出来的特性就是，object invok(parameter)，就代表了，序列化 parameter 对象到中间格式，利用远程服务器的 invok 函数进行处理 ，同时将返回的数据解码生成 object对象。
完成RPC需要两个协议:对象序列化协议和调用控制协议;

生产环境中需要考虑stub怎么生成,序列化怎么最高效,如何统一不同机器之前的调用,(大小端的机器等),如何识别该调用哪个机器,负载均衡.socket通信.等等.

## 简单描述Motan框架
Motan架构包括:
<1>. 服务提供方`Server`
<2>. 服务调用方`Client`
<3>. 注册中心`Registry`
流程大致为:
`Server`向`Registry`注册服务；
`Client`向`Registry`订阅指定服务;
`Client`获取`Registry`返回的服务列表后连接`Server`；
`Client`通过`Registry`感知`Server`的状态变更；
![Motan调用流程](http://ohx3k2vj3.bkt.clouddn.com/Motan01.jpg)

[MotanDemo官方下载地址](https://github.com/weibocom/motan)

## Motan依赖
pom中:

```
<dependency>
    <groupId>com.weibo</groupId>
    <artifactId>motan-core</artifactId>
    <version>0.2.2</version>
</dependency>
<dependency>
    <groupId>com.weibo</groupId>
    <artifactId>motan-transport-netty</artifactId>
    <version>0.2.2</version>
</dependency>

<!-- dependencies blow were only needed for spring-based features -->
<dependency>
    <groupId>com.weibo</groupId>
    <artifactId>motan-springsupport</artifactId>
    <version>0.2.2</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>4.2.4.RELEASE</version>
</dependency>
```

gradle中:

```
compile("com.weibo:motan-core:0.2.2")
compile("com.weibo:motan-transport-netty:0.2.2")
compile("com.weibo:motan-springsupport:0.2.2")
compile("org.springframework:spring-context:4.2.4.RELEASE")
```
## 通过注解实现Motan Demo

### 为服务提供方和服务调用方创建规范接口

```
public interface HelloWorld {
    public String hello(String name);
}
```

### 服务端创建基于规范接口的实现类

```
@MotanService(export = "8002")
public class HelloWorldImpl implements HelloWorld {
   public String hello(String name) {
       System.out.println(name);
       return "Hello " + name + "!";
   }
}
```

## 服务端创建服务暴露类,服务暴露类里定义带有如下返回值的方法
### 返回值类型为AnnotationBean的bean定义,该方法指定待解析的包名

```
@Bean
public AnnotationBean motanAnnotationBean() {
    AnnotationBean annotationBean = new AnnotationBean();
    motanAnnotationBean.setPackage("com.weibo.motan.demo.server");
    return motanAnnotationBean;
}
```

此处指定的是`HelloWorldImpl`所在的包目录(指定到类好像也成立)

### 返回类型为ProtocolConfigBean的bean定义,该方法做协议配置

```
@Bean(name = "demoMotan")
public ProtocolConfigBean protocolConfig() {
   ProtocolConfigBean config = new ProtocolConfigBean();
   config.setDefault(true);
   config.setName("motan");
   config.setMaxContentLength(1048576);
   return config;
}
```

### 返回值类型为RegistryConfigBean的bean定义,该方法用于配置注册中心

```
@Bean(name = "registryConfig")
public RegistryConfigBean registryConfig() {
   RegistryConfigBean config = new RegistryConfigBean();
   config.setRegProtocol("local");
   return config;
}
```

### 返回值类型为BasicServiceConfigBean的bean定义,该方法提供服务暴露或引用时所需要的配置项

```
@Bean
public BasicServiceConfigBean baseServiceConfig() {
   BasicServiceConfigBean config = new BasicServiceConfigBean();
   config.setExport("demoMotan:8002");
   config.setGroup("testgroup");
   config.setAccessLog(false);
   config.setShareChannel(true);
   config.setModule("motan-demo-rpc");
   config.setApplication("myMotanDemo");
   config.setRegistry("registryConfig");
   return config;
}
```

## 服务端main方法

```
public static void main(String[] args) {
    //System.setProperty("server.port", "8081");
    ConfigurableApplicationContext context =  SpringApplication.run(SpringBootRpcServerDemo.class, args);
    //MotanSwitcherUtil.setSwitcherValue(MotanConstants.REGISTRY_HEARTBEAT_SWITCHER, true);
}
```
## 客户端端创建服务引用类,服务引用类里定义带有如下返回值的方法
### 返回值类型为AnnotationBean的bean定义,该方法指定待解析的包名

```
@Bean
public AnnotationBean motanAnnotationBean() {
    AnnotationBean annotationBean = new AnnotationBean();
    motanAnnotationBean.setPackage("com.weibo.motan.demo.client.control");
    return motanAnnotationBean;
}
```
<该处指定controller包,解析@MotanReferer注解的对象>

### 返回类型为ProtocolConfigBean的bean定义
与服务端配置相同即可;

### 返回值类型为RegistryConfigBean的bean定义
与服务端配置相同即可;

### 返回值类型为BasicRefererConfigBean的bean定义

```
@Bean(name = "clientBasicConfig")
    public BasicRefererConfigBean baseRefererConfig() {
        BasicRefererConfigBean config = new BasicRefererConfigBean();
        config.setProtocol("demoMotan");
        config.setGroup("motan-demo-rpc");
        config.setModule("motan-demo-rpc");
        config.setApplication("myMotanDemo");
        config.setRegistry("registry");
        config.setCheck(false);
        config.setAccessLog(true);
        config.setRetries(2);
        config.setThrowException(true);
        return config;
    }
```

### controller中将注入的待暴露接口加上@MotanReferer注解

```
@Autowrired
@MotanReferer(basicReferer = "clientBasicConfig", group = "testgroup", directUrl = "127.0.0.1:8002")
HelloWorld helloWorld; 
```

## 以上操作完成配置

问题解决:

中间出现过log4j包引用冲突的问题,解决办法:

build.gradle中添加

```
configurations {
  all*.exclude group: 'org.slf4j', module: 'slf4j-log4j12'
}
```

如果接口规范在单独的module中,需要在client和server的module的build.gradle中添加对接口规范类所在module的依赖,
dependencies中添加:

```
compile project(':module名称')
```

**参考:**
[spring-boot motan 整合](http://www.jianshu.com/p/941c2fe65d52)

[GitHub](https://github.com/weibocom/motan)
