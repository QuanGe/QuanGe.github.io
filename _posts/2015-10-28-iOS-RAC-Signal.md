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

![](https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/images/category.png)

调整以后我们可以看到结果其实是跟编译文件的先后顺序有关系的

所以我们要在自己的category中的函数前面加在自己项目的前缀


##RAC

ReactiveCocoa (RAC) is a Cocoa framework inspired by Functional Reactive Programming.这句话是RAC对自己的介绍。那么在看这句话的时候我们我们就要先弄清楚，什么是FRP(Functional Reactive Programming)。
这里我们引入[李忠博客](http://limboy.me/ios/2013/06/19/frp-reactivecocoa.html)的一段话

Functional Reactive Programming(以下简称FRP)是一种响应变化的编程范式。先来看一小段代码

{% highlight objective-c %}
a = 2
b = 2
c = a + b // c is 4

b = 3
// now what is the value of c?
{% endhighlight %}

如果使用FRP，`c`的值将会随着`b`的值改变而改变，所以叫做「响应式编程」。比较直观的例子就是Excel，当改变某一个单元格的内容时，该单元格相关的计算结果也会随之改变。

FRP提供了一种信号机制来实现这样的效果，通过信号来记录值的变化。信号可以被叠加、分割或合并。通过对信号的组合，就不需要去监听某个值或事件。

![FRP demo](https://raw.githubusercontent.com/lzyy/lzyy.github.com/master/image/FRP_demo.png)

这在重交互的应用里是非常有用的。以注册为例：

![register demo](https://raw.githubusercontent.com/lzyy/lzyy.github.com/master/image/FRP_register_demo.png)

提交按钮的状态要跟输入框的状态绑定，比如必选的输入框没有填完时，提交按钮是灰色的，也就是不可点；如果提交按钮不可点，那么文字变成灰色，不然变成蓝色；如果正在提交，那么输入框的文字颜色变成灰色，且不可点，不然变成默认色且可点；如果注册成功就在状态栏显示成功信息，不然显示错误信息，等等。

可以看到光是注册页就有这么多的联动，在javascript中可以采用事件监听来处理，iOS中更多的是delegate模式，本质上都是事件的分发和响应。这种做法的缺点是不够直观，尤其在逻辑比较复杂的情况下。这也是为什么尽管nodejs很高效，但由于javascript的callback style和异步模式不符合正常的编程习惯，让很多人望而却步。

使用FRP主要有两个好处：直观和灵活。直观的代码容易编写、阅读和维护，灵活的特性便于应对变态的需求。

ReactiveCocoa是github开源的一个项目，是在iOS平台上对FRP的实现。FRP的核心是信号，信号在ReactiveCocoa(以下简称RAC)中是通过RACSignal来表示的，信号是数据流，可以被绑定和传递。

##RACSignal

![](https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/images/signal.PNG)
大家一定玩过这个游戏，我个人觉得RACSignal更像豌豆射手，可以射出数据也就是豌豆子弹，只不过我们平常不太关心子弹是怎么造出来的
让我们看下面一段代码

{% highlight objective-c %}
//伤害值
const NSInteger hurtNumer = 5;
//伤害次数
__block NSInteger usedNumber = 0;

//植物大战僵尸 中的豌豆射手（这个射手一次 可以连发三发子弹）
RACSignal *peaKiller = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
    usedNumber++;
    if(usedNumber >2)
        [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"不好意思，正在冷却"}]];
    else
    {
        //发射第一发豌豆子弹
        [subscriber sendNext:@(hurtNumer)];
        //发射第二发豌豆子弹
        [subscriber sendNext:@(hurtNumer+1)];
        //结束发射
        [subscriber sendCompleted];
        //发射第三发豌豆子弹
        [subscriber sendNext:@(hurtNumer+2)];
    }

    return [RACDisposable disposableWithBlock:^{
        NSLog(@"进行清理工作");
    }];;
}];

//第一次使用豌豆射手 ，并且设置接受子弹后处理 （这里用block 生成一个RACSubscriber对象，block内的代码 就是接受到子弹后处理）
[peaKiller subscribeNext:^(id x) {
    NSLog(@"接收到一个豌豆子弹，对僵尸1减去生命值 %@", x);
}];

//第二次使用豌豆射手  map 相当于对子弹进行加工 比如加上寒冰属性 使伤害值加100
RACDisposable * dispose = [[peaKiller map:^id(id value) {
    return @([value integerValue] +100);
}] subscribeNext:^(id x) {
    NSLog(@"接收到一个豌豆子弹，，对僵尸2减去生命值 %@", x);
}];

//第三次使用豌豆射手
[peaKiller subscribeNext:^(id x) {
    NSLog(@"第三次使用，这次还有子弹么 %@", x);
} error:^(NSError *error) {
    NSLog(@"第三次使用，报错：%@",NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil));
}];

//游戏结束 进行清理工作
[dispose dispose];
{% endhighlight %}

运行结果为

{% highlight objective-c %}
2015-10-29 11:05:33.316 RACTest[2278:77308] 接收到一个豌豆子弹，对僵尸1减去生命值 5
2015-10-29 11:05:33.316 RACTest[2278:77308] 接收到一个豌豆子弹，对僵尸1减去生命值 6
2015-10-29 11:05:33.316 RACTest[2278:77308] 进行清理工作
2015-10-29 11:05:33.317 RACTest[2278:77308] 接收到一个豌豆子弹，，对僵尸2减去生命值 105
2015-10-29 11:05:33.317 RACTest[2278:77308] 接收到一个豌豆子弹，，对僵尸2减去生命值 106
2015-10-29 11:05:33.317 RACTest[2278:77308] 进行清理工作
2015-10-29 11:05:33.318 RACTest[2278:77308] 第三次使用，报错：不好意思，正在冷却
2015-10-29 11:05:33.318 RACTest[2278:77308] 进行清理工作
{% endhighlight %}

好吧，下面让我们一点点看代码，首先来看豌豆射手是如何创建的 createSignal 后面跟着一个block，入口参数为是一个集成了RACSubscriber协议的对象，
{% highlight objective-c %}
#import <Foundation/Foundation.h>

@class RACCompoundDisposable;

/// Represents any object which can directly receive values from a RACSignal.
///
/// You generally shouldn't need to implement this protocol. +[RACSignal
/// createSignal:], RACSignal's subscription methods, or RACSubject should work
/// for most uses.
///
/// Implementors of this protocol may receive messages and values from multiple
/// threads simultaneously, and so should be thread-safe. Subscribers will also
/// be weakly referenced so implementations must allow that.
@protocol RACSubscriber <NSObject>
@required

/// Sends the next value to subscribers.
///
/// value - The value to send. This can be `nil`.
- (void)sendNext:(id)value;

/// Sends the error to subscribers.
///
/// error - The error to send. This can be `nil`.
///
/// This terminates the subscription, and invalidates the subscriber (such that
/// it cannot subscribe to anything else in the future).
- (void)sendError:(NSError *)error;

/// Sends completed to subscribers.
///
/// This terminates the subscription, and invalidates the subscriber (such that
/// it cannot subscribe to anything else in the future).
- (void)sendCompleted;

/// Sends the subscriber a disposable that represents one of its subscriptions.
///
/// A subscriber may receive multiple disposables if it gets subscribed to
/// multiple signals; however, any error or completed events must terminate _all_
/// subscriptions.
- (void)didSubscribeWithDisposable:(RACCompoundDisposable *)disposable;

@end
{% endhighlight %}

从代码中我们可以看到继承此协议的必须要实现四个方法`sendNext`、`sendError`、`sendCompleted`、`didSubscribeWithDisposable`

继续上面说，block的出口参数为RACDisposable类型的一个对象，RACDisposable又到底是什么东东
{% highlight objective-c %}
#import <Foundation/Foundation.h>

@class RACScopedDisposable;

/// A disposable encapsulates the work necessary to tear down and cleanup a
/// subscription.
@interface RACDisposable : NSObject

/// Whether the receiver has been disposed.
///
/// Use of this property is discouraged, since it may be set to `YES`
/// concurrently at any time.
///
/// This property is not KVO-compliant.
@property (atomic, assign, getter = isDisposed, readonly) BOOL disposed;

+ (instancetype)disposableWithBlock:(void (^)(void))block;

/// Performs the disposal work. Can be called multiple times, though subsequent
/// calls won't do anything.
- (void)dispose;

/// Returns a new disposable which will dispose of this disposable when it gets
/// dealloc'd.
- (RACScopedDisposable *)asScopedDisposable;

@end
{% endhighlight %}

RACDisposable是一个清理对象，可以在里面做一些清理的动作，比如发送一个网络请求，我们现在反悔了，怎么停止呢，就可以用它。

那么createSignal里面又写了个啥，继续看
{% highlight objective-c %}
+ (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe {
return [RACDynamicSignal createSignal:didSubscribe];
}

{% endhighlight %}

RACDynamicSignal又是个啥东东

{% highlight objective-c %}
//
//  RACDynamicSignal.h
//  ReactiveCocoa
//
//  Created by Justin Spahr-Summers on 2013-10-10.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "RACSignal.h"

// A private `RACSignal` subclasses that implements its subscription behavior
// using a block.
@interface RACDynamicSignal : RACSignal

+ (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe;

@end


//
//  RACDynamicSignal.m
//  ReactiveCocoa
//
//  Created by Justin Spahr-Summers on 2013-10-10.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "RACDynamicSignal.h"
#import "RACEXTScope.h"
#import "RACCompoundDisposable.h"
#import "RACPassthroughSubscriber.h"
#import "RACScheduler+Private.h"
#import "RACSubscriber.h"
#import <libkern/OSAtomic.h>

@interface RACDynamicSignal ()

// The block to invoke for each subscriber.
@property (nonatomic, copy, readonly) RACDisposable * (^didSubscribe)(id<RACSubscriber> subscriber);

@end

@implementation RACDynamicSignal

#pragma mark Lifecycle

+ (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe {
RACDynamicSignal *signal = [[self alloc] init];
signal->_didSubscribe = [didSubscribe copy];
return [signal setNameWithFormat:@"+createSignal:"];
}

#pragma mark Managing Subscribers

- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber {
NSCParameterAssert(subscriber != nil);

RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
subscriber = [[RACPassthroughSubscriber alloc] initWithSubscriber:subscriber signal:self disposable:disposable];

if (self.didSubscribe != NULL) {
RACDisposable *schedulingDisposable = [RACScheduler.subscriptionScheduler schedule:^{
RACDisposable *innerDisposable = self.didSubscribe(subscriber);
[disposable addDisposable:innerDisposable];
}];

[disposable addDisposable:schedulingDisposable];
}

return disposable;
}

@end
{% endhighlight %}

从上面的代码可以看到 createSignal实际上是创建了RACDynamicSignal对象，把刚才的block参数保存在_didSubscribe属性中了。
让我继续看 使用一次豌豆射手让其发射三发子弹的函数 subscribeNext参数也是一个block，入口参数是id类型的。
{% highlight objective-c %}
- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock {
NSCParameterAssert(nextBlock != NULL);

RACSubscriber *o = [RACSubscriber subscriberWithNext:nextBlock error:NULL completed:NULL];
return [self subscribe:o];
}
{% endhighlight %}

源码中用这个block生成了一个RACSubscriber类型的对象
{% highlight objective-c %}
//
//  RACSubscriber+Private.h
//  ReactiveCocoa
//
//  Created by Justin Spahr-Summers on 2013-06-13.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "RACSubscriber.h"

// A simple block-based subscriber.
@interface RACSubscriber : NSObject <RACSubscriber>

// Creates a new subscriber with the given blocks.
+ (instancetype)subscriberWithNext:(void (^)(id x))next error:(void (^)(NSError *error))error completed:(void (^)(void))completed;

@end

//
//  RACSubscriber.m
//  ReactiveCocoa
//
//  Created by Josh Abernathy on 3/1/12.
//  Copyright (c) 2012 GitHub, Inc. All rights reserved.
//

#import "RACSubscriber.h"
#import "RACSubscriber+Private.h"
#import "RACEXTScope.h"
#import "RACCompoundDisposable.h"

@interface RACSubscriber ()

// These callbacks should only be accessed while synchronized on self.
@property (nonatomic, copy) void (^next)(id value);
@property (nonatomic, copy) void (^error)(NSError *error);
@property (nonatomic, copy) void (^completed)(void);

@property (nonatomic, strong, readonly) RACCompoundDisposable *disposable;

@end

@implementation RACSubscriber

#pragma mark Lifecycle

+ (instancetype)subscriberWithNext:(void (^)(id x))next error:(void (^)(NSError *error))error completed:(void (^)(void))completed {
RACSubscriber *subscriber = [[self alloc] init];

subscriber->_next = [next copy];
subscriber->_error = [error copy];
subscriber->_completed = [completed copy];

return subscriber;
}

- (id)init {
self = [super init];
if (self == nil) return nil;

@unsafeify(self);

RACDisposable *selfDisposable = [RACDisposable disposableWithBlock:^{
@strongify(self);

@synchronized (self) {
self.next = nil;
self.error = nil;
self.completed = nil;
}
}];

_disposable = [RACCompoundDisposable compoundDisposable];
[_disposable addDisposable:selfDisposable];

return self;
}

- (void)dealloc {
[self.disposable dispose];
}

#pragma mark RACSubscriber

- (void)sendNext:(id)value {
@synchronized (self) {
void (^nextBlock)(id) = [self.next copy];
if (nextBlock == nil) return;

nextBlock(value);
}
}

- (void)sendError:(NSError *)e {
@synchronized (self) {
void (^errorBlock)(NSError *) = [self.error copy];
[self.disposable dispose];

if (errorBlock == nil) return;
errorBlock(e);
}
}

- (void)sendCompleted {
@synchronized (self) {
void (^completedBlock)(void) = [self.completed copy];
[self.disposable dispose];

if (completedBlock == nil) return;
completedBlock();
}
}

- (void)didSubscribeWithDisposable:(RACCompoundDisposable *)otherDisposable {
if (otherDisposable.disposed) return;

RACCompoundDisposable *selfDisposable = self.disposable;
[selfDisposable addDisposable:otherDisposable];

@unsafeify(otherDisposable);

// If this subscription terminates, purge its disposable to avoid unbounded
// memory growth.
[otherDisposable addDisposable:[RACDisposable disposableWithBlock:^{
@strongify(otherDisposable);
[selfDisposable removeDisposable:otherDisposable];
}]];
}

@end
{% endhighlight %}

而此类正式集成了上面的RACSubscriber协议，而且也按规定实现了sendNext、sendError、sendCompleted、didSubscribeWithDisposable
此类会把刚才的block保存在自己的next属性中，另外看看sendCompleted和sendError函数，可以看到里面调用了[self.disposable dispose];所以会在sendCompleted和sendError动作里面有个清理的行为
然后再继续看RACDynamicSignal的subscribe的函数

可以看到实际上 `[peaKiller subscribeNext:`的参数实际上是传到了 `[RACSignal createSignal:`的block的入口参数里。
所以 
{% highlight objective-c %}
//发射第一发豌豆子弹
[subscriber sendNext:@(hurtNumer)];
{% endhighlight %}
实际上 执行了一次`[peaKiller subscribeNext:`所传的block。

上面就是一个豌豆射手是如何创建的 如何使用的。



再来看看第二次使用豌豆射手  map ，map实际上对数据豌豆子弹修改，比如加上冰或者火的属性
由于时间关系，具体代码下次再来看

