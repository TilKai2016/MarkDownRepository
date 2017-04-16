---
title: 由@ExceptionHandler引出的关于SpringMVC异常处理
date: 2016-12-22 20:34:00
tags: [SpringBoot, SpringMVC, ExceptionJandler, ResponseStatus]
---

# 由@ExceptionHandler引出的关于SpringMVC异常处理
<!-- more -->

## 先附项目中的业务代码:
### 处理用户登录的Controller类:

```
@RestController
@RequestMapping("/api/v1")
public class LoginController {
    @Autowired
    private UserService userService;

    /**
     * 用户登录
     * @return 登录状态(ok或error)
     * CommonException为自定义异常处理类
     */
    @PostMapping("/login")
    User login(@Valid @RequestBody LoginInfo loginInfo) throws CommonException {

        Subject subject = SecurityUtils.getSubject();

        if (!subject.isAuthenticated()) {
            UsernamePasswordToken token = new UsernamePasswordToken(loginInfo.getUsername(), loginInfo.getPassword());
            try {
                subject.login(token);
            } catch (UnknownAccountException e) {
                throw new CommonException(HttpStatus.UNAUTHORIZED, ErrorCode.USER_NOT_EXIST);
            } catch (IncorrectCredentialsException exception) {
                throw new CommonException(HttpStatus.UNAUTHORIZED, ErrorCode.USER_PASSWORD_MISMATCH);
            } catch (LockedAccountException exception) {
                throw new CommonException(HttpStatus.UNAUTHORIZED, ErrorCode.USER_IS_LOCKED);
            } catch (AuthenticationException e) {
                e.printStackTrace();
                throw new CommonException(HttpStatus.UNAUTHORIZED, ErrorCode.USER_ERROR_UNKNOWN);
            }
        }

        Long id = (Long) subject.getPrincipal();

        return userService.findUserById(id);
    }
}
```

### CommonException异常处理类

```
public class CommonException extends Exception {
    protected HttpStatus status = HttpStatus.BAD_REQUEST;

    // ErrorCode类为自定义错误代码枚举类
    protected ErrorCode code;

    protected String message;

    public CommonException(HttpStatus status, ErrorCode code) {
        this.status = status;
        this.code = code;
    }
}
```

### 异常代码枚举类

```
public enum ErrorCode {
    /**
     * 用户登陆相关错误
     */
    USER_NOT_EXIST(20101, "用户不存在"),
    USER_PASSWORD_MISMATCH(20102, "密码不对"),
    USER_IS_LOCKED(20103, "用户锁定"),
    USER_ERROR_UNKNOWN(20104, "未知认证错误");

    private Integer code;
    private String message;

    ErrorCode(Integer code, String message) {
        this.code = code;
        this.message = message;
    }

    public Integer getCode() {
        return this.code;
    }

    public String getMessage() {
        return this.message;
    }
}
```

### 异常配置类

```
@ControllerAdvice
public class ControllerExceptionConfig {
    /**
     * 处理定制Exception
     * @param request
     * @param e
     * @return
     */
    @ExceptionHandler(CommonException.class)
    @ResponseBody
    public ResponseEntity<ErrorInfo> handleCommonException(HttpServletRequest request, CommonException e) {
        return ResponseEntity.status(e.getStatus()).body(new ErrorInfo(request, e.getCode(), e.getMessage()));
    }
}
```

### ErrorInfo实体

```
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ErrorInfo {
    /**
     * 出错时间
     */
    protected Calendar timestamp;

    /**
     * 请求URL
     */
    protected String path;

    /**
     * 错误编码
     */
    protected Integer code;

    /**
     * 错误信息
     */
    protected String message;

    /**
     * 多条错误信息
     */
    protected List<Error> errors;

    public ErrorInfo() {
        this.timestamp = Calendar.getInstance();
    }

    public ErrorInfo(HttpServletRequest request, Integer code) {
        this.timestamp = Calendar.getInstance();
        this.path = request.getRequestURI();
        this.code = code;
    }

    public ErrorInfo(HttpServletRequest request, ErrorCode code) {
        this.timestamp = Calendar.getInstance();
        this.path = request.getRequestURI();
        this.code = code.getCode();
        this.message = code.getMessage();
    }

    public ErrorInfo(HttpServletRequest request, ErrorCode code, String message) {
        this.timestamp = Calendar.getInstance();
        this.path = request.getRequestURI();
        this.code = code.getCode();
        this.message = message;
    }

    public ErrorInfo(HttpServletRequest request, Integer code, String message) {
        this.timestamp = Calendar.getInstance();
        this.path = request.getRequestURI();
        this.code = code;
        this.message = message;
    }

    @ApiModelProperty(value = "请求URL", required = true)
    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    @ApiModelProperty(value = "多条错误信息的列表")
    public List<Error> getErrors() {
        return errors;
    }

    public void setErrors(List<Error> errors) {
        this.errors = errors;
    }

    @ApiModelProperty(value = "错误编码", required = true)
    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    @ApiModelProperty(value = "错误信息", required = true)
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    @ApiModelProperty(value = "出错时间", required = true)
    public Calendar getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Calendar timestamp) {
        this.timestamp = timestamp;
    }
}
```

### 简单介绍以上代码
1. `LoginController`用于接收用户信息并利用shiro框架做登录处理，验证通过则返回User部分信息，验证失败则针对异常类型走`CommonException`类，做异常信息的封装处理，提供明确的错误资料；
2. 同时`ControllerExceptionConfig`类方法上添加了`@ExceptionHandler(CommonException.class)`注解，导致在调用完CommonException类后的某个点调用了`ControllerExceptionConfig`类，向响应体中添加了`ErrorInfo`实体；
3. 于是用户登录失败时从`Controller`->`CommonException`->`ControllerExceptionConfig`最终返回了如下信息:

```
Request Headers
{
  "Accept": "*/*"
}
Response Body
{
  "timestamp": 1482400815064,
  "path": "/api/v1/login",
  "code": 20101,
  "message": "用户不存在"
}
Response Code
401
Response Headers
{
  "date": "Thu, 22 Dec 2016 10:00:15 GMT",
  "transfer-encoding": "chunked",
  "content-type": "application/json;charset=UTF-8"
}
```

## SpringMVC异常处理
由于对于`@ExceptionHandler(CommonException.class)`的作用只是猜测，没有理论依据，所以在调查过程中整理了一下关于SpringMVC异常处理的这部分内容，限于个人水平，难免有理解不当之处，望指正之！

参考:[Exception Handling in Spring MVC](http://spring.io/blog/2013/11/01/exception-handling-in-spring-mvc)
以及该blog提供的[代码示例](https://github.com/paulc4/mvc-exceptions)

### 首先关于@ResopnseStatus
#### @ResponseStatus源码

```
/**
 * Marks a method or exception class with the status {@link #code} and
 * {@link #reason} that should be returned.
 *
 * <p>The status code is applied to the HTTP response when the handler
 * method is invoked and overrides status information set by other means,
 * like {@code ResponseEntity} or {@code "redirect:"}.
 *
 * <p><strong>Warning</strong>: when using this annotation on an exception
 * class, or when setting the {@code reason} attribute of this annotation,
 * the {@code HttpServletResponse.sendError} method will be used.
 *
 * <p>With {@code HttpServletResponse.sendError}, the response is considered
 * complete and should not be written to any further. Furthermore, the Servlet
 * container will typically write an HTML error page therefore making the
 * use of a {@code reason} unsuitable for REST APIs. For such cases it is
 * preferable to use a {@link org.springframework.http.ResponseEntity} as
 * a return type and avoid the use of {@code @ResponseStatus} altogether.
 *
 * <p>Note that a controller class may also be annotated with
 * {@code @ResponseStatus} and is then inherited by all {@code @RequestMapping}
 * methods.
 *
 * @author Arjen Poutsma
 * @author Sam Brannen
 * @see org.springframework.web.servlet.mvc.annotation.ResponseStatusExceptionResolver
 * @see javax.servlet.http.HttpServletResponse#sendError(int, String)
 * @since 3.0
 */
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface ResponseStatus {

	/**
	 * Alias for {@link #code}.
	 */
	@AliasFor("code")
	HttpStatus value() default HttpStatus.INTERNAL_SERVER_ERROR;

	/**
	 * The status <em>code</em> to use for the response.
	 * <p>Default is {@link HttpStatus#INTERNAL_SERVER_ERROR}, which should
	 * typically be changed to something more appropriate.
	 * @since 4.2
	 * @see javax.servlet.http.HttpServletResponse#setStatus(int)
	 * @see javax.servlet.http.HttpServletResponse#sendError(int)
	 */
	@AliasFor("value")
	HttpStatus code() default HttpStatus.INTERNAL_SERVER_ERROR;

	/**
	 * The <em>reason</em> to be used for the response.
	 * @see javax.servlet.http.HttpServletResponse#sendError(int, String)
	 */
	String reason() default "";

}
```
即:

<1>. 用指定的`Http状态码`和`reason`标注一个方法或异常类，覆盖通过其他方式设置的`Http状态码`，并返回`HttpStatus`和`reason`；

<2>. 当`@ResponseStatus`注解作用于异常类，或者设置了`@ResponseStatus`注解的`reason`属性时，将调用`HttpServletResponse.sendError`方法；

<3>. 官方文档提出了一个对于我们团队所开发的RESTful风格框架应该**注意**的点:使用`HttpServletResponse.SendError`时，认为该Response是完整响应，并不应该再写入其他信息；同时，Servlet容器通常会写入一个HTML错误页面，因此，**reason属性不适合RESTful API**；同时，官方文档提供了建议，针对这种情况，**RESTful框架最好使用`org.springframework.http.ResponseEntity`作为返回类型**，并**避免使用`@ResponseStatus`注解**；

<4>. `Controller`类也可以用`@ResponseStatus`注解标注，这将被该`Controller`中的所有`@RequestMapping`注解标注的方法继承；


#### 标注异常类
注解一个继承自某个异常类的自定义异常子类，使得抛出该子类异常时，能够使用自定义的Http状态码。

参考示例:
<1>. 缺少订单时的异常处理类

```
 @ResponseStatus(value=HttpStatus.NOT_FOUND, reason="No such Order")  // 404
 public class OrderNotFoundException extends RuntimeException {
     // ...
 }
```

<2>. 使用了该异常处理类的Controller方法

```
@RequestMapping(value="/orders/{id}", method=GET)
 public String showOrder(@PathVariable("id") long id, Model model) {
     Order order = orderRepository.findOrderById(id);

     if (order == null) throw new OrderNotFoundException(id);

     model.addAttribute(order);
     return "orderDetail";
 }
```

#### 基于`Controller`的异常处理

即`@ResponseStatus`注解标注于`Controller methods`

在这里带出了我们的重点：**@ExceptionHandler**注解，接着向下看。

可以向任何的`Controller`中添加使用`@ExceptionHandler`注解标注的方法，用于处理`Controller`中由使用`@RequestMapping`注解标注的方法抛出的异常；

这些使用`@ExceptionHandler`注解标注的方法可以处理:
①. 没有用`@ResponseStatus`标注的异常(通常是预定义异常)；
②. 将用户重定向到专用的错误View；
③. 构建完全自定义的错误响应；

以下`Controller`演示这三个选项！

```
@Controller
public class ExceptionHandlingController {

  // @RequestHandler methods
  ...

  // Exception handling methods

  // 将预定义的异常转换成@ResponseStatus指定的Http状态码
  @ResponseStatus(value=HttpStatus.CONFLICT,
                  reason="Data integrity violation")  // 409冲突
@ExceptionHandler(DataIntegrityViolationException.class)
  public void conflict() {
    // Nothing to do
  }

// 指定如果捕获了SQLException、DataAccessException时返回databaseError视图
@ExceptionHandler({SQLException.class,DataAccessException.class})
  public String databaseError() {
    // Nothing to do.  Returns the logical view name of an error page, passed
    // to the view-resolver(s) in usual way.
    // Note that the exception is NOT available to this view (it is not added
    // to the model) but see "Extending ExceptionHandlerExceptionResolver"
    // below.
    return "databaseError";
  }

// 总控(个人觉得总控这个词的由来应该跟@ExceptionHandler中设置了Exception.class有关！)
// 设置模型并返回视图名称，或者考虑子类化ExceptionHandlerExceptionResolver
  @ExceptionHandler(Exception.class)
  public ModelAndView handleError(HttpServletRequest req, Exception ex) {
    logger.error("Request: " + req.getRequestURL() + " raised " + ex);

    ModelAndView mav = new ModelAndView();
    mav.addObject("exception", ex);
    mav.addObject("url", req.getRequestURL());
    mav.setViewName("error");
    return mav;
  }
}
```

**如何更灵活的使用:**

<1>. 以上这些使用`@ExceptionHandler`注解标注的方法会在应用程序执行过程中出现相对应异常时调用，因此，这些方法也比较适合做一些类似写log之类的其他操作；

<2>. 这些处理程序具有灵活的签名，可以传递灵活的Servlet相关对象，如HttpServletRequest，HttpServletResponse，HttpSession和/或Principle。

<3>. Important Note: The Model may not be a parameter of any @ExceptionHandler method. Instead, setup a model inside the method using a ModelAndView as shown by handleError() above.(未能理解这句话的含义，实践过程中若踩到坑再补充！)

(注`ExceptionHandlerExceptionResolver`:
`ExceptionHandlerExceptionResolver`继承`AbstractHandlerMethodExceptionResolver`通过`ExceptionHandler`方法解析异常，可以通过`setCustomArgumentResolvers`和`setCustomReturnValueHandlers`添加对自定义参数和返回值类型的支持(或使用`setArgumentResolvers`和`setReturnValueHandlers`重新配置所有参数和返回值类型)。)

#### 关于向Model中添加异常的注意点
一般的，后端开发者并不希望将异常详情和堆栈跟踪信息让用户看到，但这些内容又有一定必要让前端工程师知道。因此，如果使用的jsp，可以将异常详细信息放到页面注释中或使用隐藏DIV等。

#### 全局异常处理

又一个对于我熟悉现有框架来讲的重点！

使用`@ControllerAdvice`类做全局异常处理，它允许你使用完全相同的异常处理技术(在其中配置好固定的异常处理方法)，应用到整个应用程序，而不仅仅是单个控制器，把它想象成注解驱动拦截器。

任何使用`@ControllerAdvice`注解标注的类都将变成一个`controller-advice`！

支持三种类型的方法:
①. 用`@ExceptionHandler`注解标注的异常处理方法；
②. 模型增强方法(用于向模型添加附加数据)注解`@ModelAttribute`；
③. Binder初始化方法(用于配置表单处理)`@initBinder`；

简单`@Controller`代码:

```
@ControllerAdvice
class GlobalControllerExceptionHandler {
    @ResponseStatus(HttpStatus.CONFLICT)  // 409
    @ExceptionHandler(DataIntegrityViolationException.class)
    public void handleConflict() {
        // Nothing to do
    }
}
```

如果需要有一个针对所有异常的默认处理，对上面的代码做微调，确保注解的异常由框架处理，如下:

```
@ControllerAdvice
class GlobalDefaultExceptionHandler {
  public static final String DEFAULT_ERROR_VIEW = "error";

  @ExceptionHandler(value = Exception.class)
  public ModelAndView
  defaultErrorHandler(HttpServletRequest req, Exception e) throws Exception {
    // 如果异常用@ResponseStatus注释，则重新抛出它并让框架处理它
    if (AnnotationUtils.findAnnotation(e.getClass(), ResponseStatus.class) != null)
      throw e;
    // 负责配置模型视图并返回配置后的模型视图
    ModelAndView mav = new ModelAndView();
    mav.addObject("exception", e);
    mav.addObject("url", req.getRequestURL());
    mav.setViewName(DEFAULT_ERROR_VIEW);
    return mav;
  }
}
```

#### 更深入的知识点

在DispatcherServlet的应用程序上下文中声明的实现HandlerExceptionResolver的任何Spring bean都将用于拦截和处理在MVC系统中引发并且不由Controller处理的任何异常。

接口如下：

```
public interface HandlerExceptionResolver {
    ModelAndView resolveException(HttpServletRequest request,
            HttpServletResponse response, Object handler, Exception ex);
}
```

深入了解[戳这里](http://spring.io/blog/2013/11/01/exception-handling-in-spring-mvc#going-deeper)
