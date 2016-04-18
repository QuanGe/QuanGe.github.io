---
layout: post
title: ignore bin 
---
安卓代码 如何忽略掉bin 和gen 中的文件：
{% highlight objc %}
	git rm -r --cached bin
    git add bin
    git commit -m "fixing .gitignore"
{% endhighlight %}

