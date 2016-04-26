---
layout: post
title: rails ubuntu错误
---

### 运行rails server 出现There was an error while trying to load the gem 'uglifier'. (Bundler::GemRequireErr

现象：在linux下运行rails server 出现There was an error while trying to load the gem 'uglifier'. (Bundler::GemRequireError)
原因是缺少依赖的组件nodejs

{% highlight objc %}
运行sudo apt-get install nodejs 安装nodejs，再重新运行rails server即可。
{% endhighlight %}
