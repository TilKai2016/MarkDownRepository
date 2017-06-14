## 安装WordPress

*在阿里云服务器，使用Docker安装WordPress，完成该博客网站的搭建。*

<font color = "#00BC6E">docker-compose.yml</font>文件内容:

```
version: '2.0'

services:
  db_mysql:
    restart: always
    image: mysql:latest
    container_name: mysql
    volumes:
      - ./data:/var/lib/mysql
      - ./mysql:/etc/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=yourRootPassword
      - MYSQL_DATABASE=yourDatabaseName
      - MYSQL_USER=yourUsername
      - MYSQL_PASSWORD=yourPassword
    ports:
      - 3306:3306
    
  wordpress:
    restart: always
    container_name: wordpress
    image: wordpress:latest
    depends_on:
      - db_mysql
    volumes:
      - ./html:/var/www/html
    environment:
      WORDPRESS_DB_HOST: db_mysql:3306
      WORDPRESS_DB_USER: YaoWordPressUsername
      WORDPRESS_DB_PASSWORD: YourWordPressPassword
    ports:
      - 80:80
```

## 新建页面显示所有文章列表

* 目录选择: `/var/www/html/wp-content/themes`, 之后进入所用主题的目录;

* 将所用主题的`page.php`文件复制一份, 改名为`page-allpost.php`;

* 在`page-allpost.php`的开始位置插入以下代码片段:

```
<?php
/**
* @package WordPress
Template Name: page-allpost
*/

?>
```

* 在`page-allpost.php`的合适位置插入以下代码片段:

```
<?php
$previous_year = $year = 0;
$previous_month = $month = 0;
$ul_open = false;

$myposts = get_posts('numberposts=-1&orderby=post_date&order=DESC');
?>

<?php foreach($myposts as $post) : ?>

<?php
setup_postdata($post);
$year = mysql2date('Y', $post->post_date);
$month = mysql2date('n', $post->post_date);
$day = mysql2date('j', $post->post_date);
?>

<?php if($year != $previous_year || $month != $previous_month) : ?>

<?php if($ul_open == true) : ?>
</ul>
<?php endif; ?>

<h3><?php the_time('Y年 F'); ?></h3>
<ul>
<?php $ul_open = true; ?>
<?php endif; ?>
<?php $previous_year = $year; $previous_month = $month; ?>

<li><span><?php the_time('Y/m/d'); ?></span> <span><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></span> <span> <?php if(function_exists('the_views')) { the_views(); } ?></span> <?php comments_popup_link( __( 'comments(0)', 'farlee' ), __( 'comments(1)', 'farlee' ), __( 'comments(%)', 'farlee' ), 'comments-link', __('comments closed', 'farlee')); ?> </li>

<?php endforeach; ?>
</ul>
```

* 进入博客管理界面, `页面`->`新建页面`, 模版选择`page-allpost`;

## 页面展示修改

* Footer

```
<a href="#">Personal Blog@TilKai</a>
```

## 针对optimizer主题

为了修改首页展示效果,暂时对代码做以下修改:

主题下代码修改:

* index.php中,`<div class="fixed_wrap fixindex">`修改为`<div class="fixed_wrap fixindex" style="display:none;">`

* style.css中`.stat_content_inner{ position:absolute; bottom:15%; width:100%; z-index:11; line-height:1.9em;}`改为`.stat_content_inner{display:none;  position:absolute; bottom:15%; width:100%; z-index:11; line-height:1.9em;}`

