---
title: 如何解决SpringBoot跨域问题
date: 2016-12-21 10:21:14
tags: [SpringBoot, 跨域]
---

# 关于跨域
<!-- more -->
在网络上如果随便去请求其他服务器的资源，执行其他网站的脚本，是不利于自身安全的，于是，处于安全原因，浏览器都遵循着同源原则，拦截不同域名之间的请求。

**详细说明参考:**
><1>. [HTTP access control (CORS)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS)

><2>. 当它请求的一个资源是从一个与它本身提供的第一个资源的不同的域名时，一个资源会发起一个跨域HTTP请求(Cross-site HTTP request)。
比如说，域名A ( http://domaina.example ) 的某 Web 应用程序中通过< img>标签引入了域名B( http://domainb.foo ) 站点的某图片资源(http://domainb.foo/image.jpg)，域名A的那 Web 应用就会导致浏览器发起一个跨站 HTTP 请求。
在当今的 Web 开发中，使用跨站 HTTP 请求加载各类资源（包括CSS、图片、JavaScript 脚本以及其它类资源），已经成为了一种普遍且流行的方式。
正如大家所知，出于安全考虑，浏览器会限制脚本中发起的跨站请求。比如，使用 XMLHttpRequest 对象发起 HTTP 请求就必须遵守同源策略。 具体而言，Web 应用程序能且只能使用 XMLHttpRequest 对象向其加载的源域名发起 HTTP 请求，而不能向任何其它域名发起请求。为了能开发出更强大、更丰富、更安全的Web应用程序，开发人员渴望着在不丢失安全的前提下，Web 应用技术能越来越强大、越来越丰富。比如，可以使用 XMLHttpRequest
发起跨站 HTTP 请求。（这段描述跨域不准确，跨域并非浏览器限制了发起跨站请求，而是跨站请求可以正常发起，但是返回结果被浏览器拦截了。最好的例子是CSRF跨站攻击原理，请求是发送到了后端服务器无论是否跨域！注意：有些浏览器不允许从HTTPS的域跨域访问HTTP，比如Chrome和Firefox，这些浏览器在请求还未发出的时候就会拦截请求，这是一个特例。）

文／BeeNoisy（简书作者）
原文链接：http://www.jianshu.com/p/f2060a6d6e3b
著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
>

# 整理众多解决SpringBoot跨域问题中的几种解决方案

## 参考[Spring Boot 之路[6]--允许跨域请求](http://www.jianshu.com/p/f2060a6d6e3b)

```
package com.tsingyun.XXXX.center.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

/**
 * Created by tilkai on 2016/12/21.
 */
@Configuration
public class WebConfig {

    private CorsConfiguration buildConfig() {
        CorsConfiguration corsConfiguration = new CorsConfiguration();
        // 允许任何域名
        corsConfiguration.addAllowedOrigin("*");
        // 允许任何头
        corsConfiguration.addAllowedHeader("*");
        // 允许任何方法(post、get等)
        corsConfiguration.addAllowedMethod("*");
        return corsConfiguration;
    }

    @Bean
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", buildConfig());
        return new CorsFilter(source);
    }

}
```

## 参考[Enabling Cross Origin Requests for a RESTful Web Service](https://spring.io/guides/gs/rest-service-cors/)

```
package com.tsingyun.XXXX.center.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

/**
 * Created by tilkai on 2016/12/21.
 */
@Configuration
public class WebConfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurerAdapter() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/api/**");
            }
        };
    }

}
```

