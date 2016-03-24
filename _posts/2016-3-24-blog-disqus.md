---
layout: post
title: 博客支持评论
---

一直想给自己的博客加个评论，方便交流，今天终于抽出时间搞一下，如果顺利的话就不会有这篇博客了。下面看我遇到的坑。

我选的是[Disqus](https://disqus.com/)

注册账号什么的就不说了，说说评论的设置

https://quangeblog.disqus.com/admin/settings/advanced/
这个页面下一定要设置Trusted Domains，即哪些网站可以用你的评论功能，如果不设置的话是用不了的。

然后就是博客项目里的`_config.yml`文件的配置了

{% highlight objc %}
# Enter your Disqus shortname (not your username) to enable commenting on posts
# You can find your shortname on the Settings page of your Disqus account
disqus: quangeblog
{% endhighlight %}

##注意key和value 中间一定要隔一个空格，否则显示不了评论


