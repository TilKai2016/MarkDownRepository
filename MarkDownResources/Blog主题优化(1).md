---
title: Blog主题优化(1)
date: 2016-12-09 22:19:20
tags: [Hexo, NexT, Blog]
---

## NexT主题的页脚官方Logo修改
<!-- more -->

原图:
![hexoNexTFooter](http://ohx3k2vj3.bkt.clouddn.com/hexoNexTFotter.png)

**首先定位文件:**

```
$ pwd
/Users/tilkai/GitHub_Blog/blog/themes/hexo-theme-next/layout/_partials/footer.swig
```

**三段代码:**

<1>. "日期❤ XXX"

```
<span class="author" itemprop="copyrightHolder">{{ config.author }}</span>
```

<2>. "由Hexo强力驱动"

```
<div class="powered-by">
  {{ __('footer.powered', '<a class="theme-link" href="https://hexo.io">Hexo</a>') }}
</div>
```

<3>. "主题-..."

```
{{ __('footer.theme') }} -
  <a class="theme-link" href="https://github.com/iissnan/hexo-theme-next">
    NexT.{{ theme.scheme }}
  </a>
```

**中文处理:**

```
$ pwd
/Users/tilkai/GitHub_Blog/blog/themes/hexo-theme-next/languages/zh-Hans.yml
```

修改`footer`下的`powered`和`theme`的值;

参考:
[Hexo-Next底部powered by的logo栏更改以及注意事项](http://www.jianshu.com/p/4fbc57269f1b)

## 资源链接

[BlogのIcons](http://fontawesome.io/icons/)

[HexoのThemes](https://hexo.io/themes/)

## Hexo首页设置展示部分信息

### Hexo推荐加入<!-- more -->代码手动截断
MarkDown文档中在适当位置加入`<!-- more -->`进行手动截断,界面将展示部分文章内容,并展示**<阅读全文>**按钮;

示例:

```
# 基于Spring boot实现Motan Demo
## 简单描述Motan框架
Motan架构包括:
<1>. 服务提供方`Server`
<!-- more -->
<2>. 服务调用方`Client`
<3>. 注册中心`Registry`
```

展示结果:

![<!-- more -->](http://ohx3k2vj3.bkt.clouddn.com/homeSplit.png)

个人暂定在文章开始标题后添加`<!-- more -->`以截取固定长预览内容;

### 其他方法
**参考:**
[如何设置「阅读全文」？](http://theme-next.iissnan.com/faqs.html#%E9%A6%96%E9%A1%B5%E6%98%BE%E7%A4%BA%E6%96%87%E7%AB%A0%E6%91%98%E5%BD%95)其中还给出了设置首页和归档页面展示自定义文章篇数的操作.

## 使用七牛云存储给Blog添加图床

[Hexo文章图片存储选七牛（当然支持MD都可以）](http://www.jianshu.com/p/ec2c8acf63cd)教程很详细,从注册到配置使用的教程都有。

后期可整理给七牛云图片链接加防盗链。

## 使用LeanCloud给Blog添加阅读次数统计功能

### LeanCloud给Blog添加阅读次数统计功能基本配置
参考[为NexT主题添加文章阅读量统计功能](https://notes.wanghao.work/2015-10-21-%E4%B8%BANexT%E4%B8%BB%E9%A2%98%E6%B7%BB%E5%8A%A0%E6%96%87%E7%AB%A0%E9%98%85%E8%AF%BB%E9%87%8F%E7%BB%9F%E8%AE%A1%E5%8A%9F%E8%83%BD.html#%E9%85%8D%E7%BD%AELeanCloud)

<1>. [leancloud官网](https://leancloud.cn/)注册账号并登录；
<2>. 打开控制台
![leancloud0](http://ohx3k2vj3.bkt.clouddn.com/leancloud0.png)
<3>. 创建新应用
![leancloud1](http://ohx3k2vj3.bkt.clouddn.com/leancloud1.png)
<4>. 新建Class用来专门保存我们博客的文章访问量等数据
![leancloud2](http://ohx3k2vj3.bkt.clouddn.com/leancloud2.png)
![leancloud3](http://ohx3k2vj3.bkt.clouddn.com/leancloud3.png)
![leancloud4](http://ohx3k2vj3.bkt.clouddn.com/leancloud4.png)
![leancloud5](http://ohx3k2vj3.bkt.clouddn.com/leancloud5.png)
**注意，此处的Class名称必须为Counter**
![leancloud6](http://ohx3k2vj3.bkt.clouddn.com/leancloud6.png)
复制AppID以及AppKey并在NexT主题的_config.yml文件中我们相应的位置填入即可，正确配置之后文件内容像这个样子:

```
leancloud_visitors:
  enable: true
  app_id: joaeuuc4hsqudUUwx4gIvGF6-gzGzoHsz
  app_key: E9UJsJpw1omCHuS22PdSpKoh
```

这个时候重新生成部署Hexo博客，应该就可以正常使用文章阅读量统计的功能了。需要特别说明的是：记录文章访问量的唯一标识符是文章的发布日期以及文章的标题，因此请确保这两个数值组合的唯一性，如果你更改了这两个数值，会造成文章阅读数值的清零重计。

### leancloud更详细配置参考:
[为NexT主题添加文章阅读量统计功能](https://notes.wanghao.work/2015-10-21-%E4%B8%BANexT%E4%B8%BB%E9%A2%98%E6%B7%BB%E5%8A%A0%E6%96%87%E7%AB%A0%E9%98%85%E8%AF%BB%E9%87%8F%E7%BB%9F%E8%AE%A1%E5%8A%9F%E8%83%BD.html#%E9%85%8D%E7%BD%AELeanCloud)

## 添加百度/谷歌/本地 自定义站点内容搜索
安装 hexo-generator-searchdb，在站点的根目录(如我的站点根目录:`/Users/tilkai/GitHub_Blog/blog`)下执行以下命令:

```
npm install hexo-generator-searchdb --save
```
执行结果:

```
# tilkai @ localhost in ~/GitHub_Blog/blog [11:43:28]
$ npm install hexo-generator-searchdb --save

> hexo-util@0.6.0 postinstall /Users/tilkai/GitHub_Blog/blog/node_modules/hexo-generator-searchdb/node_modules/hexo-util
> npm run build:highlight


> hexo-util@0.6.0 build:highlight /Users/tilkai/GitHub_Blog/blog/node_modules/hexo-generator-searchdb/node_modules/hexo-util
> node scripts/build_highlight_alias.js > highlight_alias.json

hexo-site@0.0.0 /Users/tilkai/GitHub_Blog/blog
└─┬ hexo-generator-searchdb@1.0.3
  └── hexo-util@0.6.0
```

编辑 站点配置文件(博客根目录下的_config.yml)，新增以下内容到任意位置:

```
search:
  path: search.xml
  field: post
  format: html
  limit: 10000
```

配置完成后效果图:
![hexoGeneratorSearchdb](http://ohx3k2vj3.bkt.clouddn.com/hexo-generator-searchdb.png)

## 干货:搭建使用 Hexo 的些许经验!
[搭建使用 Hexo 的些许经验](http://www.jianshu.com/p/728041d6e741)
