# 常用Git命令

## Git查看某次历史提交修改的内容

```
# 查看提交记录
git log --graph
```

执行结果类似如下：

```
*   commit 87bf3540ac8919f95fd41c7ff89b2eb316f39107
|\  Merge: 10952ef 0b35095
| | Author: TilKai <TilKai@XXX.com>
| | Date:   Tue Apr 25 02:59:19 2017 +0000
| | 
| |     Merge branch 'bugFixForBysy-byTilKai' into 'bysyLocal'
| |     
| |     Bug fix for bysy by til kai
| |     
| |     
| |     
| |     See merge request !11
| |   
| * commit 0b3509500abe56562cc9dc0853f9fb34777adbd2
| | Author: TilKai <TilKai@XXX.com>
| | Date:   Tue Apr 25 10:35:16 2017 +0800
| | 
| |     系统状态背景图 base_img.png替换
| |   
| * commit 65d348c3392ed8b4e33b760b42307d5a4666c4b2
| | Author: TilKai <TilKai@XXX.com>
| | Date:   Tue Apr 25 09:27:44 2017 +0800
| | 
| |     能耗分析历史记录内容隐藏
| |     
* |   commit 10952efafeb3051af875bff03e6b3f7b86e25efd
|\ \  Merge: 2d2bed6 6513d7f
| |/  Author: zhangzl <zhangzongli@XXX.com>
|/|   Date:   Tue Apr 25 02:56:42 2017 +0000
| |   
| |       Merge branch 'zutaitu' into 'bysyLocal'
| |       
| |       Fix:主机进水压力趋势图添加
| |       
| |       
| |       

```


执行`git show <commit-hashId>`命令查看某次提交的修改内容。

```
# 查看某次提交的修改信息
git show <commit-hashId>
# 查看某次提交的某个文件的修改信息
git show <commit-hashId> filename
```

## git跟踪相关


### 从跟踪清单中删除文件(夹)

```
* 删除跟踪清单中dir文件夹下的a.class文件
git rm --cache /dir/a.class
# 删除跟踪清单中dir下所有文件
git rm --cache /dir/\*
```

### git update-index --assume-unchanged

```
# 用来忽略指定文件的变动，在git status的时候不会检查这个文件是否变化，也就不会被提交。
git update-index --assume-unchanged
```


