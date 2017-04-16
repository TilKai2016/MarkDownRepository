---
title: Swagger-API
date: 2016-12-06 23:21:04
tags: [Swagger, API, Annotation]
---

## Swagger常用注解一览及使用
<!-- more -->
**注:本文基于1.5X版本**
### @API
>**`@API`**: Marks a class as a Swagger resource.
>
>表示一个开放的API，
>①**value**: 定义API声明资源的托管路径，一般与@path具有相同的值，若使用tags属性，则value标记失效；
>②**description**: 简短描述API功能，**1.5x版本不再使用**，Default = ""；
>③**produces**: 指定API输出的MIME(Multipurpose Internet Mail Extensions)类型，value可以为逗号分隔的内容，如`produces = "application/json, application/xml"`会建议该API Resource生成JSON和XML输出，Default = "";
>④**position**: 定义该API Resource在资源清单中显式排顺的顺序，**1.5x不再使用**，保留作为向前支持，Default = 0;
>⑤**consumes**: 指定输入，value定义可使用逗号分隔的内容，如`consumes = "application/json, application/xml"`会建议该API Resource接收JSON和xml类型的输入，Default = "";
>⑥**protocols**: 为此资源下的操作设定特定协议，值为字符串，可用逗号分隔设定多个协议，可选值有" http, https, ws, wss";
>⑦**authorizations**: 对应操作对象的'security'字段，获取该API Resource所需的授权列表，default = @com.wordnik.swagger.annotations.Authorization("");
>⑧**hidden**: 隐藏该API Resource，实验证明定义在@API中未被使用，而定义在@ApiOperation中时，设置为true可隐藏该方法，Default = false;
>⑨**tags**: 定义API文档控件的标签列表，用于分组展示，非空值时，覆盖value中的值，数据类型为string类型的List;
>⑩**basePath**: 1.5x不再使用，保留作为向前支持;

```
@Api(value = "/IndexController", tags = {"API1", "API2"}, description = "Swagger接口示例", produces = MediaType.APPLICATION_JSON_VALUE, position = 0, consumes = "application/json, application/xml", hidden = false)
```

### @ApiImplicitParam
>**`@ApiImplicitParam`**:Represents a single parameter in an API Operation.
>
>While ApiParam is bound to a JAX-RS parameter, method or field, this allows you to manually define a parameter in a fine-tuned manner. This is the only way to define parameters when using Servlets or other non-JAX-RS environments.
>This annotation must be used as a value of ApiImplicitParams in order to be parsed.
>
>①**name**: Name of the parameter.为了使Swagger功能正常，当根据paramType()命名参数时，官方要求遵循如下规则:
><1>.如果参数类型为路径，name应该为路径中的相关节点;
><2>.如果参数类型为body,name应该为body;
><3>.对于其他情况，参数名称应该为应用程序期望的参数名称;
>②**value**: a brief description of the parameter 参数的一个临时描述;
>③**defaultValue**: Describes the default value for the parameter 参数默认值的描述;
>④**allowableValues**: 限制参数可接收的值,官方提供三种方式描述可接收的值:
><1>To set a list of values, provide a comma-separated list surrounded by square brackets. For example: [first, second, third].(直译来看,官方讲的是方括号括起来的逗号分隔的列表，即数组,但这是个坑!直接使用逗号分隔的值的字符串就好了,像可选值为"a","b","c",不要写["a","b","c"],直接写"a,b,c"吧!)
><2>range定义包括或不包括最大值最小值的数值范围，如range[1,5]，range[1,5)，方括号包括临界值，圆括号不包括临界值;
><3>range定义从-infinity或到infinity的数组范围，如range[1,infinity]或range[-infinity,1]
>⑤**required**: 描述参数是否为必须;
>⑥**access**: 允许从API文档过滤参数，Default = ""，具体参阅[io.swagger.core.filter.SwaggerSpecFilter](http://www.programcreek.com/java-api-examples/index.php?api=io.swagger.core.filter.SwaggerSpecFilter);
>⑦**allowMultiple**: 指定参数是否允许接收多个逗号分隔的值, Default = false;
>⑧**dataType**: 指定数据类型，官方指定允许原始数据类型或类名, Default = "";
>⑨**paramType**: 指定参数类型，官方指定参数包括"path"(请求参数的获取@PathVariable),"query"(请求参数的获取@RequestParam),"body"(不常用),"header"(请求参数的获取@ReuqestHeader),"form"(不常用);

```
@ApiImplicitParam(name = "id", value = "用户ID", defaultValue = "", allowableValues = "range[-infinity, 1]", required = true, allowMultiple = true, dataType = "int", paramType = "path")
```

### @ApiImplicitParams
>**`@ApiImplicitParams`**: A list of ApiImplicitParams available to the API operation.

```
@ApiImplicitParams({
    @ApiImplicitParam(name = "id", value = "用户ID", paramType = "path", dataType = "int"),
    @ApiImplicitParam(name = "userName",value = "用户名称",paramType = "form",dataType = "string")
})
```

### @ApiModel
>**`@ApiModel`**: 提供有关Swagger models的额外的信息。适用于实体类，而不适用于方法。 Default = ""
>
>①**value**: 提供给model一个可替代的名称，默认为类名；
>②**description**:提供给类一个长的描述，Default = ""；
>③**parent**: 内容为实体继承的父类，用于描述实体的继承关系，Default = java.lang.Void.class；
>④**discriminator**: 支持模型的继承和多态。用作鉴别符的字段名称，基于该字段，可以鉴别使用哪个子类， Default = ""；
>⑤**subType**: 继承于该模型的子类集合，Default = {}；
>⑥**reference**: 指定类型引用，可被覆盖。Default = "";

```
@ApiModel(description = "电站基本信息")
@Entity
@JsonInclude(JsonInclude.Include.NON_NULL)
public class Station implements Serializable {
    // ...
}
```

### @ApiModelProperty
>**`@ApiModelProperty`**: 用于添加或操纵实体的属性；可将`@ApiModelProperty`注解用于实体的getter方法上，如:

```
@ApiModel(description = "电站基本信息")
@Entity
@JsonInclude(JsonInclude.Include.NON_NULL)
public class Station implements Serializable {
    protected static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue
    protected Long id;
    // ...
    @ApiModelProperty(example = "1", value = "电站ID")
    public Long getId() {
        return id;
    }
}
```

>①**value**: 该属性的简单描述
>②**allowableValues**: 该属性允许的限制值；
>允许用以下三种方式定义:
><1>.类似于`allowableValues = "1,2,3,4"`(官方给出的是类似于`allowableValues = "[1,2,3,4]"`，不好用！)；
><2>.类似于`allowableValues = "range[1,5]"`或`allowableValues = "range[1,5)"`，使用方括号代表包括临界值，使用圆括号表示不包括临界值，实践得到方括号生成的值正常(`id (integer, optional): 电站ID integerMin. Value:1Max. Value:5,`)，而**圆括号不能正常生产对应的范围**(`id (integer, optional): 电站ID integerMin. Value:1,`)
><3>类似于`allowableValues = "(0,9)"`，**实践证明不好用，解决后更新此处！**
>③**access**: 允许从API文档中过滤属性，Default = ""；**实践未找到如何使用**
>④**notes**: 暂未使用，Default = ""；
>⑤**dataType**: 定义参数的数据类型，用于覆盖从类中读取到的属性的数据类型，Default = ""；
>⑥**required**: 指定参数是否为必须的，Default = false；
>⑦**position**: 在模型中显式的定义属性的显示顺序，Default = 0；
>⑧**hidden**: 允许属性在swagger-api中隐藏，Default = false(像如果前后端不传输某属性，可以直接加`@JsonIgnore`注解)；
>通过ApiModelProperty注解的example属性设置响应对象的示例;
>⑨**name**: 允许覆盖属性名。Default = "";
>⑩**readOnly**:true||false,允许指定模型属性为只读;
>⑪**reference**: 指定类型引用，覆盖其他指定类型;

```
@ApiModelProperty(value = "ID", name = "", allowableValues = "range[0, 999]", dataType = "int", required = false, position = 0, hidden = false, example = "1", readOnly = false, reference = "")
private int id;
```

### @ApiOperation
>**`@ApiOperation`**:Describes an operation or typically a HTTP method against a specific path.描述针对特定路径的操作或通常的HTTP方法。
>
>一个`@API`下可以有多个`@ApiOperation`，表示针对该API的CRUD操作，在ApiOperation Annotaiton中还可用value，notes描述该操作的应用，response描述正常情况下该请求返回的对象类型.
>
>①**value**: Provides a brief description of this operation. Should be 120 characters or less for proper visibility in Swagger-UI.提供该操作的简短描述，为了在Swagger-ui中的正确可见性，value应小于等于120个字符。
>②**notes**: A verbose description of the operation. 提供该操作的详细说明。
>③**response**: The response type of the operation.
In JAX-RS applications, the return type of the method would automatically be used, unless it is javax.ws.rs.core.Response. In that case, the operation return type would default to `void` as the actual response type cannot be known.
操作的响应类型。在JAX-RS应用中，将自动使用方法的返回值类型，除非应用是javax.ws.rs.core.Response时，操作的返回值类型为void，因为实际的响应类型是未知的。**(实际应用中,可能有`List<HelloWord>`返回值的情况,此时可以配置:response = HelloWord.class, responseContainer = "List", 定义为`List<HelloWord>`的返回值展示示例)**
>④**responseContainer**: Notes whether the response type is a list of values.
Valid values are "List", "Array" and "Set". "List" and "Array" are regular lists (no difference between them), and "Set" means the list contains unique values only.
Any other value will be ignored.
注意响应类型是否为list。有效值为List、Array、Set。常规值为List、Array(两者没区别)，特殊值为Set，其他值被忽略。
>⑤**tags**: 目前未被使用。
>⑥**httpMethod**: Corresponds to the `method` field as the HTTP method used.
If not stated, in JAX-RS applications, the following JAX-RS annotations would be scanned and used: @GET, @HEAD, @POST, @PUT, @DELETE and @OPTIONS. Note that even though not part of the JAX-RS specification, if you create and use the @PATCH annotation, it will also be parsed and used. If the httpMethod property is set, it will override the JAX-RS annotation.

>For Servlets, you must specify the HTTP method manually.

>Acceptable values are "GET", "HEAD", "POST", "PUT", "DELETE", "OPTIONS" and "PATCH".
>
>对应method字段作为使用的HTTP方法，若没有特殊说明，在JAX-RS程序中，将扫描和使用以下JAX-RS注释：@GET，@HEAD，@POST，@PUT，@ DELETE和@OPTIONS。 注意，即使不是JAX-RS规范的一部分，如果创建和使用@PATCH注释，它也将被解析和使用。 如果设置了httpMethod属性，它将覆盖JAX-RS注释。
>
>对于Servlet，必须手动指定HTTP方法。
>
>可接受的值为“GET”，“HEAD”，“POST”，“PUT”，“DELETE”，“OPTIONS”和“PATCH”。
>⑦**position**
>⑧**nickname**: Corresponds to the `nickname` field.
>The nickname field is used by third-party tools to uniquely identify this operation. In JAX-RS environemnt, this would default to the method name, but can be overridden.

>For Servlets, you must specify this field.
>
>对应nickname字段。
>该昵称字段用于第三方工具识别。JAX-RS环境中，这将默认作为方法名，但可覆盖。
>⑨**produces**、**consumes**、**protocols**、**authorizations**、**hidden**
>⑩**tags**: 定义标签用于逻辑分组，非空时覆盖@Api.value()和@Api.tags()的值，此处为字符串而非集合(官方说法)，实际上，如果定义与@Api.tags()的相同，则无效果，如果不同，会新建标签;

```
@ApiOperation(value="获取用户列表", notes="获取所有用户列表", response = HelloWorld.class, httpMethod = "GET", produces = MediaType.APPLICATION_JSON_VALUE, position = 1)
```
### @ApiParam
>**`@ApiParam`**:用于描述该API操作接收的参数类型，value用于描述参数，required用于描述是否为必须；**注意**`@ApiParam`只与JAX-RS参数注释一起使用，JAX-RS参数包括:`@PathParam`,`@QueryParam`,`@HeaderParam`,`@FormParam`和在JAX-RS2中的`@BeanParam`.
>
>①**name**: name从字段、方法、参数名派生，可被覆盖。body始终命名为"body"，路径始终命名为其所表示的路径;
>②**value**: A brief description of the parameter;
>③**defaultValue**: 描述默认值;
>④**allowableValues**: 参数可接收值的列表，有如下格式可被接收[1,2,3] || range[1, 5] || range[-infinity, 0];
>⑤**required**: Specifies if the parameter is required or not.
>⑥**access**: Default = "";
>⑦**allowMultiple**: true || false;

```
@ApiOperation(notes = "user/loadUser.do",value = "获取用户", httpMethod = "GET", produces = MediaType.APPLICATION_JSON_VALUE)
public Result loadUser(
    @ApiParam(value = "用户ID", required = true) @RequestParam Long userId
){
    ...
}

```

### @ApiResponse
>**`@ApiResponse`**:
>①**code**: The HTTP status code of the response.
>②**message**: 与code对应的人类可读的信息。
>③**response**: 可选的响应类，描述消息的有效内容,如错误时返回Map形式的User对象,则可以设置response=User.class,responseContainer="Map"。
>④**responseContainer**: 可选的response的展示形式,可选值列表为List、Map、Set,设置其他值将被忽略。

### @ApiResponses
>**`@ApiResponses`**:在一个`@ApiOperation`下，可以通过`@ApiResponses`描述API操作可能出现的异常情况(或其他成功信息)
>①**value**: 存放`@ApiResponse`列表。

示例一(像代码中拦截捕获的异常并进行处理，将拦截内容加工放入ErrorInfo实体中，就可以像下面一样定义):

```
@ApiResponses(value = {@ApiResponse(code = 405, message = "Invalid input", response = ErrorInfo.class), responseContainer = "Map"})
```

示例二(添加响应头的描述):

```
@ApiResponses(value = {
      @ApiResponse(code = 400, message = "Invalid ID supplied",
                   responseHeaders = @ResponseHeader(name = "X-Rack-Cache", description = "Explains whether or not a cache was used", response = Boolean.class)),
      @ApiResponse(code = 404, message = "Pet not found") })
```

### @Authorization
>**`@Authorization`**和**`@AuthorizationScope`**:注解仅用作@Api和@ApiOperation的输入，并不直接用于资源和操作，当直接在类或方法上使用它们将被忽略；当声明并配置了API支持的授权方案后，你就可以用这些注解去标注资源或特殊操作的授权方案；
The authorization scheme used needs to be defined in the Resource Listing's authorization section.

>This annotation is not used directly and will not be parsed by Swagger. It should be used within either Api or ApiOperation.
>
>①**name**: 该资源或操作中的授权文件的名称。
>②**scopes**: 当授权文件为OAuth2是被使用。
>

### @AuthorizationScope
>**`@AuthorizationScope`**: 该注解特定用于OAuth2.0授权方案的时候；
>①**scope**: OAuth2授权时被使用。
>②**description**: 关于scope的简短描述。
>

```
@ApiOperation(value = "Add a new pet to the store",
    authorizations = {
      @Authorization(
          value="petoauth",
          scopes = { @AuthorizationScope(scope = "add:pet") }
          )
    }
  )
  public Response addPet(...) {...}
```

>**注意**:
><1>. @ApiImplicitParams会覆盖@ApiParam中的配置.
><2>. 好多属性在API中定义了，调用其中方法时却没有起到作用，是被覆盖了还是未起作用？定义的意义何在。
><3>. @ApiModelProperty在界面的什么地方体现了。
>
>附录:
>
>[官方文档1](http://docs.swagger.io/swagger-core/apidocs/index.html)
>[官方文档2(详细)](http://docs.swagger.io/swagger-core/v1.5.0/apidocs/index-all.html)
>[GitHub官方文档1.5X](https://github.com/swagger-api/swagger-core/wiki/Annotations-1.5.X)
>[在线编辑器,提供部分实例下载](http://editor.swagger.io/)
>[如何编写基于OpenAPI规范的API文档](https://www.gitbook.com/book/huangwenchao/swagger/details)``````
>
>---

## Spring Boot整合Swagger-ui配置使用
### 引入资源文件
`build.gradle`中引入配置:

```
compile('io.springfox:springfox-swagger2:2.6.1')
compile('io.springfox:springfox-swagger-ui:2.6.1')
```

### 实现Swagger配置类:

```
package com.tsingyun.XXX.center.config;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

/**
 * Created by TilKai on 16/12/19.
 */
@EnableSwagger2
@Configuration
@ConditionalOnProperty(name = "swagger.enabled", havingValue = "true")
public class SwaggerConfig {
    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
            .select()
            .apis(RequestHandlerSelectors.basePackage("com.tsingyun.XXX.center"))
            .paths(PathSelectors.any())
            .build();
    }
}
```

### 配置开启swagger

`application.yml`中配置开启swagger

```
swagger:
 enabled : true
```

完成Spring Boot中Swagger的配置。


>[项目bootRun后点击此处执行](http://localhost:8080/swagger-ui.html)

