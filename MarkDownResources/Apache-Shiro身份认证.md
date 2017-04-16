---
title: Apache-Shiro身份认证
date: 2016-12-12 19:55:56
tags: [Shiro]
---

**参考:**
<!-- more -->
[【Shiro】Apache Shiro架构之身份认证（Authentication）](http://www.cnblogs.com/shanheyongmu/p/5736672.html)
[官方文档](http://shiro.apache.org/authentication.html)

![Apache-Shiro身份认证](http://ohx3k2vj3.bkt.clouddn.com/ShiroAuthentication.png)

## 认证主体Authenticating Subjects
验证一个主体分三步:
>[Step 1: Collect the Subject’s principals and credentials](http://shiro.apache.org/authentication.html#Authentication-Step1%3ACollecttheSubject%27sprincipalsandcredentials)
>获取主体的身份和凭证;

```
// 根据用户名、密码获取令牌(token)
UsernamePasswordToken token = new UsernamePasswordToken(username, password);
// 可选
token.setRememberMe(true);
```

>[Step 2: Submit the principals and credentials](http://shiro.apache.org/authentication.html#Authentication-Step2%3ASubmittheprincipalsandcredentials)
>提交主体的身份和凭证;

```
// 得到当前执行的用户
Subject currentUser = SecurityUtils.getSubject();
// 进行认证
currentUser.login(token);
```

>[Step 3: Handling Success or Failure](http://shiro.apache.org/authentication.html#Authentication-Step3%3AHandlingSuccessorFailure)
>提交成功, 允许访问; 否则重新尝试身份验证或者阻止访问;

```
try {
    currentUser.login(token);
} catch ( AuthenticationException ae ) {
    //unexpected error?
    //Handel error
}
```
>Step4:logout
>当主体完成与应用程序交互, 可以调用subject.logout()方法放弃所有的身份信息,  删除所有的身份信息和Shiro会话;

```
currentUser.logout();
```

<1>. 认证主体包括两部分:

```
Principals：身份。可以是用户名，邮件，手机号码等等，用来标识一个登录主体身份；
Credentials：凭证。常见有密码，数字证书等等。
```

<2>. Shiro可以从指定ini文件或从数据库中指定一个认证主体, 如使用ini文件指定认证主体:

```
[users]
user1=123456
user2=123456
```

该ini文件制定了两个用户, user1和user2, 密码都是123456.

---
## 认证过程Authentication Sequence

![Shiro认证过程](http://ohx3k2vj3.bkt.clouddn.com/shiroAuthentication1.png)

Step1 : 应用程序调用Subject.login(token)方法, 传入代表最终用户的身份和凭证构造的AuthenticationToken实例token;
Step2 : 将Subject实例委托给应用程序的SecurityManager, 通过调用securityManager.login(token)开始认证工作;
Step3,4,5 : SecurityManager根据具体的realm进行安全认证;

realm可能是写在ini文件中的内容, 也可能是jdbc realm、jndi realm等;

## 身份认证示例

<1>. pom.xml

```
<dependency>
   <groupId>org.apache.shiro</groupId>
   <artifactId>shiro-core</artifactId>
   <version>1.2.5</version>
</dependency>
```

Spring集成则是:

```
<dependency>
   <groupId>org.apache.shiro</groupId>
   <artifactId>shiro-spring</artifactId>
   <version>1.2.5</version>
</dependency>
```
<2>. ini文件存放用户名密码:

```
[users]
tilkai=123456
```

<3>. 身份认证Java代码:

```
public class TextRealm {

    public static void main(String[] args) {
        // 读取配置文件，初始化SecurityManager工厂
        Factory<SecurityManager> factory = new IniSecurityManagerFactory("classpath:shiro.ini");
        // 获取securityManager实例
        SecurityManager securityManager = factory.getInstance();
        // 把securityManager实例绑定到SecurityUtils
        SecurityUtils.setSecurityManager(securityManager);
        // 创建token令牌，用户名/密码
        UsernamePasswordToken token = new UsernamePasswordToken("tilkai", "123456");
        // 得到当前执行的用户
        Subject currentUser = SecurityUtils.getSubject();
        try{
            // 身份认证
            currentUser.login(token);
            System.out.println("身份认证成功！");
        }catch(AuthenticationException e){
            e.printStackTrace();
            System.out.println("身份认证失败！");
        }
        // 退出
        currentUser.logout();
    }
}
```

### JDBC Realm

JdbcRealm.ini

```
#数据源选择的是c3p0
dataSource=com.mchange.v2.c3p0.ComboPooledDataSource
dataSource.driverClass=com.mysql.jdbc.Driver
dataSource.jdbcUrl=jdbc:mysql://localhost:3306/db_shiro
dataSource.user=root
dataSource.password=root

#定义一个jdbc的realm，取名为jdbcRealm
jdbcRealm=org.apache.shiro.realm.jdbc.JdbcRealm

#jdbcRealm中有个属性是dataSource，选择我们上边定义的dataSource
jdbcRealm.dataSource=$dataSource

#SecurityManager中的realm选择上面定义的jdbcRealm
securityManager.realms=$jdbcRealm
```





