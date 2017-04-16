---
title: SpringBoot中RMI与Shiro集成
date: 2016-12-13 16:32:01
tags: [SpringBoot, Shiro]
---

## 简单RMI Demo实现
<!-- more -->
### gradle依赖

```
dependencies {
  compile project(':common')
  compile('org.springframework.boot:spring-boot-starter-thymeleaf')
  compile('org.springframework.boot:spring-boot-starter-cache')
  compile('org.springframework.boot:spring-boot-devtools')
}
```

### 定义规范接口

```
package com.tsingyun.XXX.center.common;

/**
 * Created by cuckoo on 06/12/2016.
 */
public interface HelloService {
  public String hello(String message);
}
```

### 服务提供方模块

<1>. 基于规范接口的接口实现类

```
package com.tsingyun.XXX.center.dataServer.service;

import com.tsingyun.XXX.center.common.HelloService;
import org.springframework.stereotype.Service;

/**
 * Created by cuckoo on 06/12/2016.
 */
@Service
public class HelloServiceImpl implements HelloService {
  @Override
  public String hello(String message) {
    return "Hello "+message+"!";
  }
}
```

<2>. 服务暴露类

```
package com.tsingyun.XXX.center.dataServer.rpc;

import com.tsingyun.XXX.center.common.HelloService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.remoting.rmi.RmiServiceExporter;

/**
 * Created by cuckoo on 06/12/2016.
 */
@Configuration
public class ServiceExporter {
  @SuppressWarnings("SpringJavaAutowiringInspection")
  @Autowired
  private HelloService helloService;

  @Bean
  RmiServiceExporter helloServiceExporter() {
    RmiServiceExporter helloServiceExporter = new RmiServiceExporter();
    helloServiceExporter.setServiceName("HelloService");
    helloServiceExporter.setService(helloService);
    helloServiceExporter.setServiceInterface(HelloService.class);

    return helloServiceExporter;
  }
}
```

### 服务调用方模块

```
package com.tsingyun.XXX.center.dataClient.rpc;

import com.tsingyun.XXX.center.common.HelloService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.remoting.rmi.RmiProxyFactoryBean;

/**
 * Created by cuckoo on 06/12/2016.
 */
@Configuration
public class ServerImporter {
  @Bean(name = "helloService")
  public RmiProxyFactoryBean helloService() {
    RmiProxyFactoryBean rmiProxyFactoryBean = new RmiProxyFactoryBean();

    rmiProxyFactoryBean.setServiceInterface(HelloService.class);
    rmiProxyFactoryBean.setServiceUrl("rmi://127.0.0.1:1099/HelloService");

    return rmiProxyFactoryBean;
  }
}
```

```
package com.tsingyun.XXX.center.dataClient.controller;

import com.tsingyun.XXX.center.common.HelloMotanService;
import com.tsingyun.XXX.center.common.HelloService;
import com.weibo.api.motan.config.springsupport.annotation.MotanReferer;
import com.weibo.api.motan.config.springsupport.annotation.MotanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.websocket.server.PathParam;

/**
 * Created by cuckoo on 06/12/2016.
 * @RestController is a stereotype annotation that combines @ResponseBody and @Controller.
 * @RestController是@ResponseBody和@Controller的整合注释.
 */
@RestController
public class IndexController {
  // 由于@Autowired为根据类型自动装配, 当spring上下文中存在不止一个HelloService类型的bean时,
  // 会抛出BeanCreationException异常,
  // 使用@Qualifier配合@Autowired来解决这些问题,
  // @Qualifier参数为@Service注解的类名,
  @SuppressWarnings("SpringJavaAutowiringInspection")
  @Autowired
  @Qualifier("helloService")
  private HelloService helloService;

  @RequestMapping("/")
  public String index(@PathParam("name") String name) {
    return helloService.hello(name);
  }

}
```

## RMI整合Shiro

### gradle依赖

```
dependencies {
  compile project(':common')
  compile('org.springframework.boot:spring-boot-starter-thymeleaf')
  compile('org.springframework.boot:spring-boot-starter-cache')
  compile('org.springframework.boot:spring-boot-devtools')

  compile("org.apache.shiro:shiro-spring:$springShiroVersion")
}
```

### 接口规范

```
package com.tsingyun.XXX.center.common;

import org.apache.shiro.authz.annotation.RequiresRoles;

/**
 * Created by cuckoo on 06/12/2016.
 */
public interface HelloService {
  public String hello(String message);

  public String login(String username, String password);

  // 访问adminHello方法的前提是当前用户有admin角色
  @RequiresRoles("admin")
  public String adminHello(String message);

  @RequiresRoles("user")
  public String userHello(String message);
}
```

### 服务端Shiro配置

```
package com.tsingyun.XXX.center.dataServer.config;

import org.apache.shiro.realm.Realm;
import org.apache.shiro.realm.text.TextConfigurationRealm;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Created by cuckoo on 10/12/2016.
 */
@Configuration
public class ShiroConfig {
  private static org.slf4j.Logger log = LoggerFactory.getLogger(ShiroConfig.class);


  @Bean
  public Realm realm() {
    TextConfigurationRealm realm = new TextConfigurationRealm();
    // 参数格式含义:用户名 = 密码, 角色1, 角色2, 角色3
    realm.setUserDefinitions("user=password,user\n" +
      "admin=password,admin");

    realm.setRoleDefinitions("admin=read,write\n" +
      "user=read");
    // 是否启用缓存
    realm.setCachingEnabled(false);
    return realm;
  }

}
```

### 服务端接口实现类

```
package com.tsingyun.XXX.center.dataServer.service;

import com.tsingyun.XXX.center.common.HelloService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.springframework.stereotype.Service;

/**
 * Created by cuckoo on 06/12/2016.
 */
@Service
public class HelloServiceImpl implements HelloService {
  private static final Logger log = org.slf4j.LoggerFactory.getLogger(HelloServiceImpl.class);
  @Override
  public String hello(String message) {
    return "Hello "+message+"!";
  }

  @Override
  public String login(String username, String password) {
    // 获取当前执行的用户
    Subject subject = SecurityUtils.getSubject();
    Session session = null;
    // subject.isAuthenticated() 一个被验证过的Subject主体调用isAuthenticated方法返回true,
    // Assert.assertEquals(true, subject.isAuthenticated()); //断言用户已经登录
    if (subject.isAuthenticated()){
      // session = subject.getSession(true), 获取session, 如果当前没有创建Session对象会创建一个,
      // subject.getSession(false), 当前没有创建Session则返回null,
      session = subject.getSession(false);
    } else {
      UsernamePasswordToken token = new UsernamePasswordToken(username, password, true);

      try {
        subject.login(token);
        session = subject.getSession(false);
      } catch (AuthenticationException exception) {
        log.error(exception.getMessage());
      }
    }
    if (session != null) {
      // 当前会话唯一标识
      return (String) session.getId();
    } else {
      return null;
    }
  }

  @Override
  public String adminHello(String message) {
    return "Hello Admin "+message+"!";
  }

  @Override
  public String userHello(String message) {
    return "Hello user "+message+"!";
  }
}
```

### 服务暴露类

```
package com.tsingyun.XXX.center.dataServer.rpc;

import com.tsingyun.XXX.center.common.HelloService;
import org.apache.shiro.mgt.SecurityManager;
import org.apache.shiro.spring.remoting.SecureRemoteInvocationExecutor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.remoting.rmi.RmiServiceExporter;

/**
 * Created by cuckoo on 06/12/2016.
 */
@Configuration
public class ServiceExporter {
  @SuppressWarnings("SpringJavaAutowiringInspection")
  @Autowired
  private HelloService helloService;

  @SuppressWarnings("SpringJavaAutowiringInspection")
  @Autowired
  private SecurityManager securityManager;

  /**
  * Spring远程安全确保每个远程方法调用都与一个负责安全验证的Subject绑定
  *
  */
  @Bean
  SecureRemoteInvocationExecutor secureRemoteInvocationExecutor() {
    SecureRemoteInvocationExecutor secureRemoteInvocationExecutor = new SecureRemoteInvocationExecutor();
    secureRemoteInvocationExecutor.setSecurityManager(securityManager);
    return secureRemoteInvocationExecutor;
  }

  @Bean
  RmiServiceExporter helloServiceExporter() {
    RmiServiceExporter helloServiceExporter = new RmiServiceExporter();
    helloServiceExporter.setServiceName("HelloService");
    helloServiceExporter.setService(helloService);
    helloServiceExporter.setServiceInterface(HelloService.class);
    helloServiceExporter.setRemoteInvocationExecutor(secureRemoteInvocationExecutor());

    return helloServiceExporter;
  }
}
```

### 客户端接口调用类

```
package com.tsingyun.XXX.center.dataClient.rpc;

import com.tsingyun.XXX.center.common.HelloService;
import org.apache.shiro.spring.remoting.SecureRemoteInvocationFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.remoting.rmi.RmiProxyFactoryBean;

/**
 * Created by cuckoo on 06/12/2016.
 */
@Configuration
public class ServerImporter {
  @Bean
  SecureRemoteInvocationFactory secureRemoteInvocationFactory() {
    SecureRemoteInvocationFactory secureRemoteInvocationFactory = new SecureRemoteInvocationFactory();

    return secureRemoteInvocationFactory;

  }
  @Bean(name = "helloService")
  public RmiProxyFactoryBean helloService() {
    RmiProxyFactoryBean rmiProxyFactoryBean = new RmiProxyFactoryBean();

    rmiProxyFactoryBean.setServiceInterface(HelloService.class);
    rmiProxyFactoryBean.setServiceUrl("rmi://127.0.0.1:1099/HelloService");
    rmiProxyFactoryBean.setRemoteInvocationFactory(secureRemoteInvocationFactory());

    return rmiProxyFactoryBean;
  }
}
```

### 客户端controller类

```
package com.tsingyun.XXX.center.dataClient.controller;

import com.tsingyun.XXX.center.common.HelloService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.websocket.server.PathParam;

/**
 * Created by cuckoo on 06/12/2016.
 */
@RestController
public class IndexController {
  @SuppressWarnings("SpringJavaAutowiringInspection")
  @Autowired
  @Qualifier("helloService")
  private HelloService helloService;

  @RequestMapping("/")
  public String index(@PathParam("name") String name) {
    return helloService.hello(name);
  }

  @RequestMapping("/login")
  public String login() {
    String sessionId = helloService.login("user", "password");
    if (sessionId != null) {
      System.setProperty("shiro.session.id", sessionId);
    }
    return sessionId;
  }

  @RequestMapping("/adminhello")
  public String adminHello(@PathParam("name") String name) {
    return helloService.adminHello(name);
  }

  @RequestMapping("/userhello")
  public String userHello(@PathParam("name") String name) {
    return helloService.userHello(name);
  }
}
```


