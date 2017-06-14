## Hexo使用
<1>. 新建文件夹，执行`npm install hexo-cli -g`,安装Hexo;
<2>. 执行`hexo init blog`,下载blog模板;
<3>. `cd blog`执行`npm install`;
<4>. 执行`hexo g #`或`hexo generate`在当前目录生成一个名为**public**的静态文件;
<5>. 执行`hexo s #`或`hexo server`启动博客;
<6>. 浏览器打开[http://localhost:4000/](http://localhost:4000)查看搭建结果;
> **注:**
> ①. `hexo deploy`或`hexo d`部署博客到远程服务器,如GitHub等;
> ②. `hexo new '文章名称'`新建文章;
> ③. `hexo page '页名称'`新建页面;

## Hexo主题设置
<1>. blog根目录执行`hexo clean`;
<2>. 执行`git clone https://github.com/litten/hexo-theme-yilia.git themes/yilia`克隆主题;
<3>. 更新主题
修改**_config.yml**文件中的**theme**属性,设置为yilia或其他主题;
<4>. 执行`hexo generate`重新生成配置项;
<5>. 执行`hexo server`启动服务,浏览器打开[http://localhost:4000/](http://localhost:4000)查看主题修改结果;

## GitHub创建自己的blog仓库并关联hexo
<1>. Repository name的必要格式为chilonghai.github.io;
<2>. clone该项目到本地;
<3>. 拷贝GitHub上项目的ssh链接;
<4>. 修改**hexo**的**_config.yml**文件中的**deploy**属性为:

```
deploy:
  type: git
  repo: 你自己的SSH地址
  branch: master
```
<5>. 执行`hexo deploy`;
至此已完成部署;

## 域名解析
<1>. 登录[万网首页](https://wanwang.aliyun.com/),首先购买域名;
<2>. 已购买域名后,进行域名解析,记录值为:`192.30.252.153`解析成功后即可通过域名访问blog了。

## 干货:搭建使用 Hexo 的些许经验!
[搭建使用 Hexo 的些许经验](http://www.jianshu.com/p/728041d6e741)

参考:[Charly Cheng](http://www.charlycheng.xyz/);
**附带具体步骤:**
<1>. [搭建博客第一步：Hexo](http://www.charlycheng.xyz/2016/12/03/hello-world/)
<2>. [搭建博客第二步：GithubPages](http://www.charlycheng.xyz/2016/12/05/%E6%90%AD%E5%BB%BA%E4%B8%AA%E4%BA%BA%E5%8D%9A%E5%AE%A2%E7%AC%AC%E4%B8%80%E6%AD%A5%EF%BC%9AGithubPages/)
<3>. [搭建博客第三步：域名购买及配置](http://www.charlycheng.xyz/2016/12/05/%E6%90%AD%E5%BB%BA%E5%8D%9A%E5%AE%A2%E7%AC%AC%E4%B8%89%E6%AD%A5%EF%BC%9A%E5%9F%9F%E5%90%8D%E8%B4%AD%E4%B9%B0%E5%8F%8A%E9%85%8D%E7%BD%AE/)
<4>. [搭建博客最终篇：博客的成功搭建](http://www.charlycheng.xyz/2016/12/05/%E6%90%AD%E5%BB%BA%E5%8D%9A%E5%AE%A2%E6%9C%80%E7%BB%88%E7%AF%87%EF%BC%9A%E5%8D%9A%E5%AE%A2%E7%9A%84%E6%88%90%E5%8A%9F%E6%90%AD%E5%BB%BA/)


