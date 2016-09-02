---
layout: post
title: github之tag的添加上传 
---

![](https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/images/githubAddTag.png)

### 到底为啥加Tag
    tag顾名思义标签，加上标签以后代表一个里程的结束，也就是一个版本的结束，加上tag以后再执行`pod 'Alamofire', '2.0.2'`类似的代码，pod就下载在此标签下的代码，如果你不加tag就无法区分版本，假如你项目中用到一个开源代码的第三方库，如果人家的代码一直更新，你的代码就得一致跟着更新以防接口变化，加了tag以后，再怎么执行`pod install` 遇到`pod 'Alamofire', '2.0.2'`都会只下载`2.0.2`版本
### 如何加tag
在终端中先cd到项目当前目录 然后执行

{% highlight objc %}
git tag -a v0.1.1 -m 'supper swift'

git push --tags//或者git push origin --tags或者git push origin v0.1.1
{% endhighlight %}

### 如何删除tag
在终端中先cd到项目当前目录 然后执行

{% highlight objc %}
git tag -d v0.1.1
git push origin :refs/tags/v0.1.1
{% endhighlight %}
