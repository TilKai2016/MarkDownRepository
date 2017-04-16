---
title: HttpRequest
date: 2016-12-25 18:46:22
tags: [Http, HttpRequest]
---

*HttpRequest实例的属性包含了关于这次请求的大多数重要信息(未包含那些?)，并且除了session外的所有属性都应该认为其是只读的*
<!-- more -->
>* path 请求页面地址的完整字符串
>* method 提交请求使用的http方法，值总是大写的
>* GET POST 字典类对象，django.http.QueryDict类的实例，POST不包含文件上传信息
>* REQUEST 字典类对象，先搜索POST后搜索GET，如：

````
GET={"name":"john"}, POST={"age":"34"}
````
>那么：

```
REQUEST["name"]="john", REQUEST["age"]=34
```
>建议使用GET、POST而非REQUEST，使得向前兼容且更清楚的表示
>* COOKIES 一个标准的python字典，包含所有cookie，键和值都是字符串
>* FILES 一个类字典对象，包含所有上传的文件。
>
>FILES的键来自

```
<input type="file" name=""/>
```

中的name，FILES的值是一个标准的python字典，包含以下三个值【filename:上传的文件吗; content-type:上传文件的文件类型; content:上传文件的原始内容;】
>
>**注意，FILES只有请求是POST，且提交的````<form>````包含````enctype="multipart/form-data"````时才包含数据，否则，FILES只是一个空的类字典对象**
>
>* META 一个标准的python字典，包含所有有效的http头信息，有效的头信息与服务器和客户端有关。
>
>如下例子:
>````CONTENT_LENGHT````
>````CONTENT_TYPE````
>````QUERY_STRING````:未解析的原始请求字符串
>````REMOTE_ADDR````:客户端IP地址
>````REMOTE_HOST````:客户端端口号
>````SERVER_NAME````:服务器主机名
>````SERVER_POST````:服务器端口号
>在META中有效的任一HTTP头信息都是带有HTTP_前缀的键，
>例如:
>````HTTP_ACCEPT_ENCODING````
>````HTTP_ACCEPT_LANGUAGE````
>````HTTP_HOST````:客户端发送的HOST头信息
>````HTTP_REFERER````:被指向的页面
>````HTTP_USER_AGENT````:客户端的user_agent字符串