---
layout: post
title: git项目修改remote
---

切换remote的简单方法：
或者直接改.git目录下的config文件，将code.csdn.net改为code.beyond.csdn.net。以切换remote
对于labhub项目，需要同时修改./git/modules/app/assets/config文件

或者
{% highlight objc %}
git remote remove origin
git remote add origin git@code.beyond.csdn.net:code_product/code_dl.git
git branch --set-upstream-to=origin/master
git checkout develop
git branch --set-upstream-to=origin/develop
{% endhighlight %}
