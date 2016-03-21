---
layout: post
title: iOS cocoaPods新认知
---

最近的项目在进行`pod install`之后运行报错

{% highlight objc %}
ld: warning: directory not found for option '-L/Users/zhangruquan/abc/ios-test-pod/Pods/build/Debug-iphoneos'
ld: library not found for -lPods-AFNetworking
clang: error: linker command failed with exit code 1 (use -v to see invocation)
{% endhighlight %}

奇怪的是只是`today extension`项目报错，试了好多次，都没有解决，后来可能是缓存问题，于是删除`xcworkspace`文件、`Pods`文件夹、`Podfile.lock`文件 这三项，再执行`pod install`，依然不行。突然想起，之前`today extension`项目中的项目依赖库都是手动配置的，可能在这有问题。于是更新`Podfile`文件

{% highlight objc %}
platform :ios, '7.0'

def pods
pod 'AFNetworking', '~> 2.0'
pod 'UALogger'
pod 'Mantle'
end

target 'testPodToday' do
pods
pod 'MBProgressHUD'
pod 'ReactiveViewModel'
pod 'UMengAnalytics-NO-IDFA'
end

target 'News' do
pods
end
{% endhighlight %}

这时会收到一些警告

![](https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/images/Pod_Waring.jpg)

然而打开项目xcworkspace 运行，仍然报错
{% highlight objc %}
ld: warning: directory not found for option '-L/Users/zhangruquan/abc/ios-test-pod/Pods/build/Debug-iphoneos'
ld: library not found for -lPods-AFNetworking
clang: error: linker command failed with exit code 1 (use -v to see invocation)
{% endhighlight %}

天呐。这可咋办，我这时候想到之前的手动配置可能出现了影响，以至于改了`Podfile`还是不行，能不能把整个项目的pod配置重新清理一遍呢 
[这里是答案链接](http://stackoverflow.com/questions/16427421/how-to-remove-cocoapods-from-a-project)
###如下：需要两个工具

{% highlight objc %}
1、Cocoapods-Deintegrate Plugin
2、Cocoapods-Clean Plugin
{% endhighlight %}

###那么这两个工具如何安装呢 

1、Cocoapods-Deintegrate Plugin：终端中输入
{% highlight objc %}
gem install cocoapods-deintegrate
{% endhighlight %}

2、Cocoapods-Clean Plugin：终端中输入
{% highlight objc %}
gem install cocoapods-clean
{% endhighlight %}

###如何使用
1、首先在控制台输入
{% highlight objc %}
cd (path of the project) //Remove the braces after cd
{% endhighlight %}
2、
然后
{% highlight objc %}
pod deintegrate
{% endhighlight %}

3、
{% highlight objc %}
pod clean
{% endhighlight %}

![](https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/images/Pod_Clean.jpg)
最后确保两个项目中的`other link flags`、`header search paths`、 `library search paths`、`PODS_ROOT` 均为空即可

###

{% highlight objc %}
pod install
{% endhighlight %}

再运行 就不会有啥问题了 