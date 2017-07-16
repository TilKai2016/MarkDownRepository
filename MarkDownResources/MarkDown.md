[TOC]

## MarkDowm常用语法

### 字体

#### *斜体*

```
*斜体*
```

#### **粗体**

```
**粗体**
```

#### ***加粗斜体***

```
***加粗斜体***
```

#### ~~删除线~~

```
~~删除线~~
```

### 标题

```
# 一级标题
## 二级标题
### 三级标题
#### 四级标题
...
```

### 分割线

三个及以上中横线`-`、星号`*`都可用作分割线

```
---

- - -

***

* * *
```

### 超链接

#### 行内超链接

* 欢迎来到[Tilkai的blog](http://tilkai.space)(鼠标悬停无标题)

```
[连接名称](地址)
```

* 欢迎来到[Tilkai的blog](http://tilkai.space "TilKai的blog")(鼠标悬停有标题)

```
[连接名称](地址 "标题")
```

#### 参考超链接

* 本MarkDown使用说明参考于[Markdown-语法手册][1](鼠标悬停无标题)

[1]:http://blog.leanote.com/post/freewalk/Markdown-%E8%AF%AD%E6%B3%95%E6%89%8B%E5%86%8C#title

```
[链接文字](标记)
# [标记]:网址
```

* 本MarkDown使用说明参考于[Markdown-语法手册][2](鼠标悬停有标题)

[2]:http://blog.leanote.com/post/freewalk/Markdown-%E8%AF%AD%E6%B3%95%E6%89%8B%E5%86%8C#title "Markdown-语法手册"

```
[链接文字](标记)
# [标记]:网址 "标题"
```

* 上述两种是通过标记进行定位的, 也可以通过链接文字定位

本MarkDown使用说明参考于[Markdown-语法手册][](鼠标悬停有标题)

[Markdown-语法手册]:http://blog.leanote.com/post/freewalk/Markdown-%E8%AF%AD%E6%B3%95%E6%89%8B%E5%86%8C#title "Markdown-语法手册"

```
[链接文字][]
# [Markdown-语法手册]:http://blog.leanote.com/post/freewalk/Markdown-%E8%AF%AD%E6%B3%95%E6%89%8B%E5%86%8C#title "Markdown-语法手册"
```

#### 自动链接

<http://tilkai.space>

```
<http://tilkai.space>
```

### ~~锚点(未尝试成功, 暂不参考)~~

锚点, 即页面超链接, 能够链接页面内的元素, 实现页面内跳转.

示例, 跳转到本节的目录:



跳转到[字体](#字体)

### 列表

#### 无序列表

使用`*`、`+`、`-`来定义无序列表

* 使用`*`定义无序列表

```
* 使用`*`定义无序列表
```

+ 使用`+`定义无序列表

```
+ 使用`+`定义无序列表
```

- 使用`-`定义无序列表

```
- 使用`-`定义无序列表
```

#### 有序列表

数字+点号`.`定义有序列表

1. a
2. b
3. c
4. d

```
1. a
2. b
3. c
4. d
```

#### ~~定义型列表(未测试通过)~~

定义型列表由名词和解释组成, 第一行写定义, 紧跟一行写解释.
解释的书写规则是`:`后跟一个`TAB`再接解释文字.

如:

MarkDown

:   轻量级文本标记语言，可以转换成html，pdf等格式(左侧有一个可见的冒号和四个不可见的空格)

### 引用嵌套

> 外层引用
> > 第二层引用
> > > 第三层引用
> > > 

```
> 外层引用
> > 第二层引用
> > > 第三层引用
```

### 图片插入

![美丽花儿](http://ww2.sinaimg.cn/large/56d258bdjw1eugeubg8ujj21kw16odn6.jpg "美丽花儿")

```
![图片文字](网址 "悬停标题")
```

图片同样适应于参考式定义, 参考链接的参考式定义.

### 内容目录

```
[TOC]
```

### ~~注脚(未测试通过)~~

```
使用 Markdown[^1]可以效率的书写文档, 直接转换成 HTML[^2], 你可以使用 Leanote[^Le] 编辑器进行书写。

[^1]:Markdown是一种纯文本标记语言

[^2]:HyperText Markup Language 超文本标记语言

[^Le]:开源笔记平台，支持Markdown和笔记直接发为博文
```

### LaTeX 公式

***详细公式参考:[math.meta.stackexchange.com](https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference)***

#### 行内公式 $

这是一个质能守恒公式:$E=mc^2$

```
这是一个质能守恒公式:$E=mc^2$
```

#### 整行公式 $$

$$\sum_{i=1}^n a_i=0$$
$$f(x_1,x_x,\ldots,x_n) = x_1^2 + x_2^2 + \cdots + x_n^2 $$
$$\sum^{j-1}_{k=0}{\widehat{\gamma}_{kj} z_k}$$

```
$$\sum_{i=1}^n a_i=0$$
$$f(x_1,x_x,\ldots,x_n) = x_1^2 + x_2^2 + \cdots + x_n^2 $$
$$\sum^{j-1}_{k=0}{\widehat{\gamma}_{kj} z_k}$$
```

### 流程图

***详细流程图参考:[http://flowchart.js.org/](http://flowchart.js.org/)***

```flow
st=>start: Start:>http://www.google.com[blank]
e=>end:>http://www.google.com
op1=>operation: My Operation
sub1=>subroutine: My Subroutine
cond=>condition: Yes
or No?:>http://www.google.com
io=>inputoutput: catch something...

st->op1->cond
cond(yes)->io->e
cond(no)->sub1(right)->op1
```

```
```flow
st=>start: Start:>http://www.google.com[blank]
e=>end:>http://www.google.com
op1=>operation: My Operation
sub1=>subroutine: My Subroutine
cond=>condition: Yes
or No?:>http://www.google.com
io=>inputoutput: catch something...

st->op1->cond
cond(yes)->io->e
cond(no)->sub1(right)->op1
```

### 表格

|标题|说明|
|:--|:--|
|标题1|说明1|
|标题2|说明2|

```
|标题|说明|
|:--|:--|
|标题1|说明1|
|标题2|说明2|
```

### 代码

#### 行内代码

将行内代码写在`号之间.

#### 多行代码

使用三个`号为开始和结束包裹代码段.

## Mermaid插件

[GitHub:knsv/mermaid](https://github.com/knsv/mermaid)






