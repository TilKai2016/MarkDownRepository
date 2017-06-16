## Java ClassLoad分析学习

### ClassLoader是做什么的

* Java的所有类都需要被加载到JVM中后才能运行, ClassLoader的作用之一就是将Class加载到JVM中;

> 类加载器加载的是被Java编译器编译后生成的字节码文件(.class文件), 类加载器读取字节码文件后，生成java.lang.Class类的一个实例, 每个这样的实例用来表示一个Java类。调用这个实例的getInstance()方法就可以创建出该类的一个对象.
> 基本上所有类加载器都是java.lang.ClassLoader类的一个实例.

* ClassLoader的另一个作用是审查每个类该由谁加载, 这种审查机制采用的是父优先策略, 即直到父加载器不能加载该Class时才自行加载;

* 除以上两个任务外, ClassLoader还有一个任务就是将Class字节码重新解析成JVM统一要求的对象格式;

### java.lang.ClassLoader类分析

* ClassLoader类是一个抽象类`public abstract class ClassLoader`, 给定一个二进制的name, ClassLoader将尝试定位或生成构成该类的定义的数据. 比较典型的策略是将name转变成文件名, 然后从文件系统中读取该名称的类文件.

* 每一个Class对象都包含定义这个对象的ClassLoader的引用.

* 但数组类的类对象不是由类加载器创建的, 而是根据Java运行时要求自动创建.

* 数组类调用Class.getClassLoader()返回的类加载器与其元素类型调用Class.getClassLoader返回的类加载器相同. 如果数组类的元素类型为基本类型, 则数组类没有类加载器.

* ClassLoader使用委派模式(或者叫双亲委派模式或者叫代理模式)搜索资源.

#### ClassLoader类中与加载类相关的方法

| 方法 | 说明 | 备注 |
:---|:---|:---
| public final ClassLoader getParent() | 返回该类加载器的父类加载器 | 如果此类加载器的父级是引导类加载器, 则此方法将在此类的实现中返回null |
| public Class<?> loadClass(String name) throws ClassNotFoundException | 用指定的二进制name加载类, 返回java.lang.Class类的实例 | loadClass()被JVM用来解析类引用, 相当于调用loadClass(name, false) |
| protected Class<?> findClass(String name) throws ClassNotFoundException | 用指定的二进制name查找类, 返回java.lang.Class类的实例 |  |
| protected final Class<?> findLoadedClass(String name) | 查找二进制名称为name的已经被加载过的类, 返回的结果是java.lang.Class类的实例 | 否则返回null |
| protected final Class<?> defineClass(String name, byte[] b, int off, int len) throws ClassFormatError | 把字节数组b中的内容转换成Java类, 返回根据字节数组b创建的java.lang.Class类的实例. | name为类的预期二进制名称, 如果不知道则为null |
| protected final void resolveClass(Class<?> c) | 链接指定的java类 |  |

## JVM预定义的三种类加载器

* 引导类加载器(bootstrap class loader)

> 用于加载java核心库, 引导类加载器是用原生代码实现的, 并不继承于java.lang.ClassLoader.
> 加载路径为System.getProperty("sun.boot.class.path")所指定的目录或jar文件.
> 注 : 原生代码的个人理解:Native Code, 编译后直接在操作系统中运行的, 并不是运行于JVM等虚拟机中, 例如C. 有人说它是用C++写的二进制代码, 嵌在JVM内核里面.

* 扩展类加载器(extensions class loader)

> 由SUN的ExtClassLoader(sun.misc.Launcher$ExtClassLoader)实现, 用于加载java扩展库, JVM的实现会提供一个扩展库目录, 扩展类加载器在该目录里查找并加载java类.
> 加载路径为System.getProperty("java.ext.dirs")所指定的目录或jar文件.
> 加载路径也可使用java -Djava.ext.dirs自行指定.

* 系统类加载器(system class loader)

> 由SUN的AppClassLoader(sun.misc.Launcher$AppClassLoader)实现, 其根据java应用的类路径(CLASSPATH)来加载类. 一般的, java应用的所有类都是由它完成加载的(即, 开发者可以直接使用系统类加载器). 可以通过ClassLoader.getSystemClassLoader()来获取它.
> 加载路径为System.getProperty("java.class.path")所指定的目录或jar文件.

注: 
> 特殊的, 除上述三种外还有线程上下文类加载器. 
> 而且, 开发人员可以通过继承java.lang.ClassLoader类的方式实现自己的类加载器.
> ExtClassLoader和AppClassLoader在JVM启动后, 会在JVM中保存一份, 并且在程序运行中无法改变其搜索路径. 如果想在运行时从其他搜索路径加载类, 就要产生新的类加载器.

类加载器的树状图为:

```
        引导类加载器
            ^
            |
        扩展类加载器
            ^
            |
        系统类加载器
            ^
            |
        自定义加载器A
            ^
            |
        自定义加载器Aa
```

## 代码演示获取类加载器的树状结构

```
public class ClassLoaderTree {

    public static void main (String[] args) {

        System.out.println("引导类加载器的加载路径是: " + System.getProperty("sun.boot.class.path"));
        System.out.println("扩展类加载器的加载路径是: " + System.getProperty("java.ext.dirs"));

        ClassLoader loader = ClassLoaderTree.class.getClassLoader();

        while (loader != null) {
            System.out.println("类加载器: " + loader.toString());

            loader = loader.getParent();
        }
    }
}
```

每个Java类都维护着一个指向定义它的类加载器的引用. 使用getClassLoader()方法可以获取该引用.

输出结果:

```
引导类加载器的加载路径是: /Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home/jre/lib/resources.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home/jre/lib/rt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home/jre/lib/sunrsasign.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home/jre/lib/jsse.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home/jre/lib/jce.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home/jre/lib/charsets.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home/jre/lib/jfr.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home/jre/classes:/var/folders/s5/9s7t58250qg5c39nhhfpghf80000gn/T/jrebel6-temp/jrebel.jar
扩展类加载器的加载路径是: /Users/tilkai/Library/Java/Extensions:/Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home/jre/lib/ext:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java
类加载器: sun.misc.Launcher$AppClassLoader@18b4aac2
类加载器: sun.misc.Launcher$ExtClassLoader@3b41e5ad
```

## 类加载器的委托(代理)模式

* 什么是委托模式?

> 委派模式指某个特定的类加载器在接到加载类的请求时, 首先将加载任务委托给父类加载器, 依次向上递归, 如果父类加载器可以完成类加载任务, 就成功返回; 只有父类加载器无法完成此加载任务时, 才自己去加载.

* 为什么要使用委托模式进行类加载工作?

> 防止内存中出现多份名称相同的java.lang.Class的类的实例.
> 这里涉及到JVM如何判断两个Java类是相同的. JVM判断两个Java类是否相同不仅要看类的全名是否相同, 还要看加载此类的类加载器是否一样.

## 类的加载过程

由于类的加载采用委托模式, 即类加载器会递归向上代理给上层类加载器来尝试完成类加载工作. 这意味着真正完成类的加载工作的类加载器和启动这个加载过程的类加载器很可能不是同一个.

> 真正完成类的加载工作是通过调用 defineClass来实现的;
> 而启动类的加载过程是通过调用 loadClass来实现的;
> defineClass被称为类的定义加载器(defining loader);
> loadClass被称为初始加载器;
> JVM判断两个类是否相同, 使用的是类的定义加载器. 也就是说, 哪个类加载器启动了类的加载过程并不重要, 重要的是最终定义这个类的加载器;
> 一个类的定义加载器(defining loader)是它引用的其他类的初始加载器(Initiating loader);
> `loadClass()`抛出的是`ClassNotFoundException`异常, `defineClass`抛出的是`NoClassDefFoundError`异常;
> 类加载器在成功加载某个类之后, 会把得到的java.lang.Class类的实例缓存起来. 下次再请求加载该类的时候, 类加载器会直接使用缓存的类的实例, 而不会尝试再次加载. 也就是说, 对于一个类加载器实例来说, 相同全名的类只加载一次, 即loadClass方法不会被重复调用.

## Class.forName()方法

`public static Class<?> forName(String className) throws ClassNotFoundException`返回与给定字符串名称的类或接口相关联的Class对象, 相当于`public static Class<?> forName(String className, boolean initialize, ClassLoader loader) throws ClassNotFoundException`的第二个参数设置为true.

Class.forName()常用来加载数据库驱动, 如: `Class.forName("org.apache.derby.jdbc.EmbeddedDriver").newInstance()`用来加载 Apache Derby数据库的驱动.

谈到Class.forName()方法, 需要提一下类的隐式装载和显式装载. 以及newInstance()方法和new关键字的区别. 以及getMethod()方法. 反射原理等. 

todo 待整理yml


### 服务提供者接口(Service Provider Interface, SPI)

常见SPI:JDBC,JCE,JNDI,JAXP,JBI等.

参考及引用:

[深入探讨 Java 类加载器](https://www.ibm.com/developerworks/cn/java/j-lo-classloader/)
[关于Java类加载双亲委派机制的思考(附一道面试题)](http://www.cnblogs.com/lanxuezaipiao/p/4138511.html)
[深度分析Java的ClassLoader机制（源码级别）](http://www.hollischuang.com/archives/199)
[JAVA的newInstance()和new的区别(JAVA反射机制，通过类名来获取该类的实例化对象)](http://blog.csdn.net/guoxiaolongonly/article/details/51279625)

