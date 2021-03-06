## Idea常用设置

### JRebel

以下关于JRebel的配置可能仅应用于Spring boot + JRebel实现热部署，并不适应所有的项目配置。

#### 安装JRebel

`Preferences`-`Plugins`搜索`JRebel`安装`JRebel for IntelliJ`

`Preferences`-`JRebel`-`Chane lisense`更改激活信息

`Preferences`-`JRebel`-`Startup`勾选`Run via IDE`

#### 配置JRebel使用

JRebel需要项目编译后才能启用，所以针对Idea需要进行自动编译或快捷键编译的设置。

介绍使用宏进行自定保存编译的快捷键设置：

* `Edit`-`Macros`-`Start Macro Recording`开始宏录制

* 进行宏的录制`Ctrl + s`(保存)-`Ctrl + F9`(编译)

* `Edit`-`Macros`-`Stop Macro Recoriding`结束宏录制

给该宏进行命名，如`JRebel-autoSaveAndMake`

`Preferences`-`Keymap`-`Macros`-`JRebel-autoSaveAndMake`右键`Add Keyboard Shortcut`键入`Ctrl+s`

启用该配置，此时自动保存编译的宏生效。

#### 使用JRebel启动Spring boot

`Application.java`右键`Debug with JRebel`

启动工程后，每次修改或添加删除方法之后，只需使用快捷键`Ctrl+s`就可以实现热部署。

### Working directory设置

通过设置`Working directory`选项, 可以达到更改`System.getProperty("user.dir")`的目的.

#### 设置方式

`Select Run/Debug Configuration` -> `Edit Configurations...` -> `Working directory`

### Idea中Maven使用

* 要将Maven项目打成可执行`Jar`包, 需要在`pom.xml`中定义`mainClass`标签,如:

```
<archive>
    <manifest>
        <mainClass>com.tilkai.xxxx.XxxxApp</mainClass>
    </manifest>
</archive>
```

* 被依赖模块需要在`Maven Projects` -> `Lifecycle` -> `install`

* 被打包模块需要在`Maven Projects` -> `Lifecycle` -> `package`

## Idea DataGrip

## 常用命令


* 创建和生成建表语句(DDL)

* 颜色区分

* 生成数据模型



