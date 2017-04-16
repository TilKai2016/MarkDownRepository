---
title: Apache-Shiro简介
date: 2016-12-12 16:27:00
tags: [Shiro]
---

[官方文档](http://shiro.apache.org/documentation.html)
<!-- more -->
**参考:**
[Apache Shiro 简介](http://www.ibm.com/developerworks/cn/web/wa-apacheshiro/)
[第一章 Shiro简介——《跟我学Shiro》](http://jinnianshilongnian.iteye.com/blog/2018936)
[黑马张开涛Shiro源码参考实例](https://github.com/zhangkaitao/shiro-example)

**Apache Shiro** : 用于身份验证和授权的框架.
**身份验证** : 指验证用户身份.(如常见验证身份的方法有:用户名和密码的组合,指纹,证书等).
**授权** : 身份验证成功后, 授权进行接管, 以便进行访问的限制或允许.

Shiro可以帮助我们完成：认证、授权、加密、会话管理、与Web集成、缓存等。

**Shiro基本功能点:**
![Shiro基本功能](http://ohx3k2vj3.bkt.clouddn.com/ShiroStructure.png)
**Ahthentication** : 身份认证/登录, 验证用户是不是拥有相应的身份;
**Authorization** : 授权, 即权限验证, 验证某个已认证的用户是否拥有某个权限;
**Session Manager** : 回话管理, 用户登录后就是一次会话, 在没有退出前, 用户的所有信息都在该会话中, 会话可以是普通JavaSE环境的, 也可以是如Web环境的;
**Cryptography** : 加密, 保护数据的安全, 如密码加密存储到数据库中等;
**Web Support** : 集成到WEB环境;
**Concurrency** : shiro支持多线程应用的并发验证, 即如在一个线程中开启另一个线程, 能把权限自动传播过去;
**Testing** : 测试支持;
**Run As** : 允许一个用户假装另一个用户(如果他们允许)的身份进行访问;
**Remember Me** : 记住我;

**但是!**
**Shiro不会去维护用户、维护权限, 这些需要我们自己去设计/提供, 然后通过相应的接口注入给Shiro.**

## 从外部和内部来看一下Shiro框架

对于一个好的框架, 从外部来看, 应该具有非常简单易于使用的API, 且API契约明确; 从内部来看, 其应该有一个可拓展的架构, 即非常容易插入用户的自定义实现, 因为任何框架都不能满足所有需求;

### 外部来看Shiro工作流程
![Shiro外部工作流程](http://ohx3k2vj3.bkt.clouddn.com/ShiroStructure2.png)

由图, 应用代码直接交互的对象是Subject, 也就是说Shiro的对外API核心就是Subject;

**Subject** : 主体, 代表当前"用户", "用户"不一定是一个具体的人, 与当前应用交互的任何东西都是sbuject, 像网络爬虫, 机器人等, "用户"是一个抽象概念; 所有Subject都绑定到SecurityManager, 与Subject的所有交互都会委托给SecurityManager, 可以把Subject认为是一个门面, SecurityManager才是实际的执行者;
**SecurityManager** : 安全管理器, 即所有与安全有关的操作都会与SecurityManager交互, 且它管理着所有Subject, 可以看出它是Shiro的核心, 其负责与其他组件交互, 相当SpringMVC中的DispatcherServlet前端控制器;
**Realm** : 域, Shiro从Realm获取安全数据(例如用户, 角色, 权限), 就是说SecurityManager要验证用户身份, 需要从Realm获取相应的用户进行比较以确定用户身份是否合法, 也需要从Realm得到用户相应的角色/权限进行验证用户是否能进行操作, 可以把Realm看成DataSource, 即安全数据源;

于是, 最简单的Shiro应用:
1. 应用代码通过Subject来进行认证和授权, Subject委托给SecurityManager;
2. 给Shiro的SecurityManager注入Realm, SecurityManager获取用户及权限进行判断;

**由此可见, Shiro没有提供维护用户/权限的功能, 这些需要开发者通过Realm注入;**

---
### 内部来看Shiro工作流程
![Shiro内部工作流程](http://ohx3k2vj3.bkt.clouddn.com/ShiroStructure3.png)

**Subject** : 由图看出, Subject可以是任何可以跟应用交互的"用户";
**SecurityManager** : 相当于SpringMVC中的DispatcherServlet或者Struts2中的FilterDispatcher, 所有具体的交互都通过SecurityManager进行控制, 它管理着所有Subject、且负责进行认证和授权、及会话、缓存的管理;
**Authenticator** : 认证器, 负责主体认证, 这是一个扩展点, 如果用户觉得Shiro默认的不好, 可以自定义实现; 其需要认证策略(Authentication Strategy), 即什么情况下算用户认证通过了;
**Authrizer** : 授权器, 或者叫访问控制器, 用来决定主体是否有权限进行相应的操作, 即控制着用户能访问应用中的哪些功能;
**Realm** : 可以有1个或多个Realm, 可以认为是安全实体数据源, 即用于获取安全实体的, 可以是JDBC实现, 可以是LDAP实现或者内存实现等, 由用户提供; **注意**, *Shiro不知道你的用户/权限存储在哪及以何种格式存储, 所以我们一般在应用中都需要实现自己的Realm*;
**SessionManager** : 如果写过Servlet就应该知道Session的概念, Session需要有人去管理它的生命周期, 这个组件就是SessionManager, 而Shiro并不仅仅可以用在Web环境, 也可以用在如普通的JavaSE环境、EJB等环境, 所以, Shiro就抽象了一个自己的Session来管理主体与应用之间交互的数据, 这样的话, 比如我们在Web环境用, 刚开始是一台Web服务器, 接着又上了台EJB服务器, 这时想把两台服务器的会话数据放到一个地方, 这个时候就可以实现自己的分布式会话(如把数据放到Memcached服务器);
**SessionDAO** : 如果我们想把Session保存到数据库, 那么可以实现自己的SessionDAO, 通过如JDBC等操作写入数据库; 此外Session还可以使用Cache缓存, 以提高性能;
**CacheManager** : 缓存控制器, 用来管理像用户、角色、权限等的缓存的, 因为这些数据基本上很少去改变, 放到缓存中后可以提高访问的性能;
**Cryptography** : Shiro提供了密码加密/解密组件;