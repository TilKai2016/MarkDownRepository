---
title: 简单SVG学习整理
date: 2016-12-16 18:36:31
tags: SVG
---

# 简单SVG语法
<!-- more -->
---

## 圆形、矩形、椭圆等简单代码

* 圆形简单代码

```
<circle cx = "50" cy = "40" r = "40" style = "stroke : green; stroke-width : 4; stroke-opaciry : 0.9; fill : yellow; fill-opacity : 1; opacity : 1;" />
```
**关键字**
1. cx、cy: 圆心x轴、y轴坐标;
2. r: 圆半径;
3. stroke: 边框颜色(也可使用RGB);
4. stroke-width: 边框宽度;
5. stroke-opacity: 边框透明度,数值范围从0-1;
6. fill: 填充色;
7. fill-opacity: 填充透明度;
8. opacity: 整体透明度;

* 圆角矩形简单代码

```
<rect x = "50" y = "20" rx = "20" ry = "20" width = "300" hieght = "100" style = "fill : rgh(0,0,255); stroke-width : 3; stroke : rgb(0,0,0); fill-opacity : 0.1; strok-opacity : 0.9;" />
```
**关键字**
1. rx、ry: 矩形圆角x轴、y轴方向的半径;

* 椭圆简单代码

```
<ellipse cx = "200" cy = "80" rx = "100" ry = "50" .../>
```

---

## 线、文本与多边形

* 直线

```
<line x1 = "0" y1 = "0" x2 = "200" y2 = "200" />
```
**关键字**
1. x1、y1: 直线起始x、y轴坐标;
2. x2、y2: 直线终止x、y轴坐标;

* 折线

```
<polyline points = "20,20 40,25 60,40 80,120 120,140 200,180"
style = "fill : none; stroke : black; stroke-wiedth : 3;" />
```
**关键字**
1. points 定义折线段的端点坐标，坐标与坐标间用空格分隔;
2. fill : none; 定义折线交叉后的封闭区域不会填充颜色;

* 文本

```
<text x = "80" y = "100" fill = "blue" transform = "rotate(20 150,120)">多行文本 - 第零行
  <tspan x = "100" y = "120" transform = "rotate(20 150,120)">多行文本 - 第一行</tspan>
  <tspan x = "100" y = "140" transform = "rotate(20 150,120)">多行文本 - 第二行</tspan>
</text>
```
**关键字**
1. transform = "rotate(20 150,120)" 定义以150,120坐标点为旋转中心,旋转20度.

* 多边形

```
<polygon points = "240,48 352,396 58,180 422,180 128,396" style = "fill : green; stroke : red; stroke-width : 3; fill-rule : nonzero;"></polygon>
```
**关键字**
1. fill-rule : 定义填充规则,用于判断一个点是否在图形内部的算法,可选值为nonzero,evenodd,inherit;

## 简单路径

* path

```
<path d="M600 0 L500 200 L700 200 Z"/>
```

**关键字**
1. M : 移动画笔到指定坐标，不绘制;
2. L : 从当前点绘制直线到指定点;
3. Z : 从当前点做到起点的直线，构成闭合路径;