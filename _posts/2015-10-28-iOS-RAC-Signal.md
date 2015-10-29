---
layout: post
title: iOS充电日记－－RACSignal
---

摘要：ReactiveCocoa 这个框架是我从入职CSDN以后接触的，在每个项目中都会用到，所以它的作用非常重要，下面的东西都会跟它有关，文章也主要偏向源码分析。


##代码规范

我们在看开源项目的时候源代码能让我们学习很多东西，那么就让我们先看看下面的代码

{% highlight objc %}
#import <Foundation/Foundation.h>

@class RACCompoundDisposable;
@class RACDisposable;
@class RACSignal;

@interface NSObject (RACDeallocating)

/// The compound disposable which will be disposed of when the receiver is
/// deallocated.
@property (atomic, readonly, strong) RACCompoundDisposable *rac_deallocDisposable;

/// Returns a signal that will complete immediately before the receiver is fully
/// deallocated. If already deallocated when the signal is subscribed to,
/// a `completed` event will be sent immediately.
- (RACSignal *)rac_willDeallocSignal;

@end
{% endhighlight %}

从上面的代码我们可以看到4点：

1、在头文件中类的前向声明使用@class 

2、category名称的命名规范 如果是对iOS sdk的类或其他第三方库的类 加category ,要加上本项目的前缀

2、property的修饰词 尽可能写全，虽然不写也有默认的

3、property的命名规范 如果是对iOS sdk的类或其他第三方库的类 加category ,要加上本项目的前缀

4、函数的命名规范 如果是对iOS sdk的类或其他第三方库的类 加category ,要加上本项目的前缀

对于3、4我写了个例子

{% highlight objc %}
//
//  UIView+WillChange.h
//  RACTest
//
//  Created by 张如泉 on 15/10/26.
//  Copyright © 2015年 quange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WillChange)
- (CGFloat)width;
@end


//
//  UIView+WillChange.m
//  RACTest
//
//  Created by 张如泉 on 15/10/26.
//  Copyright © 2015年 quange. All rights reserved.
//

#import "UIView+WillChange.h"

@implementation UIView (WillChange)

- (CGFloat)width
{
   return 90;
}
@end

//
//  UIView+SomeThing.h
//  RACTest
//
//  Created by 张如泉 on 15/10/26.
//  Copyright © 2015年 quange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SomeThing)
- (CGFloat)width;
@end

//
//  UIView+SomeThing.m
//  RACTest
//
//  Created by 张如泉 on 15/10/26.
//  Copyright © 2015年 quange. All rights reserved.
//

#import "UIView+SomeThing.h"

@implementation UIView (SomeThing)

- (CGFloat)width
{
    return 10;
}
@end

//
//  UIView+Zero.h
//  RACTest
//
//  Created by 张如泉 on 15/10/26.
//  Copyright © 2015年 quange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Zero)
- (CGFloat)width;
@end

//
//  UIView+Zero.m
//  RACTest
//
//  Created by 张如泉 on 15/10/26.
//  Copyright © 2015年 quange. All rights reserved.
//

#import "UIView+Zero.h"

@implementation UIView (Zero)
- (CGFloat)width
{
    return 0;
}
@end
{% endhighlight %}

将上面三个category同时加入到项目中

例子[RACTest](https://github.com/QuanGe/TestAllInOne/tree/master/RACTest)

然后在

RACTViewController的viewDidLoad中调用
{% highlight objc %}
NSLog(@"category返回的view的宽度到底是多少%@",@([self.view width]));
{% endhighlight %}
我们可以看到结果可能跟我们的想象的很不同，尽管我们`#import "UIView+WillChange.h"`但是加载的并不是这里面的函数


那么它到底跟什么有关系呢 ，我们试着调整一下这里面的顺序

![](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/Art/connectionToSuperview.png)




##实战
