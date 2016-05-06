---
layout: post
title: macbook vbox安装ubuntu
---

### 共享文件夹
vbox ->设置->共享文件夹－》右侧添加－》命名为gongxiang

vbox －》device－》insert guest additions cd images

{% highlight objc %}
cd
mkdir macbook
sudo mount -t vboxsf gongxiang macbook
{% endhighlight %}


