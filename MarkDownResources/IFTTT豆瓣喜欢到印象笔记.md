## 使用feed43获取豆瓣我的喜欢RSS

![feed43home](http://ohx3k2vj3.bkt.clouddn.com/feed43home.jpeg)

[feed43首页]`www.feed43.com`点击`Create your own feed`。

设置如下:

![myFeed43Cfg](http://ohx3k2vj3.bkt.clouddn.com/myFeed43Cfg.png)

设置点包括:

* Address:豆瓣"我的喜欢"URL, Encoding可不填写, feed43会自动识别编码格式, 点击`Reload`按钮;
* 分析Page Source中代码, 获取有用标签信息;
* Global Search Pattern设置为:{%}
* Item(repeatable)Search Pattern可能因页面布局调整等变化, 2017-06月份的获取规则如下:

```
<div class="status-item">
{*}
<div class="title">
{*}
<a href="{%}" target="_self">{%}</a>
{*}
</div>
{*}
<p>{%}<p class="time">{%}</p>
{*}
</div>
```

点击`Extract`测试提取内容;
* 列表项模版根据提取内容自行调整顺序;
* 可点击`Preview`预览RSS界面内容;
* 记住自己的Feed URL和Edit URL, 以便引用和修改。


