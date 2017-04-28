---
title: SpringDataJPA学习整理
date: 2016-12-18 23:33:49
tags: [SpringDataJPA, JPA, Spring]
---

 ## Spring Data JPA基本概述
 >基于ORM框架、JPA规范封装的JPA应用框架, 内部提供了增删改查等常用功能且易于扩展.
 >关于ORM框架, 是指的关系映射模型, 像Hibernate、Mybatis等都属于ORM框架.
 >JPA规范需要ORM框架来做实现.
 
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Spring Data提供了一整套数据访问层(DAO)的解决方案, 致力于减少数据访问层的开发量.它使用Repository接口为基础, 所有继承该接口的Interface都被Spring管理. 该接口作为标识接口, 用来控制domain模型.
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Spring Data可以让我们只定义接口, 只要遵循Spring Data规范, 就无需写实现类.
 
 ## Spring Data JPA接口
 ![JPAInterface](http://ohx3k2vj3.bkt.clouddn.com/JPAInterface.png)
 ### Repository
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Repository<T, ID>是最顶层接口, 是一个空接口, 目的是为了统一所有的Repository的类型, 且能让组件扫描时自动识别.
 
 ### CrudRepository
 Repository的子接口, 提供CRUD操作功能.
 
 ### PagingAndSortingRepository
 CrudRepository的子接口, 添加了分页、排序功能.
 
 ### JpaRepository
 PagingAndSortingRepository的子接口, 增加批处理功能.
 
 ### JpaSpecificationExecutor
 用来做复杂查询的接口.
 
 ## Repository层简单的代码实现
 
 ```
 /**
  * Created by Tilkai on 16/12/15.
  * 继承CrudRepository接口,
  * <参数为实体名称, 主键类型>
  */
 public interface EvaluateHistoryRepository extends CrudRepository<EvaluateHistory, Long> {
 }
 ```
 
 ## Server层代码实现
 ### Server层接口
 ```
 import com.tsingyun.pvdm.center.domain.pvdm.EvaluateHistory;
 
 import java.util.List;
 
 /**
  * Created by Tilkai on 16/12/15.
  */
 public interface EvaluateHistoryService {
 
     EvaluateHistory saveEvaluateHistory(EvaluateHistory evaluateHistory);
 
     Iterable<EvaluateHistory> saveEvaluateHistorys(Iterable<EvaluateHistory> evaluateHistoryIterable);
 }
 ```
 
 ### Server层实现类
 
 ```
 import com.tsingyun.pvdm.center.collect.server.repo.EvaluateHistoryRepository;
 import com.tsingyun.pvdm.center.domain.pvdm.EvaluateHistory;
 import org.springframework.beans.factory.annotation.Autowired;
 import org.springframework.stereotype.Service;
 
 /**
  * Created by Tilkai on 16/12/15.
  */
 @Service
 public class EvaluateHistoryServiceImpl implements EvaluateHistoryService {
 
     @Autowired
     EvaluateHistoryRepository evaluateHistoryRepository;
 
     @Override
     public EvaluateHistory saveEvaluateHistory(EvaluateHistory evaluateHistory) {
         return evaluateHistoryRepository.save(evaluateHistory);
     }
 
     @Override
     public Iterable<EvaluateHistory> saveEvaluateHistorys(Iterable<EvaluateHistory> evaluateHistoryIterable) {
         return evaluateHistoryRepository.save(evaluateHistoryIterable);
     }
 }
 ```

## JPA实体管理器
<!--more -->
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;实体管理器可以理解为数据库表和实体之间交互的桥梁，通过调用实体管理器相关方法可以把实体持久化到数据库中，也可以把数据库中记录打包成实体对象。
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;实体具有生命周期，这个生命周期指实体从创建到销毁在实体管理器方法管理下呈现出的状态。
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;下图描述了实体生命周期以及实体管理器如何控制各个状态的实体:
![实体状态转换图](http://ohx3k2vj3.bkt.clouddn.com/SpringDataJpa1.png)
实体生命周期包括四个状态:
> 新建状态
> 托管状态
> 游离状态
> 删除状态

即，**插入**一条记录，需要新建一个实体并向实体执行赋值操作，调用persist()方法，提交事务；
**修改**实体有两种方法，一个是利用之前已经执行过添加或修改操作的实体(通常处于游离状态的实体)，调用merge()方法，并提交事务；另一个是通过条件查询出实体，修改实体属性，提交事务；
**删除**操作要先根据条件查询出实体，调用remove()方法，提交事务；

## 简单代码实现增删改查

UserRepository接口:

```
public interface UserRepository extends JpaRepository<User, Integer> {
    public void add(User user); // 添加
    public User update(User user); // 修改
    public User addOrUpdate(User user); // 添加或修改
    public void delete(User user); // 删除
    public User findOne(Integer id); // 查询单个实体
    public List<User> findAll(); // 查询所有实体
}
```
UserRepository实现类:

```
/**
 *使用Impl结尾，JPA会自动发现并使用该实现类
 */
public class UserRepositoryImpl {

    //使用@PersistenceContext注解注入实体管理器
    @PersistenceContext
    private EntityManager entityManager;

    @Transactional
    public void add(User user) {
        entityManager.persist(user);
    }

    @Transactional
    public User update(){
        User userUpdate = entityManager.find(User.class, user.getId());
        userUpdate.setAddress(user.getAddress);
        userUpdate.setPhone(user.getPhone);

        return userUpdate;
    }

    @Transactional
    public User addOrUpdate(User user){
        return entityManager.merge(user);
    }

    @Transactional
    public void delete(User user){
        entityManager.remove(user);
    }

    public User fidOne(Integer id){
        return entityManager.find(User.class, id);
    }

    public List<User> finddAll(){
        String queryStr = "select u from User u";
        Query query = entityManager.createQuery(queryStr);
        return query.getResultList();
    }
}
```

## 如何将实体属性分散到两个(或以上)表格中存放

<1>. 实体类加`@SecondaryTables`注解

```
@Entity
@Table(name = "t_user")
@SecondaryTables({
    @SecondaryTable(name = "t_address", pkJoinColums = @PrimaryKeyJoinColum(name = "address_id"))
})
public class User{

    @Id
    @GenerateValue
    @Column(name = "id")
    private Integer id;

    // ...

    // 定义分散表格字段
    @Column(table = "t_address", name = "street")
    private String street;

    // ...
}
```

### 内嵌实体

<1>. 使用@Embeddable注解，标识一个实体类，使该类可嵌入其他实体中；
<2>. 在使用@Embeddable标识实体的实体中，使用Embedded注解引入实体；
<3>. 可重命名实体的属性名称，如嵌入Comment实体：

```
@Embedded
@AttributeOverrides({
    @AttributeOverride(name = "title", column = @Column(name = "newTitle")),
    @AttributeOverride(name = "content", column = @Column(name = "newContent"))
})
private Comment comment;
```

## 一对一、一对多、多对多映射
### 一对一映射
如:
主表为Person实体，从表为Address实体

```
public class Persion {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    //...

    /**
     * @JoinColumn定义主从表字段关联:
     *     name属性定义主表外键字段
     *     referencedColumnName属性定义从表外键(一般为从表主键)
     * 如果是多字段关联，可以用:
     *     @JoinColumns(value = {@JoinColumn(), @JoinColumn(), ...})
     * 如果不指明@JoinColumn，默认是主键关联，且在主表中生成与从表主键相同名称、类型的外键；
     */
    @OneToOne
    @JoinColumn(name = "addressId", referencedColumnName = "id")
    private Address address;
}
```

### 一对多映射
方法1. 使用中间表进行一对多关联:

```
@Entity
public class Depart {
    // ...

    // @JoinTable的name为中间表的名称，
    // joinColumns配置关系拥有者Depart实体与中间表的关联关系，(Depart表的dId关联中间表的departId)
    // inverseJoinColumns配置关系被拥有者Employee实体与中间表的关联关系，(Employee表的eId关联中间表的employeeId)
    // 注意，关系被拥有者为List，
    @OneToMany
    @JoinTable(name = "depart_employee",
        joinColumns = @JoinColumn(name = "departId", referencedColumnName = "dId"),
        inverseJoinColumns = @JoinColumn(name = "employeeId", referencedColumnName = "eId")
    )
    private List<Employee> employees;

    // ...
}
```

方法2. 不使用中间表的外键关联:

```
public class Depart {
    // ...

    @OneToMany
    @JoinColumn(name = "departId", referencedColumnName = "id")
    private List<Employee> employees;

    // ...
}
```

### 多对多映射

与一对多使用中间表的配置基本类似，修改`@OneToMany`为`@ManyToMany`

### 关于级联问题
主表的增删操作是否对从表进行相应的增删操作，称之为级联问题。
例如通过在`@OneToOne`注解中增加cascade配置项配置

```
/**
 * cascade = ...的可选值
 * ① CascadeType.DETACH
 * ② CascadeType.MERGE
 * ③ CascadeType.PERSIST
 * ④ CascadeType.REFRESH
 * ⑤ CascadeType.REMOVE 删除主表记录时将从表关联记录一并删除
 * ⑥ CascadeType.ALL 所有操作都要级联从表操作
 * 可选多个值:@OneToOne(cascade = {CascadeType.DETACH, CascadeType.MERGE})
 */

@OneToOne(cascade = ...)
```

### 懒加载
如果查询主实体信息时，不希望查询出子实体的内容，而是在需要的时候去数据库中获取，此时可以使用懒加载
JPA配置懒加载使用`fetch = FetchType.LAZT`

## JPA实体继承
JPA继承策略:
> 单一表策略；
> 连接表策略；
> 每个类策略；

在父实体类上添加`@Inheritance`注解配置继承策略

### 单一表策略

```
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
public class A {
}
```

如此，生成的数据库表中会有DTYPE字段，用以区分是哪个实体的属性；DTYPE叫'鉴别字段'，可选值默认为实体的类名；

当然JPA中可配置DTYPE别名和可选值的内容:

```
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "ITYPE", discriminatorType = DiscriminatorType.CHAR) // DTYPE的别名
@DiscriminatorValue("I") // DTYPE值配置，每个子类都需要添加该注解
public class A {
}
```

### 连接表策略
`InheritanceType.JOINED`
如父类A，子类B，子类C，每个实体类对应一张数据库表；三张表通过共享主键彼此关联；

### 每个类一个表策略

### JPA实体继承后面详细补充，以上关于实体继承的整理可能存在认知错误！

## SpringDataJpa常用表达式

参考自：[jpa.query-methods.query-creation](http://docs.spring.io/spring-data/jpa/docs/2.0.0.M2/reference/html/#jpa.query-methods.query-creation)


| Keyword | Sample | JPQL snippet |
| --- | --- | --- |
| And | findByLastnameAndFirstname | ... WHERE x.lastname = ?1 AND x.firstname = ?2  |
| Or | findByLastnameOrFirstname | ... WHERE x.lastname = ?1 AND x.firstname = ?2 |
| Is,Equals | findByFirstname, findByFirstnameIs, findByFirstnameEquals | WHERE x.firstname = ?1 |
| Between | findByStartdateBetween | WHERE x.startdate BETWEEN ?1 AND ?2 |
| LessThan | findByAgeLessThan | WHERE x.age < ?1 |
| LessThanEqual | findByAgeLessThanEqual | WHERE x.age <= ?1 |
| GreaterThan | findByAgeGreaterThan | WHERE x.age > ?1 |
| GreaterThanEquals | findByageGreaterThanEquals | WHERE x.age >= ?1 |
| After | findByStartdateAfter | ... WHERE x.startdate > ?1 |




