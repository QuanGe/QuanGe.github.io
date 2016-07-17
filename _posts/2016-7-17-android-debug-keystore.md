---
layout: post
title: 安卓调试新浪微博sdk授权登录时使用debug的签名文件
---
安卓调试新浪微博sdk授权登录时使用debug的签名文件，但是你手头只有release版的签名文件。假设你现在发布程序的签名文件为abc 其中的alia为dingding
{% highlight objc %}
keytool -changealias -keystore abc -alias dingding -destalias androiddebugkey
keytool -keypasswd -keystore abc -alias androiddebugkey
keytool -storepasswd -keystore abc
{% endhighlight %}
