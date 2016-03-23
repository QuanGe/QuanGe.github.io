---
layout: post
title: iOS 崩溃跟踪分析
---

最近在用青花瓷抓包的时候经常发现https://e.crashlytics.com:443的数据，比如今日头条、网易新闻、豆瓣、链家等已开始我没注意，后来看到yep的源代码中的profile有`pod 'Crashlytics'`,网上一搜是崩溃分析的，于是尝试着用用。

首先[在这里](https://get.fabric.io)注册账号，

然后[在这里](https://fabric.io/downloads/xcode)下载xcode插件应用。

最后运行fabric应用，然后选择要添加崩溃跟踪的项目，就可以一步一步添加了，非常强大


那么一切就绪了以后，我试着写了一个崩溃的程序，运行，闪退，但是在crashlytics却找不到崩溃日志，在下面有一行字
{% highlight objc %}
1 unsymbolicated crash from missing dSYMs in 1 version in the last 24 hours.View
{% endhighlight %}

然后我点击了右边的view按钮，提示
{% highlight objc %}
Missing dSYMs in the last 7 days. For details on how to find missing dSYMs, read [this help article.](https://docs.fabric.io/ios/crashlytics/missing-dsyms.html)
{% endhighlight %}

我仔细阅读了那个片文章，重复操作了N遍，还不行，最后跟YEP项目比较，看哪里的问题，后来发现yep里在`Build Options`的`Debug Information format`的选项都选了`DWARF with dSYM File` 。说一下我是咋发现的，配置里面搜索`dsym`关键字,就出来了。

好吧，再次运行程序有了崩溃日志了见下图
![](https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/images/crashlytics.png)


