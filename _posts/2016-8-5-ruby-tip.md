---
layout: post
title: ruby 小知识
---
如果想测试项目中的某个函数，又不想重复操作网页
{% highlight objc %}
//也可以写rails c默认是开发环境，
rails console 
//线上环境测试
rails consle production
{% endhighlight %}

如果只是想测试ruby某个语法可以

{% highlight objc %}
zhangruquandeMacBook-Pro:labhub git$ irb
2.1.8 :001 > :back.class
 => Symbol 
2.1.8 :002 > 2.class
 => Fixnum 
2.1.8 :003 > "".class
 => String 
2.1.8 :004 > :"".class
 => Symbol 
2.1.8 :005 > 
{% endhighlight %}

这个看是不是很方便，以前以为:abc这是个数字呢，今天一看是Symbol 也可以这么些:"abc"
注意:后面随便写 真是强大呢
