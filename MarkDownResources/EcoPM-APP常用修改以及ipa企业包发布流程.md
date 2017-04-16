---
title: EcoPM_APP常用修改以及ipa企业包发布流程
date: 2016-12-31 01:25:24
tags: [IOS]
---

## 经常修改的代码位置整理
<!-- more -->
### 服务器连接

`Externals-Utility-Define.h`中修改：

```
#define kBaseURL @"120.26.110.125/zdcloud"
```

### 二维码地址

`www-images`文件夹下添加`aces-ios.png`(二维码图片)
并在`www-setting.html`中加入

```
<div style="width: 38%;margin: 0 auto;margin-top: 35px;"><img src="images/aces-ios.png"></div>
```

## ipa企业包打包发布流程

### 登录开发者平台
[APPLE开发者平台登录](https://idmsa.apple.com/IDMSWebAuth/login?appIdKey=891bd3417a7776362562d2197f89480a8547b108fd934911bcbea0110d07f757&path=%2Faccount%2F&rv=1)

### 本机申请证书

![本机申请证书0](http://ohx3k2vj3.bkt.clouddn.com/%E6%9C%AC%E6%9C%BA%E7%94%B3%E8%AF%B7%E8%AF%81%E4%B9%A60.png)

![本机申请证书1](http://ohx3k2vj3.bkt.clouddn.com/%E6%9C%AC%E6%9C%BA%E7%94%B3%E8%AF%B7%E8%AF%81%E4%B9%A601.png)

![本机申请证书2](http://ohx3k2vj3.bkt.clouddn.com/%E6%9C%AC%E6%9C%BA%E7%94%B3%E8%AF%B7%E8%AF%81%E4%B9%A62.png)

### 在apple开发者网站创建加入本机证书的证书

![dev0](http://ohx3k2vj3.bkt.clouddn.com/iosdeveloper0.png)

![dev1](http://ohx3k2vj3.bkt.clouddn.com/iosdeveloper2.png)

![dev2](http://ohx3k2vj3.bkt.clouddn.com/iosdeveloper3.png)

![dev3](http://ohx3k2vj3.bkt.clouddn.com/iosdeveloper4.png)

**之后一直continue，加入本机申请的证书后完成，然后下载到本地。**

![dev4](http://ohx3k2vj3.bkt.clouddn.com/iosdeveloper5.png)

### app IDs暂时未做处理，使用的边界已经建立好的

![package0](http://ohx3k2vj3.bkt.clouddn.com/package0.png)

**如需进行设置，可参考[博客](http://blog.csdn.net/iitvip/article/details/8501576)中的介绍。**
**devices中也未做添加，这个应该可以在以后需要的时候再添加设备即可；**
**然后，profiles中关联certificates以及App IDs后下载到本地。**

![package1](http://ohx3k2vj3.bkt.clouddn.com/package1.png)

### Xcode配置打包

[简单粗暴的教程](http://www.jianshu.com/p/9df7d8930a3e)

摘重要的写一下：

![xcode0](http://ohx3k2vj3.bkt.clouddn.com/xcode0.png)

选择Release模式:

![xcode1](http://ohx3k2vj3.bkt.clouddn.com/xcode3.png)

![xcode2](http://ohx3k2vj3.bkt.clouddn.com/xcode4.png)

之后Cmd+b重新编译
查看`Product`中`Archive`是否可点击，
如果不可点击:

![xcode3](http://ohx3k2vj3.bkt.clouddn.com/xcode5.png)

之后执行`Archive`
(本人在此处遇到一个问题)：

```
Code Sign error: No matching provisioning profile found: Your build settings specify a provisioning profile with the UUID “faddfe8b-461b-4dc0-9cc0-a7ddcf86089b”, however, no such provisioning profile was found.
```

错误截图:

![xcode6](http://ohx3k2vj3.bkt.clouddn.com/xcode6.png)

属于更新证书错误，解决方案参考了该[blog](http://blog.csdn.net/cuibo1123/article/details/39432411)

内容截图:

![xcode7](http://ohx3k2vj3.bkt.clouddn.com/xcode7.png)

解决错误后会弹窗:

![xcode8](http://ohx3k2vj3.bkt.clouddn.com/xcode8.png)

成功后进入以下页面(或通过window-organizer进入)

![xcode9](http://ohx3k2vj3.bkt.clouddn.com/xcode9.png)

![xcode10](http://ohx3k2vj3.bkt.clouddn.com/xcode10.png)


