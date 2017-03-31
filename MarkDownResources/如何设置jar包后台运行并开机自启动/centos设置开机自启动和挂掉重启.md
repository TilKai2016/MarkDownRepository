# centos设置开机自启动和挂掉重启

参考于jescp、某次数据采集程序

编辑wdog.sh文件，设置jar文件的开机自启动脚本，

将collect-server.service放到/usr/lib/systemd/system/下面，

设置开机自启动：

```
systemctl enable collect-server.services
```
