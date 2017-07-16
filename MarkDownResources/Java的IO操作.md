## 小点

[](http://baser.blog.51cto.com/4153192/1550508)
[](http://www.cnblogs.com/hqr9313/archive/2012/04/23/2467294.html)
[回复十六进制内容](http://blog.csdn.net/heart_1014/article/details/53606708)
[](http://www.jb51.net/article/18146.htm)

* in.read() != -1

```
int temp;
InputStream in = new InputStream(file);

while (temp = (in.read()) != -1) {
    System.out.print(Integer.toHexString(temp))
}
in.close();
```

