# Java中比较对象的equals方法

## Object.java中的equals()

作为所有类的最终基类，Object.java类中equals()方法的行为是比较引用，该方法应该被具体的实现类所覆盖：

```
public boolean equals(Object obj) {
    return (this == obj);
}
```

* equals()方法在非空对象引用上实现等价关系；
* 对于equals()的等价比较，应该具有以下几种特征：

> 自反性；
> 对称性；
> 传递性；
> 一致性；
> x.equals(null)必然返回false；

可参考effective java第三章。

## AbstractList.java


