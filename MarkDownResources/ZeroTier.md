# 搭建zeroTier

## 参考
[Running ZeroTier One Inside a Docker Container](https://support.zerotier.com/hc/en-us/articles/115001080508-Running-ZeroTier-One-Inside-a-Docker-Container)

## docker-compose方式

```
version: "2"

services:
  zerotier:
    image: zerotier/zerotier-containerized
    container_name: zerotier
    restart: always
    network_mode: "host"
    devices:
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
      - SYS_ADMIN
    volumes:
      - ./config:/var/lib/zerotier-one
```

## docker方式

```
docker pull zerotier/zerotier-containerized
```

```
docker run --device=/dev/net/tun --net=host --cap-add=NET_ADMIN --cap-add=SYS_ADMIN -d -v /var/lib/zerotier-one:/var/lib/zerotier-one -n zerotier-one zerotier/zerotier-containerized
```

## 命令

```
# zerotier加入某个Network
docker exec zerotier /zerotier-cli join ${Network}
```

```
# zerotier离开某个Network
docker exec zerotier /zerotier-cli leave ${Network}
```


