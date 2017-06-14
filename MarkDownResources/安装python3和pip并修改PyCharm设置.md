## 同时安装Python2.7和Python3

参考：
[Mac OSX 正确地同时安装Python 2.7 和Python3](http://www.jianshu.com/p/51811fa24752)
[Mac OSX 正確地同時安裝 Python 2.7 和 Python3](https://stringpiggy.hpd.io/mac-osx-python3-dual-install/#step3)

实际操作：

```
# 安装Python2.7.X
brew install python --with-brewed-openssl
# 安装Python3
brew install python3 --with-brewed-openssl
# 更新升级Python3
brew upgrade python3
```

## 安装 virtualenv virtualenvwrapper

关于virtualenv、virtualenvwrapper:

* virtualenv用于创建独立的Python环境，多个Python相互独立，互不影响，它能够：

> 在没有权限的情况下安装新套件

> 不同应用可以使用不同的套件版本

> 套件升级不影响其他应用。

执行下面命令安装：

```
sudo pip install virtualenv virtualenvwrapper
```

安装完成后未设置环境变量，需要后期进行设置

## 安装pip：

```
sudo easy_install pip
```

参考[mac 安装pip](http://www.jianshu.com/p/f4b78fc5b163)

## PyCharm修改使用的python版本和解释器版本：

```
# 修改Python版本
PyCharm->Prefenences->Build,Execution,Deployment->Console->Python Console->Python interpreter

# 修改解释器版本
PyCharm->Prefenences->Project:scrapy->Project Interpreter
```

