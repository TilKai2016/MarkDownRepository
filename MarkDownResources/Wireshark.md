## Wireshark无法监听端口的权限问题

问题描述:

选择捕获接口时, 遇到提示:

```
you don't have permission to capture on that device mac
```

或者提示:

```
The capture session could not be initiated on interface 'en0' (You don't have permission to capture on that device).
```

解决方法:
> 1. 查看当前用户, 执行 : `whoami`
> 2. 进入`dev`文件目录 : `cd /dev`
> 3. 将当前用户添加到bp*的admin组中 : `sudo chown 当前用户:admin bp*`

## 使用方法

### 表达式

```
tcp.port == 2404
```


