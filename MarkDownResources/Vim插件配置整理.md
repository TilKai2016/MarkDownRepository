## macOS安装Vim最新版

参考:
[所需即所获：像 IDE 一样使用 vim](https://github.com/yangyangwithgnu/use_vim_as_ide/blob/master/README.md)
[macOS安装Vim8.0](http://www.jianshu.com/p/919b5e9057c1)

* 下载最新vim

```
git clone git@github.com:vim/vim.git
```

* 加载配置，进入`git clone`下来的vim目录下，顺序执行下述命令：

```
./configure --with-features=huge --enable-pythoninterp=yes  --enable-cscope --enable-fontset --enable-perlinterp --enable-rubyinterp --with-python-config-dir=/usr/lib/python2.7/config --prefix=/usr/local
make
make install
```

为取代系统自带的7.x版本，需修改`.bash_profile(zsh是.zshrc)`，

```
vim ~/.bash_profile // 如果用的是zsh就是 vim ~/.zshrc
```

加入下面配置：

```
alias vim='/usr/local/bin/vim'
```

然后source一下让配置生效:

```
source ~/.bash_profile
```

此时执行`vim`，显示的是8.x版本，此时安装完成。

## 安装插件管理工具Vundle

[Vunble](https://github.com/VundleVim/Vundle.vim)是vim的插件管理工具，它能够搜索、安装、更新和移除vim插件，再也不需要手动管理vim插件。

### .vim && .vimrc

* Home/~目录新建(若没有).vim目录和.vimrc文件

```
mkdir .vim
touch .vimrc
```

### 安装Vunble 

* 下载VundleVim

```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

* 在`.vimrc`中添加相关配置信息

```
" vundle 环境设置，添加对Vundle的支持
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
" vundle 管理的插件列表必须位于 vundle#begin() 和 vundle#end() 之间
call vundle#begin()
" 使用Plugin ''添加插件
" 插件列表结束
call vundle#end()
filetype plugin indent on
```

* 添加完成后，在vim中执行`:PluginInstall`，开始自动安装。

* 要卸载插件，先在 .vimrc 中注释或者删除对应插件配置信息，然后在 vim 中执行`:PluginClean`。

* 插件更新频率较高，差不多每隔一个月你应该看看哪些插件有推出新版本，批量更新，只需执行`:PluginUpdate`。


```
# 部分插件
Bundle 'christoomey/vim-run-interactive'
Bundle 'Valloric/YouCompleteMe'
Bundle 'croaky/vim-colors-github'
Bundle 'danro/rename.vim'
Bundle 'majutsushi/tagbar'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim'
Bundle 'pbrisbin/vim-mkdir'
Bundle 'scrooloose/syntastic'
Bundle 'slim-template/vim-slim'
Bundle 'thoughtbot/vim-rspec'
Bundle 'tpope/vim-bundler'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'
Bundle 'vim-ruby/vim-ruby'
Bundle 'vim-scripts/ctags.vim'
Bundle 'vim-scripts/matchit.zip'
Bundle 'vim-scripts/tComment'
Bundle "mattn/emmet-vim"
Bundle "scrooloose/nerdtree"
Bundle "Lokaltog/vim-powerline"
Bundle "godlygeek/tabular"
Bundle "msanders/snipmate.vim"
Bundle "jelera/vim-javascript-syntax"
Bundle "altercation/vim-colors-solarized"
Bundle "othree/html5.vim"
Bundle "xsbeats/vim-blade"
Bundle "Raimondi/delimitMate"
Bundle "groenewege/vim-less"
Bundle "evanmiller/nginx-vim-syntax"
Bundle "Lokaltog/vim-easymotion"
Bundle "tomasr/molokai"
Bundle "klen/python-mode"
```

部分插件可参考[将你的Vim 打造成轻巧强大的IDE](http://www.open-open.com/lib/view/open1429884437588.html)

bundle分为三类，比较常用就是第二种：

1. 在Github vim-scripts 用户下的repos,只需要写出repos名称
2. 在Github其他用户下的repos, 需要写出”用户名/repos名”
3. 不在Github上的插件，需要写出git全路径

### .vimrc配置文件中部分语法

```
See :help internal-variables

It lists the following types:

                (nothing) In a function: local to a function; otherwise: global 
buffer-variable    b:     Local to the current buffer.                          
window-variable    w:     Local to the current window.                          
tabpage-variable   t:     Local to the current tab page.                        
global-variable    g:     Global.                                               
local-variable     l:     Local to a function.                                  
script-variable    s:     Local to a :source'ed Vim script.                     
function-argument  a:     Function argument (only inside a function).           
vim-variable       v:     Global, predefined by Vim.
```

### 配置NERD Tree快捷键

~/.vimrc文件中配置NERD Tree，设置NERDTree快捷键:

```
nmap <F5> :NERDTreeToggle<cr>
```

NERD Tree提供了一些常用快捷键:

>通过hjkl来移动光标
>o打开关闭文件或目录，如果想打开文件，必须光标移动到文件名
>t在标签页中打开
>s和i可以水平或纵向分割窗口打开文件
>p到上层目录
>P到根目录
>K到同目录第一个节点
?P到同目录最后一个节点

