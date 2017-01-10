# Dokcer+SS+KCP搭建梯子

本次梯子搭建使用了[DigitalOcean](https://m.do.co/c/90e360179dca)的VPS服务器，操作系统选择了Ubuntu，分别尝试了Docker+SS+KCP的组合以及BBR+Docker+SS+KCP的组合，下面将会分别介绍这两种的搭建过程。
**注意**，使用BBR进行TCP加速需要升级内核版本的操作，Docker的安装配置应该在BBR安装成功后进行，这点很重要，因为内核升级后可能导致Docker不能运行(暂时的个人理解)。

参考：

[docker compose官网](https://docs.docker.com/compose/install/)

## Docker+SS+KCP组合的环境配置

### 安装Docker

**部分参考[GitHub](https://github.com/cndocker/kcptun-socks5-ss-server-docker)**

### Docker源
>官网安装地址:

```
curl -Lk https://get.docker.com/ | sh
```

>阿里云安装地址:

```
curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
```
### 安装

#### 基于docker的cndocker/kcptun-socks5-ss-server服务端安装方法

```
docker pull cndocker/kcptun-socks5-ss-server:latest
```

#### 下载镜像导入

```
wget --no-check-certificate https://github.com/cndocker/kcptun-socks5-ss-server-docker/raw/master/images/docker-kcptun-socks5-ss-server.tar
```

镜像导入命令

```
docker load < docker-kcptun-socks5-ss-server.tar
```

### 不使用Docker-compose的启动方式(暂未使用)

启动命令:

```
docker run -ti --name=kcptun-socks5-ss-server \
-p 8388:8388 \
-p 8388:8388/udp \
-p 34567:34567/udp \
-p 45678:45678/udp \
-e RUNENV=kcptunsocks-kcptunss \
-e SS_SERVER_ADDR=0.0.0.0 \
-e SS_SERVER_PORT=8388 \
-e SS_PASSWORD=password \
-e SS_METHOD=aes-256-cfb \
-e SS_DNS_ADDR=8.8.8.8 \
-e SS_UDP=true \
-e SS_ONETIME_AUTH=true \
-e SS_FAST_OPEN=true \
-e KCPTUN_LISTEN=45678 \
-e KCPTUN_SS_LISTEN=34567 \
-e KCPTUN_SOCKS5_PORT=12948 \
-e KCPTUN_KEY=password \
-e KCPTUN_CRYPT=aes \
-e KCPTUN_MODE=fast2 \
-e KCPTUN_MTU=1350 \
-e KCPTUN_SNDWND=1024 \
-e KCPTUN_RCVWND=1024 \
-e KCPTUN_NOCOMP=false \
cndocker/kcptun-socks5-ss-server:latest
```

### 变量说明

| 变量名 | 默认值 | 描述 |
| :----------------- |:--------------------:| :---------------------------------- |
| RUNENV | kcptunsocks-kcptunss | 运行模式（见备注1）：kcptunsocks-kcptunss, kcptunsocks, kcptunss, ss |
| SS_SERVER_ADDR | 0.0.0.0 | 提供服务的IP地址，建议使用默认的0.0.0.0 |
| SS_SERVER_PORT | 8388 | SS提供服务的端口，TCP和UDP协议。 |
| SS_PASSWORD | password | 服务密码 |
| SS_METHOD | aes-256-cfb | 加密方式，可选参数：table, rc4, rc4-md5, aes-128-cfb, aes-192-cfb, aes-256-cfb, bf-cfb, camellia-128-cfb, camellia-192-cfb, camellia-256-cfb, cast5-cfb, des-cfb, idea-cfb, rc2-cfb, seed-cfb, salsa20, chacha20 and chacha20-ietf |
| SS_TIMEOUT | 600 | 连接超时时间 |
| SS_DNS_ADDR | 8.8.8.8 | SS服务器的DNS地址 |
| SS_UDP | true | 开启SS服务器 UDP relay |
| SS_ONETIME_AUTH | true | 开启SS服务器 onetime authentication. |
| SS_FAST_OPEN | true | 开启SS服务器 TCP fast open. |
| KCPTUN_LISTEN | 45678 | kcptunsocks模式提供服务的端口，UDP协议 |
| KCPTUN_SS_LISTEN | 34567 | kcptunss模式提供服务的端口，UDP协议 |
| KCPTUN_SOCKS5_PORT | 12948 | socks5透明代理端口，不需要对外开放。 |
| KCPTUN_KEY | password | 服务密码 |
| KCPTUN_CRYPT | aes | 加密方式，可选参数：aes, aes-128, aes-192, salsa20, blowfish, twofish, cast5, 3des, tea, xtea, xor |
| KCPTUN_MODE | fast2 | 加速模式，可选参数：fast3, fast2, fast, normal |
| KCPTUN_MTU | 1350 | MTU值，建议范围：900~1400 |
| KCPTUN_SNDWND | 1024 | 服务器端发送参数，对应客户端rcvwnd |
| KCPTUN_RCVWND | 1024 | 服务器端接收参数，对应客户端sndwnd |

![变量说明](http://ohx3k2vj3.bkt.clouddn.com/DockerSS%E5%8F%98%E9%87%8F%E8%AF%B4%E6%98%8E.jpeg)

### 运行参数说明

```
* kcptunsocks-kcptunss：同时提供kcptun & socks5（路由器kcptun插件）与kcptun & ss(手机ss客户端)服务，kcptun & socks5服务的对应端口是“KCPTUN_LISTEN”，kcptun & ss服务的SS对应端口“SS_SERVER_PORT”、kcp端口对应“KCPTUN_SS_LISTEN”。
* kcptunsocks：提供kcptun & socks5（路由器kcptun插件）服务，kcptun & socks5服务的对应端口是“KCPTUN_LISTEN”。
* kcptunss：提供kcptun & ss(手机ss客户端)服务，SS对应端口“SS_SERVER_PORT”、kcp端口对应“KCPTUN_SS_LISTEN”。
* ss：提供shadowsocks-libev服务，SS对应端口“SS_SERVER_PORT”。
```

### 手机客户端kcp参数设置

```
--crypt ${KCPTUN_CRYPT} --key ${KCPTUN_KEY} --mtu ${KCPTUN_MTU} --sndwnd ${KCPTUN_RCVWND} --rcvwnd ${KCPTUN_SNDWND} --mode ${KCPTUN_MODE}
```

可参看[android-Shadowsocks设置](http://www.jianshu.com/p/172c38ba6cee)

### 带宽计算方法

```
简单的计算带宽方法，以服务器发送带宽为例，其他类似：
服务器发送带宽=SNDWND*MTU*8/1024/1024=1024*1350*8/1024/1024≈10M
```

## 使用Docker-compose启动服务

### Docker-compose安装:

```
curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

[Docker-compose官网](https://docs.docker.com/compose/install/)

### 将配置文件夹上传到服务器:

```
# 在本地执行下面命令，其中cp为拷贝，-r表示递归上传，ss为待上传的文件
scp -r ss root@46.101.186.119:
```

### 运行docker-compose配置文件

```
# 如无法运行，增加执行权限(up为启动)
docker-compose up
```

### 配置文件内容说明

<1>. docker-compose.yml

```
root@ubuntu-512mb-fra1-01:~/ss# cat docker-compose.yml 
version: '2'
services:
  ss:
    restart: always
    image: cndocker/kcptun-socks5-ss-server
    ports:
      - 23456:23456
      - 23456:23456/udp
      - 34567:34567/udp
    env_file:
      - ss.env
    container_name: ss
```
①. 指定镜像；
②. 配置docker端口映射到服务器端口；
③. `ports`中的属性对应`ss.env`中配置的`SS_SERVER_PORT`(ss暴露的TCP端口和UDP端口)和`KCPTUN_SS_LISTEN`(kcp暴露的UDP端口)
④. 指定env配置文件；
⑤. 指定容器名称；

```
root@ubuntu-512mb-fra1-01:~/ss# cat ss.env 
RUNENV=kcptunss
SS_SERVER_PORT=23456
SS_PASSWORD=1048576
KCPTUN_SS_LISTEN=34567
KCPTUN_KEY=1048576
```

①. 指定运行模式
②. ss服务端口号(容器内)
③. ss服务密码
④. kcp端口号(容器内)
⑤. kcp服务密码

#### docker-compose命令说明

docker-compose up --help : 查看docker-compose命令
docker-compose up : 启动docker-compose服务
docker-compose down : 停止docker-compose服务
docker-compose up -d : 后台启动docker-compose服务

#### docker部分命令

docker ps : 查看有哪些docker容器正在运行
docker logs ss : 查看某个容器(如ss容器)的运行日志

#### 查看端口暴露情况

lsof -i:端口号 查看端口号是否已暴露，有列表表示已经暴露
[Linux端口以及防火墙端口的查看命令](http://blog.csdn.net/nemo2011/article/details/7362071)

## Google BBR加速SS的BBR+Docker+SS+KCP的组合

本次执行是在Ubuntu4和8的内核版本上进行的，其他版本不一定适配，建议先在测试环境尝试。

参考了以下的链接[Shadowsocks教程:TCP加速 BBR 一键安装](https://shadowsocks.info/tcp-bbr/)，该链接还提供了其他Linux系统的BBR安装教程。

### 安装4.9的内核版本，依次执行以下两步操作：

```
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.9-rc8/linux-image-4.9.0-040900rc8-generic_4.9.0-040900rc8.201612051443_amd64.deb
dpkg -i linux-image-4.9.0*.deb
```

### 删除其他版本的内核

```
dpkg -l|grep linux-image
apt-get remove 列表中其他内核的名称
```

### 更新 grub 系统引导文件并重启

```
update-grub
reboot
```

### 开启BBR

```
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
```

### 保存生效

```
sysctl -p
```

### 查看是否配置启动成功

执行`sysctl net.ipv4.tcp_available_congestion_control`，如果结果中有`bbr`, 则证明你的内核已开启`bbr`，
执行`lsmod | grep bbr`, 看到有`tcp_bbr`模块即说明`bbr`已启动成功。

### 在SSR配置成功的基础上拉取Docker仓库

#### 更新源并采用下面的方式安装docker

```
apt-get update
apt-get install docker.io
```

### 后续步骤
此时就可以按照 Docker+SS+KCP组合中的步骤继续安装并启动Docker-SS服务了，

(开始的点:"基于docker的cndocker/kcptun-socks5-ss-server服务端安装方法")

## 在路由器配置科学上网

[参考网件 R6300 V2 刷梅林固件](http://broccoliii.me/2016/08/09/R6300_v2_Merlin/)

坑1:刷梅林时在ASUS登录页面默认用户名密码为admin和admin，如果该用户名密码的组合不正确，建议再尝试admin和password的组合，以及adsl和ads11234的组合


```
WPA 密钥应为 8~63 个字符的字符串或 64 个十六进制字符。如果您将本字段保留空白，系统将会指定 00000000 作为您的通关密语。
```


