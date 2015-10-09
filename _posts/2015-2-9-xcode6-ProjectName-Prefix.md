---
layout: post
title: 关于Xcode6预编译文件
---

##Xcode6去掉预编译文件的原因

从Xcode6开始新建一个项目xcode不再自动创建预编译文件PrefixHeader.pch，主要原因可能在于Prefix Header大大的增加了Build的时间。没有了Prefix 
Header之后就要通过手动@import来手动导入头文件了，在失去了编程便利性的同时也降低了Build的时间。可以参考[stackoverflow](http://stackoverflow.com/questions/24158648/why-isnt-projectname-prefix-pch-created-automatically-in-xcode-6)上的讨论。

##Xcode6如何创建预编译文件


1、添加新文件
![](http://i.stack.imgur.com/3M5yG.png)
2、去`Project/Build Setting/APPl LLVM 6.0-Language `设置
![](http://i.stack.imgur.com/9H4wM.png)

##会有哪些问题

在我的项目[LoveiOS](https://github.com/QuanGe/LoveiOS)中用到了c语言写的第三方库sundown，添加了预编译文件编译的时候报了N多"NSObjCRuntime.h"错误，后来发现了原因
开始我是这个写的
{% highlight objc %}
#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#endif
#import "RVMViewModel.h"
#import "ReactiveCocoa.h"
#import "UALogger.h"
#import "AFNetworking.h"
#import "Mantle.h"
#import "MBProgressHUD.h"
{% endhighlight %}

后来改成了 
{% highlight objc %}
#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "RVMViewModel.h"
#import "ReactiveCocoa.h"
#import "UALogger.h"
#import "AFNetworking.h"
#import "Mantle.h"
#import "MBProgressHUD.h"
#endif
{% endhighlight %}

编译成功