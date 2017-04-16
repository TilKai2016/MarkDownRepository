---
title: gdk.js
date: 2016-12-31 01:35:55
tags: [gdk.js, Jquery]
---

## addData方法
<!-- more -->
筛选功能会调用该方法 `$.fn.addData`

```
addData: function(g){}
```
1. `g = Array[查询到的数据列表]`
2. `a('th', this.hDiv).each(function(){})`中,this为当前表格对象,以key:value形式展示表格属性;this.hDiv为表格表头部分;
3. l为字段的对象集合,每个字段object有align,hide,width属性;
4. 遍历数组g,在循环中定义数组k填充table标签,数组k拼接成了table,`class=‘grid-row-table’`,于是界面上每一条记录都是一个table;
5. addData方法中做了mouseover事件的处理;
6. $(this.BDivBody).find("div.grid-row").context查看属性;

## showTogColList方法
 点击表头选择按钮触发该事件,内部做界面展示的Html拼接,最后徐$(this.togColList).show();

## togCol方法
复选框的点击触发,`togCol: function(g, l){}`,g为索引值;l为true(展示)||false(隐藏);
对l判断后的if,else为重点,此处对bDivBody中的table按索引值获取后进行了style.display操作.

![gdkjs](http://ohx3k2vj3.bkt.clouddn.com/gdkjs.jpg)