## 时间命令

```
# 查看当前时间
date
# 查看当前时间和时区
date -R
```

## 查看当前用户

```
who
```

## 查看线程

```
# 查看所有ssh连接
ps -aux | grep ssh
# 查看某个线程连接
ps -ef | grep collect
```

## 端口转发

```
ssh jieneng@113.208.115.190 -p 9022 -R 0.0.0.0:9999:localhost:9999
```
