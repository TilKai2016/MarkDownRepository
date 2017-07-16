## 官网及介绍

> Gradle构建工具是任务驱动型的构建工具，并且可以通过各种Plugin扩展功能以适应各种构建任务。

> 采用约定优于配置的原则，最简单方式是使用一个默认的目录结构。当然目录结构是可以自己修改的。

[gradle.org](https://gradle.org/)

[Gradle文档, 强推](https://docs.gradle.org/current/dsl/)

## 安装gradle

gradle在jre基础上运行, 确保安装gradle之前已经安装配置了java环境(`java-version`)

```
brew update && brew install gradle
```

## 如何基于一个空仓库构建基于gradle的工程

### 将wrapper(包管理器)添加到项目

***环境: 假如在GitHub上创建了一个Repository, 只有仓库名称、REDMINE.md、.gitignore文件, 在此基础上如何构建一个基于gradle的工程?***

* 在clone的工程仓库根目录下执行:

```
gradle wrapper --gradle-version 4.0
# 或者
gradle wrapper --gradle-version=4.0 --distribution-type=bin
```

`4.0`是gradle的版本号, 可以替换为任意一个[gradle.org/distributions](http://services.gradle.org/distributions/)中的版本号, `--distribution-type`指定依赖4.0版本的那个分发版本.

> 执行前仓库的内容:

```
➜  aggregator-data-collector git:(master) ✗ ls -Alh
total 16
drwxr-xr-x  14 tilkai  staff   476B  6 20 10:54 .git
-rw-r--r--   1 tilkai  staff   326B  6 20 10:15 .gitignore
-rw-r--r--   1 tilkai  staff    27B  6 20 09:53 README.md
```

> 执行后仓库的内容:

```
➜  aggregator-data-collector git:(master) ✗ ls -Alh
total 40
drwxr-xr-x  14 tilkai  staff   476B  6 20 10:56 .git
-rw-r--r--   1 tilkai  staff   326B  6 20 10:15 .gitignore
drwxr-xr-x   4 tilkai  staff   136B  6 20 10:56 .gradle
-rw-r--r--   1 tilkai  staff    27B  6 20 09:53 README.md
drwxr-xr-x   3 tilkai  staff   102B  6 20 10:56 gradle
-rwxr-xr-x   1 tilkai  staff   5.2K  6 20 10:56 gradlew
-rw-r--r--   1 tilkai  staff   2.2K  6 20 10:56 gradlew.bat
```

```
➜  gradle git:(master) ✗ tree
.
|____wrapper
| |____gradle-wrapper.jar
| |____gradle-wrapper.properties
```

可以看到, `gradle wrapper --gradle-version 4.0`执行后达到了将wrapper(包管理器)添加到Gradle项目的目的.

### 新建各配置文件

#### gradle-wrapper.properties(无需新建, 上一步已经创建.)

当执行`./gradlew build`命令时, 该配置文件会检查正确版本的gradle是否已被安装.

```
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-3.1-bin.zip
```

#### settings.gradle

项目根目录下执行`touch settings.gradle`,

```
➜  aggregator-data-collector git:(master) ✗ ls -Alh
total 40
drwxr-xr-x  14 tilkai  staff   476B  6 20 11:19 .git
-rw-r--r--   1 tilkai  staff   326B  6 20 10:15 .gitignore
drwxr-xr-x   4 tilkai  staff   136B  6 20 10:56 .gradle
-rw-r--r--   1 tilkai  staff    27B  6 20 09:53 README.md
drwxr-xr-x   3 tilkai  staff   102B  6 20 10:56 gradle
-rwxr-xr-x   1 tilkai  staff   5.2K  6 20 10:56 gradlew
-rw-r--r--   1 tilkai  staff   2.2K  6 20 10:56 gradlew.bat
-rw-r--r--   1 tilkai  staff     0B  6 20 11:19 settings.gradle
```

settings.gradle用于组合Project中的各个Module.

其中的一种语法是:

```
incloud 'Module-name'
```

#### gradle.properties

项目配置文件, 该文件包含整个项目的配置信息, 默认为空, 可以添加各种属性值, (各个模块)build.gradle中可以引用其中定义的属性值, 个人理解它为一个常量池, 方便统一管理.

比如我可以定义当前软件版本, Maven仓库地址等.

#### build.gradle

##### buildscript

```
buildscript {
    ext {
    
    }
    
    repositories {
        maven {
            url ''
        }
    }
    
    dependencies {
        classpath ''
    }
}
```

buildscript是一个方法, 接受一个closure.

此处配置了三个closure(闭包), 分别是ext、repositories、dependencies; 同时repositories的内部又嵌套了maven;

详细的内容参考https://docs.gradle.org/current/dsl/.


## 对现有基于Gradle Wrapper构建的项目进行升级

* 通过运行 wrapper task, 将依赖的Gradle升级到指定版本.(task指的是一系列的命令, 如下是其中一种.)

```
./gradlew wrapper --gradle-version=4.0 --distribution-type=bin
```


