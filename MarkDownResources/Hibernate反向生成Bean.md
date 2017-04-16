---
title: Hibernate反向生成Bean
date: 2016-12-25 18:44:17
tags: [Hibernate, Bean]
---

## Idea建立带有Hibernate的java工程,使用 Database建立数据库连接;
<!-- more -->
在`view`-`Tool Windows`-`Persistence`中右键项目名称,选择`Generate Persistence Mapping`-`By DataBase Schema`
## Import Database Schema界面
`Choose Data Source`、`Package`写入数据源和要导出bean的包目录,选择待生成的表,勾选`Generate Column Properties`和`Generate Separate XML per Entity`
完成反向生成bean的操作。