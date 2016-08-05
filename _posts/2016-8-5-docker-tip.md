---
layout: post
title: docker 小知识
---
查看远端机有几个docker
{% highlight objc %}
sudo docker ps -a
{% endhighlight %}

进入某个docker

{% highlight objc %}
sudo docker exec -ti code_sidekiq_backend bash
{% endhighlight %}

重启某个docker测试某段代码
{% highlight objc %}
sudo docker stop code_sidekiq_backend
sudo docker start code_sidekiq_backend
{% endhighlight %}


