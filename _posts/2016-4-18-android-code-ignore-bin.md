---
layout: post
title: android代码用git如何忽略掉bin 和 gen 
---



{% highlight objc %}
	git rm -r --cached bin

    git add bin

    git commit -m "fixing .gitignore"
{% endhighlight %}

