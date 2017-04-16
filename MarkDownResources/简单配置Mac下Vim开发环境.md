---
title: 简单配置Mac下Vim开发环境
date: 2016-12-21 23:38:47
tags: [Vim, Terminal]
---

# 简单配置Mac下Vim开发环境
<!-- more -->
本人最终使用的[适合Java开发的.vimrc](https://github.com/wsdjeg/DotFiles)这一配置，在此简单介绍几种可能以后需要用到的配置，以备不时之需。
现有配置还不尽人意，有新的配置方案再行更新！
## Mac下Vim简单配置(暂时未使用)
<1>. 查看`~/.vimrc`文件是否存在，如果存在，备份之；
<2>. 执行`cp /usr/share/vim/vimrc ~/.vimrc`；
<3>. 编辑`~/.vimrc`文件，在文件尾添加如下代码块:

```
syntax on
set nocompatible
set number
set autoindent
set smartindent
set showmatch
set hls
set incsearch
set shiftwidth=4
set ts=4
set ruler
set mousehide
set mouse=v
set encoding=utf-8
set fileencodings=utf-8,chinese,latin-1
set visualbell
if has("gui_running")
-1set cursorline
-1colorscheme murphy
-1set background=dark
-1set guifont=YaHei\ Consolas\ Hybrid:h14
-1highlight Cursorline guibg=grey15
-1set guioptions-=T
-1set fileformat=unix
-1set lines=49
-1set columns=140
-1set mouse=a
endif
```
简单的配置完成！

## 适合Java开发的.vimrc配置(暂时配合Solarized配色方案使用)
[适合Java开发的.vimrc配置GitHub链接](https://github.com/wsdjeg/DotFiles)

<1>. 首先clone项目:

```
git clone https://github.com/wsdjeg/DotFiles.git
```
<2>. 赋予`install.sh`执行权限并将该执行文件与vim做关联:

```
chmod +x install.sh
./install.sh vim  # or ./install.sh nvim
```

`./install.sh vim`的执行结果如下:

```
Move ~/.vimrc to ~/.vimrc_back
Linking ~/.vim -> /Users/tilkai/GitHub_Tools/DotFiles/config/nvim
```

<3>. 使用vim打开任意文本文件，此时将会执行:

```
vi vimTest0.txt
:!git clone https://github.com/Shougo/dein.vim /Users/tilkai/.cache/vimfiles/repos/github.com/Shougo/dein.vim
Cloning into '/Users/tilkai/.cache/vimfiles/repos/github.com/Shougo/dein.vim'...
remote: Counting objects: 3847, done.
remote: Compressing objects: 100% (72/72), done.
remote: Total 3847 (delta 27), reused 0 (delta 0), pack-reused 3762
Receiving objects: 100% (3847/3847), 732.36 KiB | 120.00 KiB/s, done.
Resolving deltas: 100% (2203/2203), done.
Checking connectivity... done.

Press ENTER or type command to continue
```

以上配置完成！

## Terminal并Vim、ls配置Solarized配色方案
[参考:在 Mac OS X 终端里使用 Solarized 配色方案](http://www.vpsee.com/2013/09/use-the-solarized-color-theme-on-mac-os-x-terminal/)

<1>. GitHub下载源码:

```
git clone git://github.com/altercation/solarized.git
```

<2>. 本人只是使用了其提供的Terminal配色方案，目录如下:

```
tilkai @ localhost in ~/GitHub_Tools/solarized/osx-terminal.app-colors-solarized on git:master x [23:22:36] 
$ ls -l
total 40
-rw-r--r--  1 tilkai  staff  3330 12 21 22:45 README.md
-rw-r--r--  1 tilkai  staff  5478 12 21 22:45 Solarized Dark ansi.terminal
-rw-r--r--  1 tilkai  staff  5504 12 21 22:45 Solarized Light ansi.terminal
drwxr-xr-x  5 tilkai  staff   170 12 21 22:45 xterm-256color
```
双击两个`.terminal`文件导入到Terminal配置中，在终端--》偏好设置中对Dark配置主题进行微调:
①. 文本、粗体文本改为绿色；
②. 光标透明度改为80%

配色方案配置完成！

最终配置如下:
![TerminalConfig](http://ohx3k2vj3.bkt.clouddn.com/TerminalConfig.png)
---
![TerminalConfig0](http://ohx3k2vj3.bkt.clouddn.com/TerminalConfig0.png)
---
![TerminalConfig1](http://ohx3k2vj3.bkt.clouddn.com/TerminalConfig1.png)

(如需完全配置Solarized配色方案，参考给定原创blog链接！)

    补充其他好的复杂配置:
    [https://github.com/geekan/source-insight-vim](https://github.com/geekan/source-insight-vim)


