---
title: Vi(Vim)键盘图及其基本命令
date: 2016-12-21 18:02:46
tags: [Vim, Vi]
---

## VIM键盘图

![Vim键盘图](http://ohx3k2vj3.bkt.clouddn.com/Vim%E9%94%AE%E7%9B%98%E5%9B%BE.jpg)

<!-- more -->

## Vim的几种工作模式定义

### 便于理解的区分模式

**正常模式**
> 可以使用快捷键命令，或按<font color = "red">`:`</font>输入命令行

**插入模式**
> <font color = "red">`i`、`a`、`o`、`O`</font> -> <font color = "red">`插入模式`</font>

**可视模式**
> <font color = "red">`v`</font> -> <font color = "red">`可视模式`</font>
> <font color = "red">`V`</font> -> <font color = "red">`可视行模式`</font>
> <font color = "red">`ctrl+v`</font> -> <font color = "red">`可视块模式`</font>

**替换模式**
> <font color = "red">`R`</font> -> <font color = "red">`替换模式`</font>

### 绕口的vi的工作模式

**命令行模式 （command mode）**
> 控制屏幕光标的移动，字符、字或行的删除，移动复制某区段及进入Insert mode下，或者到 last line mode。

**插入模式（Insert mode）**
> 只有在 Insert mode 下，才可以做文字输入，按「ESC」键可回到命令行模式。

**底行模式（last line mode）**
> 将文件保存或退出 vi，也可以设置编辑环境，如寻找字符串、列出行号等。

## 常用命令

### 使用Vim打开文件

* <font color = "green">`vi filename`</font>：打开或新建文件，并将光标置于第一行首

* <font color = "red">`vi +n filename`</font>：打开文件，并将光标置于第n行首

* <font color = "red">`vi + filename`</font>：打开文件，并将光标置于最后一行首

* <font color = "red">`vi -r filename`</font>：如果在上次使用vi编辑时发生系统崩溃，恢复文件

* <font color = "red">`vi -R filename`</font>：以只读的方式打开文件，但可以强制保存

* <font color = "red">`vi -M filename`</font>：以只读的方式打开文件，且不可以强制保存

* <font color = "red">`vi file1....filen`</font>：打开多个文件，依次编辑，如`vi file0.txt file1.txt`，输入`:n`切换到下一个文件，输入`:N`切换到上一个文件

* <font color = "red">`vi +/String filename`</font>：打开文件，并将光标置于找到的第一个String行上，String区分大小写

### 命令行模式

#### 控制光标的移动的命令

* <font color = "red">`k`、`j`、`h`、`l`</font> -> <font color = "red">`上`、`下`、`左`、`右`</font>

* <font color = "red">`Ctrl+b`</font> -> <font color = "red">`向前翻一页(PageUp)`</font>

* <font color = "red">`Ctrl+f`</font> -> <font color = "red">`向后翻一页(PageDown)`</font>

* <font color = "red">`ctrl+d`</font> -> <font color = "red">`向前翻半页`</font>

* <font color = "red">`ctrl+u`</font> -> <font color = "red">`向后翻半页`</font>

* <font color = "red">`H`</font> -> <font color = "red">`光标置于当前屏幕最上行(Highest)`</font>

* <font color = "red">`nH`</font> -> <font color = "red">`光标置于当前屏幕的第n行(如2H将光标移到屏幕的第2行)`</font>

* <font color = "red">`M`</font> -> <font color = "red">`光标置于当前屏幕中间(Middle)`</font>

* <font color = "red">`L`</font> -> <font color = "red">`光标置于屏幕最后一行(Lowest)`</font>

* <font color = "red">`nL`</font> -> <font color = "red">`光标置于屏幕的倒数第n行(如3L将光标移到屏幕的倒数第3行)`</font>

* <font color = "red">`w`</font> -> <font color = "red">`在指定行内右移光标，到下一个字的开头`</font>

* <font color = "red">`e`</font> -> <font color = "red">`在指定行内右移光标，到一个字的末尾`</font>

* <font color = "red">`b`</font> -> <font color = "red">`在指定行内左移光标，到前一个字的开头`</font>

* <font color = "red">`0`</font> -> <font color = "red">`数字0，左移光标到本行的开头 `</font>

* <font color = "red">`^`</font> -> <font color = "red">`移动光标，到本行的第一个非空字符`</font>

* <font color = "red">`G`</font> -> <font color = "red">`光标移动到文章的最后`</font>

* <font color = "red">`gg`</font> -> <font color = "red">`光标移动到文章的开始`</font>

* <font color = "red">`nG`</font> -> <font color = "red">`光标移动到文章的第n行(如8G移动到文章的第8行)`</font>

* <font color = "red">`$`</font> -> <font color = "red">`右移光标，到本行的末尾`</font>


#### 替换和删除

* <font color = "red">`rc`</font> -> <font color = "red">`用c替换光标所指向的当前字符(r:replace)`</font>

* <font color = "red">`nrc`</font> -> <font color = "red">`用c替换包含光标指向字符向后的n个字符(如5rc用c替换包含光标指向字符的后5个字符，举例:有abcdefg这些字符，光标指向d，输入3rn，得到abcnnng)`</font>

* <font color = "red">`x`</font> -> <font color = "red">`删除光标所在位置的字符`</font>

* <font color = "red">`nx`</font> -> <font color = "red">`删除包含光标所在位置后面的n个字符(如3x删除光标所在位置后面的3个字符)`</font>

* <font color = "red">`X`</font> -> <font color = "red">`大写的X，删除光标所在位置(不包含光标所在位置的字符)前面的一个字符`</font>

* <font color = "red">`nX`</font> -> <font color = "red">`大写的X，删除光标所在位置(不包含光标所在位置的字符)前面的n个字符(如3X删除光标所在位置前面的3个字符)`</font>

* <font color = "red">`dd`</font> -> <font color = "red">`删除光标所在行，并去除空隙(删除的行可被p命令粘贴出来)`</font>

* <font color = "red">`ndd(或dnd)`</font> -> <font color = "red">`从光标所在行开始向后删除n行内容(包括光标所在行)，并去除空隙(如3dd删除3行内容，并去除空隙）`</font>

#### 复制和粘贴

**可被粘贴的原因**
> *从正文中删除的内容（如字符、字或行）并没有真正丢失，而是被剪切并复制到了一个内存缓冲区中。用户可将其粘贴到正文中的指定位置。*

* <font color = "red">`p`</font> -> <font color = "red">`小写字母 p，将缓冲区的内容粘贴到光标的后面`</font>

* <font color = "red">`P`</font> -> <font color = "red">`大写字母 P，将缓冲区的内容粘贴到光标的前面`</font>

**注意:**
>*如果缓冲区的内容是字符或字，直接粘贴在光标的前面或后面；如果缓冲区的内容为整行正文则粘贴在当前光标所在行的上一行或下一行。*

* <font color = "red">`yy`</font> -> <font color = "red">`复制当前行到内存缓冲区`</font>

* <font color = "red">`nyy`</font> -> <font color = "red">`复制n行内容到内存缓冲区(如5yy复制5行内容到内存缓冲区)`</font>

#### 搜索字符串

* <font color = "red">`/str1`</font> -> <font color = "red">`正向搜索字符串str1`</font>

* <font color = "red">`?str2`</font> -> <font color = "red">`反向搜索字符串str2`</font>

* <font color = "red">`n`</font> -> <font color = "red">`继续搜索，找出str1字符串下次出现的位置`</font>

#### 撤销和重复

* <font color = "red">`u`</font> -> <font color = "red">`撤消前一条命令的结果`</font>

* <font color = "red">`.`</font> -> <font color = "red">`重复最后一条修改正文的命令`</font>

#### 文本选中

 * <font color = "red">`v`</font> -> <font color = "red">`字符选中命令`</font>

* <font color = "red">`V`</font> -> <font color = "red">`行选中命令`</font>

* <font color = "red">`Ctrl + v`</font> -> <font color = "red">`块选中命令`</font>

### 插入模式

#### 进入插入模式

* <font color = "red">`i`</font> -> <font color = "red">`在光标左侧输入正文`</font>

* <font color = "red">`a`</font> -> <font color = "red">`在光标右侧输入正文`</font>

* <font color = "red">`o`</font> -> <font color = "red">`小写字母o，在光标所在行的下一行增添新行`</font>

* <font color = "red">`O`</font> -> <font color = "red">`大写字母O，在光标所在行的上一行增添新行`</font>

* <font color = "red">`I`</font> -> <font color = "red">`在光标所在行的开头输入正文`</font>

* <font color = "red">`A`</font> -> <font color = "red">`在光标所在行的末尾输入正文`</font>

#### 退出插入模式

* <font color = "red">`ESC`</font>键或组合键<font color = "red">`Ctrl+[`</font>

### 底行模式

#### 退出命令

* <font color = "red">`:q`</font> -> <font color = "red">`在未作修改的情况下退出`</font>

* <font color = "red">`:q!`</font> -> <font color = "red">`放弃所有修改，退出编辑程序`</font>

#### 行号和文件保存

* <font color = "red">`:n`</font> -><font color = "red">`将光标移到第n行`</font>

* <font color = "red">`:set nu`</font> -> <font color = "red">`显示行号`</font> 

* <font color = "red">`:set nonu`</font> -> <font color = "red">`取消行号显示`</font>

*底行模式下，可以规定命令操作的行号范围。数值用来指定绝对行号；字符“.”表示光标所在行的行号；字符“$”表示正文最后一行的行号；简单的表达式，例如“.+5”表示当前行往下的第 5 行。例如：*

* <font color = "red">`:.+5`</font> -> <font color = "red">`将光标移到当前行之后的第5行`</font>

* <font color = "red">`:$`</font> -><font color = "red">`将光标移到正文最后一行`</font>

*在底行模式下，允许从文件中读取正文，或将正文写入文件。例如：*

* <font color = "red">`:w`</font> -> <font color = "red">`将编辑的内容写入原始文件，用来保存编辑的中间结果`</font>

* <font color = "red">`:wq或:x`</font> -> <font color = "red">`将编辑的内容写入原始文件并退出编辑程序`</font>

* <font color = "red">`:w file`</font> -> <font color = "red">`将编辑的内容写入file文件，保持原有文件的内容不变`</font>

* <font color = "red">`:a,bw file`</font> -> <font color = "red">`将第 a 行至第 b 行的内容写入 file 文件 （如:1,.w file    将第 1 行至当前行写入 file 文件）`</font>

* <font color = "red">`:r file`</font> -> <font color = "red">`读取 file 文件的内容，插入当前光标所在行的后面`</font>

* <font color = "red">`:f file`</font> -> <font color = "red">`将当前文件重命名为 file`</font>

#### 字符串搜索

* <font color = "red">`:/str/`</font> -> <font color = "red">`正向搜索，将光标移到下一个包含字符串 str 的行`</font>

* <font color = "red">`:?str?`</font> -> <font color = "red">`反向搜索，将光标移到上一个包含字符串 str 的行`</font>

#### 正文替换

* <font color = "red">`:s/str1/str2/`</font> -> <font color = "red">`用字符串 str2 替换行中首次出现的字符串 str1`</font>

* <font color = "red">`:s/str1/str2/g`</font> -> <font color = "red">`用字符串 str2 替换行中所有出现的字符串 str1`</font>

* <font color = "red">`:.,$ s/str1/str2/g`</font> -> <font color = "red">`用字符串 str2 替换正文当前行到末尾所有出现的字符串 str1`</font>

* <font color = "red">`:1,$ s/str1/str2/g`</font> -> <font color = "red">`用字符串 str2 替换正文中所有出现的字符串 str1`</font>

* <font color = "red">`:g/str1/s//str2/g`</font> -> 功能同:<font color = "red">`1,$ s/str1/str2/g`</font>

*从上述替换命令可以看到：g 放在命令末尾，表示对搜索字符串的每次出现进行替换；不加 g，表示只对搜索字符串的首次出现进行替换；g 放在命令开头，表示对正文中所有包含搜索字符串的行进行替换操作。*

#### 删除正文

* <font color = "red">`:d`</font> -> <font color = "red">`删除光标所在行`</font>

* <font color = "red">`:3d`</font> -> <font color = "red">`删除第 3 行`</font>

* <font color = "red">`:.,$d`</font> -> <font color = "red">`删除当前行至正文的末尾`</font>

* <font color = "red">`:/str1/,/str2/d`</font> -> <font color = "red">`删除从字符串 str1 到 str2 的所有行`</font>

#### 恢复文件

*vi 在编辑某个文件时，会另外生成一个临时文件，这个文件的名称通常以 . 开头，并以 .swp 结尾。vi 在正常退出时，该文件被删除，若意外退出，而没有保存文件的最新修改内容，则可以使用恢复命令，也可以在启动 vi 时利用 -r 选项。*

* <font color = "red">`:recover`</font> -> <font color = "red">`恢复文件`</font>

#### 选项设置

*为控制不同的编辑功能，vi 提供了很多内部选项。利用 :set 命令可以设置选项。基本语法为：*

* <font color = "red">`:set option`</font> -> <font color = "red">`设置选项 option`</font>

常见的功能选项包括：
> `autoindent` -> 设置该选项，则正文自动缩进 
> `ignorecase` -> 设置该选项，则忽略规则表达式中大小写字母的区别 
> `number` -> 设置该选项，则显示正文行号 
> `ruler` -> 设置该选项，则在屏幕底部显示光标所在行、列的位置 
> `tabstop` -> 设置按 Tab 键跳过的空格数。例如 :set tabstop=n，n 默认值为 8 
> `mk` -> 将选项保存在当前目录的 .exrc 文件中 

#### shell切换

*在编辑正文时，利用 vi 底行模式下提供的shell切换命令，无须退出vi即可执行Linux命令*

* <font color = "red">`:! command`</font> -> <font color = "red">`执行完shell命令command后回到vi，如:! uname -a`</font>

*另外，在命令模式下，键入`K`(直接输入大写字母K，不带`:`) ，可命令 vi 查找光标所在单词的手册页，相当于运行man命令。*

## 参考资料
> **[Vi(Vim)键盘图及其基本命令](http://www.linuxidc.com/Linux/2015-07/119992.htm)**

## 深入探索

[把VIM打造成一个简单实用的IDE](http://www.linuxidc.com/Linux/2011-06/37032.htm)

[Vim学习指南](http://www.linuxidc.com/Linux/2013-08/89096.htm)

[快速学会 Vi编辑器](http://www.linuxidc.com/Linux/2013-08/88586.htm)

[强大的Vim 编辑器](http://www.linuxidc.com/Linux/2013-07/87544.htm)

[在CentOS 6.2上搭建Vim开发环境](http://www.linuxidc.com/Linux/2013-07/87363.htm)

[CentOS 5.4 安装高亮Vim编辑工具](http://www.linuxidc.com/Linux/2013-06/86508.htm)

[Vim技巧分享:C语言设置](http://www.linuxidc.com/Linux/2012-12/77124.htm)

[Ubuntu中设置Vim的行号](http://www.linuxidc.com/Linux/2012-12/75485.htm)

[Vim编辑器使用基础教程](http://www.linuxidc.com/Linux/2013-05/84031.htm)

[Vim使用笔记](http://www.cnblogs.com/jiqingwu/archive/2012/06/14/vim_notes.html)




