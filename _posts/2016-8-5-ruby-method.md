---
layout: post
title: ruby 中找不到的方法
---

在一个controller里面可以看到一个如下代码
{% highlight objc %}
before_filter :authorize_read_issue!
{% endhighlight %}
但是又搜不到authorize_read_issue，这时候你也许会奇怪这到底是什么鬼

答案在这里：你可以看到ApplicationController里面有个method_missing，当controller找不到的时候就来这里找，在这里一定能找到相关处理

加油吧