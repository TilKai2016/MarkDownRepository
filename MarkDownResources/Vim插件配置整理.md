# Vim插件配置整理

## 安装插件管理工具Vundle

[Vunble](https://github.com/VundleVim/Vundle.vim)是vim的插件管理工具，它能够搜索、安装、更新和移除vim插件，再也不需要手动管理vim插件。

<1>. Home/~目录新建(若没有).vim目录和.vimrc文件

```
mkdir .vim
touch .vimrc
```

<2>. 安装Vunble 

```
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
```

<3>. 在.vimrc配置文件中添加vundle支持

```
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
```

但实际上我是添加一个~/.vimrc.bundles文件来保存所有插件的配置，必须在~/.vimrc文件加入以下代码片段：

```
if filereadable(expand("~/.vimrc.bundles"))
source ~/.vimrc.bundles
endif
```

而~/.vimrc.bundles文件内容必须包含：

```
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
```

复制[samlaudev/ConfigurationFiles](https://github.com/samlaudev/ConfigurationFiles/blob/master/vim/vimrc.bundles)的~/.vimrc.bundles的代码直接使用:

```
if &compatible
  set nocompatible
end

filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage Vundle
Bundle 'gmarik/vundle'

" Define bundles via Github repos
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

if filereadable(expand("~/.vimrc.bundles.local"))
  source ~/.vimrc.bundles.local
endif

filetype on
```

注意，本人使用时发现直接全部使用以上Bundle会报错，而且，很多插件并不适应个人使用，所以，建议研究一下各个插件干嘛用的，有针对性的添加。

## 安装插件

部分插件可参考[将你的Vim 打造成轻巧强大的IDE](http://www.open-open.com/lib/view/open1429884437588.html)

bundle分为三类，比较常用就是第二种：

1. 在Github vim-scripts 用户下的repos,只需要写出repos名称
2. 在Github其他用户下的repos, 需要写出”用户名/repos名”
3. 不在Github上的插件，需要写出git全路径

将安装的插件在~/.vimrc配置，但是我是将插件配置信息放在~/.vimrc.bundles:

```
" Define bundles via Github repos
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

现在打开vim，运行`:BundleInstall`或在shell中直接运行`vim +BundleInstall +qall`完成插件安装。

注意，安装过程中尽量避免对该窗口操作，如全屏切换，鼠标滚轮滚动等，都应该尽量避免，否则可能会导致错误。

### 装完后可能会有版本过低的提示

下面解决版本过低问题，以及中间可能出现的错误

<1>. 报如下错误:

```
vim +BundleInstall +qall
YouCompleteMe unavailable: requires Vim 7.4.143+
Press ENTER or type command to continue
```

这是因为vim版本过低，更新Vim版本:

```
brew install macvim --with-override-system-vim
```

之后运行下面命令，连接到/Application:

```
brew linkapps macvim
```

最后在.zshrc配置文件中使用别名来使用更新后的vim:

```
#setup macvim alias
alias vim='/usr/local/opt/macvim/MacVim.app/Contents/MacOS/Vim'
```

<2>. 在执行<1>中`brew install macvim --override-system-vim`命令的过程中，假如有以下提示出现:

```
xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory '/Library/Developer/CommandLineTools' is a command line tools instance
```

说明Xcode路径错误。

解决办法，执行下面的代码，切换到你正在用的Xcode安装路径下:

```
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer/
```

再次执行`brew install macvim --with-override-system-vim`以及之后的步骤。

### 以上都成功后使用vim打开文件可能会显示下面提示

错误提示:

```
YouCompleteMe unavailable no module named future
```

进入`.vim/bundle/YouCompleteMe`路径，执行:

```
git submodule update --init --recursive
```

修复成功。

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

