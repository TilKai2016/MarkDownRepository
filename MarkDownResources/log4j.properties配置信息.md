## log4j简单了解

参考[Java Logger(java日志)](http://blog.csdn.net/carefree31441/article/details/4678914)

log4j有三个主要的点：

`Logger`: 负责处理日志记录的大部分操作。

`Appender`: 负责控制日志的输出。

`Layout`: 负责日志输出的格式化。

log4j的由高到低的几个日志级别：

|Java Log Level|ODL Log Level|Meaning|
|---|---|---|
|OFF|N/A|关闭日志输出。|
|FATAL|INCIDENT_ERROR|输出知名错误级别日志，最高的日志级别。|
|ERROR|ERROR|输出错误级别日志，高于warn级别。|
|WARN|WARNING|输出警告级别日志，高于info级别。|
|INFO|NOTIFICATION|输出消息日志，高于debug级别。|
|DEBUG|TRACE|调试级别，所有日志级别中最低。|

参考[Oracle - Logging configuration](https://docs.oracle.com/cd/E57471_01/bigData.100/admin_bdd/src/radm_logging_config.html)

`Logger`将只输出高于或等于指定级别的信息。

java中定义一个Logger的语法：

```
Logger logger = Logger.getLogger("JcmsApp.class");
```


## 默认的log4j.properties配置

```
log4j.rootLogger=ERROR,stdout
log4j.logger.com.endeca=INFO
# Logger for crawl metrics
log4j.logger.com.endeca.itl.web.metrics=INFO

log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%p\t%d{ISO8601}\t%r\t%c\t[%t]\t%m%n
```

## log4j.rootLogger语法块

* `log4j.rootLogger=INFO, stdout`的语法为:

```
log4j.rootLogger = [level], appenderName1, appenderName2, ...
```

> `level`:定义日志记录的优先级，分为`OFF`、`FATAL`、`ERROR`、`WARN`、`INFO`、`DEBUG`、`ALL`或`自定义级别`    。
> log4j建议只使用四个级别，优先级由高到低为`ERROR`、`WARN`、`INFO`、`DEBUG`。通过`rootLogger`的级别定义，可以控制应用程序中相应级别的日志信息的开关，如定义`INFO`级别，则应用程序中所有`DEBUG`级别的日志信息将不被打印出来。
> `appenderName`指定日志信息输出的目的地，可以同时制定多个输出目的地，如`log4j.rootLogger=INFO, stdout, file, ODL`

## log4j.appender.{appenderName}语法块

**以下`log4j.appender.XXX`配置块都要基于`log4j.rootLogger= [level], X1, X2, X3, ...`配置块。**

### appender接口的实现类

* `log4j.appender.X1=org.apache.log4j.ConsoleAppender`

> 使用用户指定的布局，输出日志事件到System.out或System.err。默认目标为System.out。

* `log4j.appender.X2=org.apache.log4j.DailyRollingFileAppender`

> 扩展FileAppender，每天产生一个日志文件。

* `log4j.appender.X3=org.apache.log4j.RollingFileAppender`

> 扩展FileAppender，文件大小大道指定尺寸的时候产生一个新的文件。

* `log4j.append.X4=org.apache.log4j.FileAppender`

> 把日志事件写入一个文件。

*  `log4j.append.X5=org.apache.log4j.WriterAppender`

> 根据用户的选择，把日志信息以流的格式写入到Writer或OutputStream。
 
* `log4j.appender.X6=org.apache.log4j.net.SMTPAppender`

> 当特定的日志事件发生时，一般指发生错误或者重大错误时，发送一封邮件。

* `log4j.appender.X7=org.apache.log4j.net.SocketAppender`

> 给远程日志服务器(通常是网络套接字节点)发送日志事件(LoggingEvent)对象。

* `log4j.appender.X8=org.apache.log4j.net.SocketHubAppender`

> 给远程日志服务器群组(通常是网络套接字节点)发送日志事件(LoggingEvent)对象。

* `log4j.appender.X9=org.apache.log4j.net.SyslogAppender`

> 给远程异步日志记录的后台守护进程(deamon)发送消息。

* `log4j.appender.X10=org.apache.log4j.net.TalnetAppender`

> 一个专用于向只读网络套接字发送消息的log4j appender。

### ConsoleAppender选项属性

```
# ConsoleAppender实现类
log4j.appender.X1=org.apache.log4j.ConsoleAppender

# -Threshold = DEBUG：指定日志消息的输出最低层次
log4j.appender.X1.Threshold=DEBUG
# -ImmediateFlush = TRUE：默认为true，所有消息会被立即输出
log4j.appender.X1.ImmediateFlush=TRUE
# -Target = System.err：默认值System.out，输出到控制台(Err为红色，out为黑色)
log4j.appender.X1.Target=System.err
```

### FileAppender选项属性

```
#FileAppender实现类
log4j.appender.X2=org.apache.log4j.FileAppender

# -Threshold = INFO：指定日志消息的输出最低层次
log4j.appender.X2.Threshold=INFO
# -ImmediateFlush = TRUE：默认值为true，所有消息会被立即输出
log4j.appender.X2.ImmediateFlush=TRUE
# -File = C:\log4j.log：指定消息输出到C:\log4j.log文件
log4j.appender.X2.File=C:\log4j.log
# -Append = FALSE：默认值是true，将消息追加到指定文件中，false指将消息覆盖指定的文件内容
log4j.appender.X2.Append=true
# -Encoding = UTF-8：指定文件编码格式
log4j.appender.X2.Encoding=UTF-8
```

### DailyRollingFileAppender选项属性

```
#DailyRollingFileAppender实现类
log4j.appender.X3=org.apache.log4j.DailyRollingFileAppender

# -Threshold = WARN：指定日志消息的输出最低层次
log4j.appender.X3.Threshold=WARN
# -ImmediateFlush = TRUE：默认值为true，所有消息会被立即输出
log4j.appender.X3.ImmediateFlush=TRUE
# -File = C:\log4j.log：指定消息输出到C:\log4j.log
log4j.appender.X3.File=C:\log4j.log
# -Append = FALSE：默认值为true，将消息追加到指定文件中，false指将消息覆盖指定文件中的内容
log4j.appender.X3.Append=TRUE
# --DatePattern='.'yyyy-ww：每周滚动一次文件，即每周产生一个新的文件，还可以设置为以下参数：
# '.'yyyy-MM：每月
# '.'yyyy-ww：每周
# '.'yyyy-MM-dd：每天
# '.'yyyy-MM-dd-a：每天两次
# '.'yyyy-MM-dd-HH：每小时
# '.'yyyy-MM-dd-HH-mm：每分钟
log4j.appender.X3.DatePattern='.'yyyy-MM-dd
# -Encoding = UTF-8：指定文件编码格式
log4j.appender.X3.Encoding=UTF-8
```

### RollingFileAppender选项属性

```
#RollingFileAppender实现类
log4j.appender.X4=org.apache.log4j.DailyRollingFileAppender

# -Threshold = ERROR：指定日志消息的输出最低层次
log4j.appender.X4.Threshold=ERROR
# -ImmediateFlush = TRUE：默认true，所有消息会被立即输出
log4j.appender.X4.ImmediateFlush=TRUE
# -File = C:\log4j.log：指定消息输出到C:\log4j.log
log4j.appender.X4.File=C:\log4j.log
# -Append = FALSE：默认为true，将消息追加到指定文件中，false指将消息覆盖指定文件中的内容
log4j.appender.X4.Append=TRUE
# -MaxFileSize = 100KB：后缀可以为KB、MB、GB，日志文件到达该大小时，将自动滚动。
log4j.appender.X4.MaxFileSize=200KB
# -MaxBackupIndex = 2：指定可以产生的滚动文件的最大数
log4j.appender.X4.MaxBackupIndex=7
# -Encoding = UTF-8：指定文件编码格式
log4j.appender.X4.Encoding=UTF-8
```

## Layout

### Layout子类

```
# 以HTML表格形式布局
log4j.appender.X.Layout=org.apache.log4j.HTMLLayout
# 灵活指定布局模式
log4j.appender.X.Layout=org.apache.log4j.PatternLayout
# 包含日志信息的级别和信息字符串
log4j.appender.X.Layout=org.apache.log4j.SimpleLayout
# 包含日志产生的时间、线程、类别等等信息
log4j.appender.X.Layout=org.apache.log4j.TTCCLayout 
# 以XML形式布局
log4j.appender.X.Layout=org.apache.log4j.xml.XMLLayout
```

### HTMLLayout选项属性

```
# 指定布局为HTMLLayout模式
log4j.appender.X.Layout=org.apache.log4j.HTMLLayout

# -LocationInfo = TRUE:默认值false,输出Java文件名称和行号
log4j.appender.X.Layout.LocationInfo=TRUE
# -Title=Struts Log Message:默认值 Log4J Log Messages
log4j.appender.X.Layout.Title=My Log Message
```

### PatternLayout选项属性

```
# 指定布局为PatternLayout模式
log4j.appender.X.Layout=org.apache.log4j.PatternLayout

# -ConversionPattern = %m%n:格式化指定的消息
log4j.appender.X.Layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss,SSS} %-5p [%C{1}.%M(%L)] - %m%n
```

### XMLLayout选项属性

```
# 指定布局为XMLLayout模式
log4j.appender.X.Layout=org.apache.log4j.XMLLayout

# -LocationInfo = TRUE:默认值false,输出java文件名称和行号
log4j.appender.X.Layout.LocationInfo=TRUE
```

## 转换字符表

|字符|功能|
|---|---|
|-X|X信息输出时左对齐|
|%p|输出日志信息优先级，即DEBUG，INFO，WARN，ERROR，FATAL|
|%d|输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式，比如：%d{yyy MMM dd HH:mm:ss,SSS}，输出类似：2002年10         月18日 22：10：28，921|
|%r|输出自应用启动到输出该log信息耗费的毫秒数|
|%c|输出日志信息所属的类目，通常就是所在类的全名|
|%t|输出产生该日志事件的线程名|
|%l|输出日志事件的发生位置，相当于%C.%M(%F:%L)的组合,包括类目名、发生的线程，以及在代码中的行数。|
|%x|输出和当前线程相关联的NDC(嵌套诊断环境),尤其用到像java servlets这样的多客户多线程的应用中。|
|%%|输出一个"%"字符|
|%F|输出日志消息产生时所在的文件名称|
|%L|输出代码中的行号|
|%m|输出代码中指定的消息,产生的日志具体信息|
|%n|输出一个回车换行符，Windows平台为"/r/n"，Unix平台为"/n"输出日志信息换行|
|%20c|指定输出category的名称，最小的宽度是20，如果category的名称小于20的话，默认的情况下右对齐。|
|%-20c|指定输出category的名称，最小的宽度是20，如果category的名称小于20的话，"-"号指定左对齐。|
|$.30c|指定输出category的名称，最大的宽度是30，如果category的名称大于30的话，就会将左边多出的字符截掉，但小于30的话也不会有空格。|
|%20.30c|如果category的名称小于20就补空格，并且右对齐，如果其名称长于30字符，就从左边较远输出的字符截掉。|


