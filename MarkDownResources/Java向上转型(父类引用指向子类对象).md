## 什么是向上转型

* 所谓向上转型, 其实就是父类引用指向子类对象.

* 向上转型(Upcasting)将是一直被允许的, 而向下转型(Downcasting)涉及到类型检查, 可能抛出`ClassCastException`异常.

* 通常,如果先定义向上转型, 再对转型后的父类引用做生成父类引用的子类对象的向下转型, 是允许的, 例如:

```
Animal animal = new Dog();
Dog dog = (Dog)animal();
``` 

因为animal的runtime type为Dog, 虽然其static type为Animal.

* 但是, 如果对一个没有经过向上转型的引用做向下转型, 你会得到一个`java.lang.ClassCastException`的异常. 例如:

```
Animal animal = new Animal();

Dog dog = (Dog) animal();
```

因为animal的runtime type为animal.

* 为了避免可能出现的向下转型的错误, 可以在做向下转型之前, 进行 instanceof 的判断处理.

例如:

```
Animal animal = new Animal();

if (animal instanceof Dog) {
    Dog dog = (Dog) animal;
}
```

## 当父类引用指向了子类对象...

父类Person:

```
/**
 * @author tilkai
 */
public class Person {

    private String name = "Person";

    private int personAge = 40;

    public void sayHello() {
        System.out.println("I am Person, Hello!");
    }

    public void getName() {
        System.out.println("My name is : " + name);
    }

    public void getPersonAge() {
        System.out.println("My Age is : " + personAge);
    }
}
```

子类Wang:

```
/**
 * @author tilkai
 */
public class Wang extends Person {

    private String name = "Wang";

    private int sunAge = 20;

    @Override
    public void sayHello() {

        System.out.println("I am Wang, Hello!");
    }

    public void wangSay() {
        System.out.println("Wang said is me!");
    }

    @Override
    public void getName() {
        System.out.println("my name is : " + name);
    }

    public void getSunAge() {
        System.out.println("sun age is : " +sunAge);
    }

    public static void main (String[] args) {
        Person person = new Wang();

        person.sayHello();
        person.getName();
        person.getPersonAge();

        Wang wang = (Wang) person;

        wang.sayHello();
        wang.wangSay();
        wang.getName();
        wang.getPersonAge();
        wang.getSunAge();
    }
}
```

运行结果:

```
I am Wang, Hello!
my name is : Wang
My Age is : 40
I am Wang, Hello!
Wang said is me!
my name is : Wang
My Age is : 40
sun age is : 20
```

* 父类引用指向子类对象的实现方式其实是*动态绑定*, 这正是java多态性的一种体现;

* 在运行时, 将根据父类引用的具体指向来获取方法和变量值, 即所调用的方法, 变量如果被子类覆盖了, 则实际调用的是父类引用所指向的子类的实现;

* 子类做向上转型后的父类引用不能调用父类中为定义的方法或变量, 可以理解为这些定义被隐藏起来了;

* 当向上转型后的父类引用执行向下转型后(Dog向上转型后的Animal不能向下转型为Cat, 否则编译不通过, 提示`Inconvertible type`), 被隐藏的属性定义又可以呗重新使用;

* 通过向上转型, 实现了面向父类编程;



