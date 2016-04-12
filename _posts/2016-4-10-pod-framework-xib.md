---
layout: post
title: 如果你写的第三方库带xib文件，pod配置文件该咋写？ 
---

{% highlight objc %}
	s.source_files = 'QGCollectionMenu/*.{h,m}'
  	s.resources = ['QGCollectionMenu/*.{xib}']
{% endhighlight %}
