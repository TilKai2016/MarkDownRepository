# Centos7搭建Docker环境

## 安装Docker

```
sudo yum install docker
```

## 安装pip

如果没有安装pip，首先安装pip：

```
# 安装epel yum源，该命令可以自动安装不同版本的epel，如CentOS6下执行安装的是epel6，CentOS7下执行时安装的是epel7
sudo yum -y install epel-release

# 安装python-pip
sudo yum install python-pip

# 升级pip
sudo pip install --upgrade pip
```

## 安装Docker-compose

```
sudo pip install -U docker-compose
```
