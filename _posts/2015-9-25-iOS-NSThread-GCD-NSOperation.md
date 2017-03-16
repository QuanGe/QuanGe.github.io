---
layout: post
title: iOS充电日记－－关于多线程
---

摘要：多线程，无论哪种开发平台都会遇到的，iOS开发中有三种可以用来实现多线程，NSThread、NSOperation、GCD（Grand-Central-Dispatch），每个人的习惯不太一样，他们三种也各有千秋，下面我们就来分析下各自的特点

个人猜测，这三种方式的代码实现 都是用了libpthread,因为我们可以从 [libdispatch](http://opensource.apple.com/tarballs/libdispatch/)的源码中可以看到`private.h`头文件中`#include <pthread.h>`,而且代码中有`pthread_create`创建线程

## NSThread

### 使用
使用方法有两个

{% highlight objc %}
// 类方法 调用之后立马启动线程
[NSThread detachNewThreadSelector:@selector(doSomething:) toTarget:self withObject:nil];

// 实例方法的声明 需要手动start后才会启动，还可以在启动线程之前，对线程进行配置，比如设置stack大小，线程优先级
NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                        selector:@selector(doSomething:)
                                        object:nil];
// 实例方法的调用
[myThread start];
{% endhighlight %}

还有一种间接的方式，更加方便，我们甚至不需要显式编写`NSThread`相关代码。那就是利用`NSObject`的类方法`performSelectorInBackground:withObject:`来创建一个线程：

{% highlight objc %}
[myObj performSelectorInBackground:@selector(myThreadMainMethod) withObject:nil];
{% endhighlight %}

其效果与`NSThread`的` detachNewThreadSelector:toTarget:withObject: `是一样的


### 线程同步

在这我想先提一个词`原子操作`，我们在写`@property`的时候经常有关键字`nonatomic`或`atomic`，其中atomic为原子操作，提供多线程安全，在多线程环境下，原子操作是必要的，否则有可能引起错误的结果。加了atomic，setter函数会变成下面这样

{% highlight objc %}
 {lock}
    if (property != newValue) { 
        [property release]; 
        property = [newValue retain]; 
    }
{unlock}
{% endhighlight %}

而`nonatomic` 禁止多线程，变量保护，提高性能。

atomic是Objc使用的一种线程保护技术，基本上来讲，是防止在写未完成的时候被另外一个线程读取，造成数据错误。而这种机制是耗费系统资源的，所以在iPhone这种小型设备上，如果没有使用多线程间的通讯编程，那么nonatomic是一个非常好的选择。

而这里我们线程同步的时候需要用原子操作保证线程安全，方案有三种种分别是NSLock和NSCodition和@synchronized

{% highlight objc %}
//第一种
NSLock *theLock = [[NSLock alloc] init];
[theLock lock];
/* Do Something */
[theLock unlock];

//第二种
NSCondition ＊theCondition = [[NSCondition alloc] init]; 
[theCondition lock];
/*DO Something */
[theCondition unlock];

//第三种
@synchronized(anObj)
{
    /*DO Something */
}
{% endhighlight %}

### 线程通信
线程在运行过程中，可能需要与其它线程进行通信。我们可以使用 NSObject 中的一些方法：
{% highlight objc %}
// 在应用程序主线程中做事情：
performSelectorOnMainThread:withObject:waitUntilDone:
performSelectorOnMainThread:withObject:waitUntilDone:modes:

// 在指定线程中做事情：
performSelector:onThread:withObject:waitUntilDone:
performSelector:onThread:withObject:waitUntilDone:modes:

// 在当前线程中做事情：
performSelector:withObject:afterDelay:
performSelector:withObject:afterDelay:inModes:

// 取消发送给当前线程的某个消息
cancelPreviousPerformRequestsWithTarget:
cancelPreviousPerformRequestsWithTarget:selector:object:
{% endhighlight %}

### 其他

1、由于需要手动处理线程同步，所以有可能造成死锁现象。

2、每个NSThread对象中都有NSRunLoop，可以用来处理网络等。

3、可以sleep

5、可以设置栈大小

6、主线程栈内存大小为1M，子线程默认为512k，而且子线程最小栈内存为16k，而且必须是4的倍数。

7、可以用setThreadPriority来设置线程优先级

## NSOperation
 
<blockquote>
The `NSOperation` class is an `abstract` class you use to encapsulate the code and data associated with a single task. Because it is `abstract`, you do not use this class directly but instead subclass or use one of the system-defined subclasses (`NSInvocationOperation` or `NSBlockOperation`) to perform the actual task. Despite being abstract, the base implementation of `NSOperation` does include significant logic to coordinate the safe execution of your task. The presence of this built-in logic allows you to focus on the actual implementation of your task, rather than on the glue code needed to ensure it works correctly with other system objects.

An operation object is a single-shot object—that is, it executes its task once and cannot be used to execute it again. You typically execute operations by adding them to an operation queue (an instance of the `NSOperationQueue` class). An operation queue executes its operations either directly, by running them on secondary threads, or indirectly using the libdispatch library (also known as Grand Central Dispatch). For more information about how queues execute operations, see NSOperationQueue Class Reference.

If you do not want to use an operation queue, you can execute an operation yourself by calling its `start` method directly from your code. Executing operations manually does put more of a burden on your code, because starting an operation that is not in the ready state triggers an exception. The ready property reports on the operation’s readiness.
</blockquote>

### 使用

由上面的官方文档可以看到NSOperation使用的时候有三种方式：NSInvocationOperation、NSBlockOperation、继承NSOperation的子类，因为NSOperation是一个抽象类

{% highlight objc %}

//第一种
NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self   
                                                                           selector:@selector(downloadImage:)   
                                                                             object:kURL];   
//第二种
NSBlockOperation *theBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
        /* Do Something */
    }];

//将Operation放入队列中执行
NSOperationQueue *queue = [[NSOperationQueue alloc]init];   
[queue addOperation:operation];   

{% endhighlight %}

<blockquote>
The `NSOperation` class provides the basic logic to track the execution state of your operation but otherwise must be subclassed to do any real work. How you create your subclass depends on whether your operation is designed to execute concurrently or non-concurrently.

Methods to Override
For non-concurrent operations, you typically override only one method:

`main`

Into this method, you place the code needed to perform the given task. Of course, you should also define a custom initialization method to make it easier to create instances of your custom class. You might also want to define getter and setter methods to access the data from the operation. However, if you do define custom getter and setter methods, you must make sure those methods can be called safely from multiple threads.

If you are creating a concurrent operation, you need to override the following methods and properties at a minimum:

`start`

`asynchronous`

`executing`

`finished`
</blockquote>
如果用第三种的话，对于那种非并发（non-concurrent）的NSOperation，你只要重载`main`函数，在这个函数里，你可以写想要在此线程实现的东西。当然你也应该自定义你自己的init，更方便的实力化你自己的类。如果你自定义了`getter`和`setter`方法，你必须确保这些方法可以在多线程中能保证线程安全。

而对于那种并发（concurrent）的NSOperation，你需要重载以下方法或属性`start`、`asynchronous`、`executing`、`finished`

###其他
1、Dependencies，你可以通过`addDependency:` 和 `removeDependency:`自己添加删除NSOperation之间的依赖，
2、NSOperation支持KVC和KVO，如果你想用观察其属性，应该用以下key paths：`isCancelled`、`isAsynchronous`、`isExecuting`、`isFinished`、`isReady`、`dependencies`、`queuePriority`、`completionBlock`
3、NSOperationQueue可以通过maxConcurrentOperationCount来设置并发数。
4、iOS8用qualityOfService，iOS4至iOS7用threadPriority来设置线程优先级
 

## GCD(Grand Central Dispatch) 

Grand Central Dispatch (GCD) 是 Apple 开发的一个多核编程的解决方法。该方法在 Mac OS X 10.6 雪豹中首次推出，并随后被引入到了 iOS4.0 中。GCD 是一个替代诸如 NSThread, NSOperationQueue, NSInvocationOperation 等技术的很高效和强大的技术。

### 使用
我们先来说说常用的libdispatch库的一些函数

{% highlight objc %}
//异步执行某个线程
dispatch_async(somequeue,^{})  
//同步执行某个线程
dispatch_sync(somequeue,^{})  
//得到一个子线程
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) 
//得到一个时间
dispatch_time_t popTime ＝ dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC))  
//延迟执行某个操作
dispatch_after(someTime,someQueue,^{})
//得到住线程
dispatch_get_main_queue()
//只执行一次 常用来实现单例模式
dispatch_once(&onceToken, ^{})
//创建一个自定义子线程
dispatch_queue_t urls_queue = dispatch_queue_create("blog.devtang.com", NULL);
//创建一个线程组
dispatch_group_t group = dispatch_group_create();
//并行执行的线程一
 dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
      
 });
 //并行执行的线程二
 dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
      
 });
 //汇总结果
 dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
      
 });

{% endhighlight %}

dispatch_barrier_async的作用是什么？

在并行队列中，为了保持某些任务的顺序，需要等待一些任务完成后才能继续进行，使用 barrier 来等待之前任务完成，避免数据竞争等问题。 dispatch_barrier_async 函数会等待追加到Concurrent Dispatch Queue并行队列中的操作全部执行完之后，然后再执行 dispatch_barrier_async 函数追加的处理，等 dispatch_barrier_async 追加的处理执行结束之后，Concurrent Dispatch Queue才恢复之前的动作继续执行。

打个比方：比如你们公司周末跟团旅游，高速休息站上，司机说：大家都去上厕所，速战速决，上完厕所就上高速。超大的公共厕所，大家同时去，程序猿很快就结束了，但程序媛就可能会慢一些，即使你第一个回来，司机也不会出发，司机要等待所有人都回来后，才能出发。 dispatch_barrier_async 函数追加的内容就如同 “上完厕所就上高速”这个动作。

（注意：使用 dispatch_barrier_async ，该函数只能搭配自定义并行队列 dispatch_queue_t 使用。不能使用： dispatch_get_global_queue ，否则 dispatch_barrier_async 的作用会和 dispatch_async 的作用一模一样。 ）

{% highlight objc %}
dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
dispatch_async(concurrentQueue, ^(){
    NSLog(@"dispatch-1");
});
dispatch_async(concurrentQueue, ^(){
    NSLog(@"dispatch-2");
});
dispatch_barrier_async(concurrentQueue, ^(){
    NSLog(@"dispatch-barrier"); 
});
dispatch_async(concurrentQueue, ^(){
    NSLog(@"dispatch-3");
});
dispatch_async(concurrentQueue, ^(){
    NSLog(@"dispatch-4");
});
{% endhighlight %}

dispatch_barrier_async 作用是在并行队列中，等待前面两个操作并行操作完成，这里是并行输出
dispatch-1，dispatch-2
然后执行
dispatch_barrier_async中的操作，(现在就只会执行这一个操作)执行完成后，即输出
"dispatch-barrier，
最后该并行队列恢复原有执行状态，继续并行执行


### block

block语法很像C里的函数指针，只不过把＊换成了^
定义一个不带参数的block
{% highlight objc %}
//第一种
void (^simpleBlock)(void);
simpleBlock = ^{
        NSLog(@"This is a block");
    };

//第二种
void (^simpleBlock)(void) = ^{
        NSLog(@"This is a block");
    };
//调用
 simpleBlock();
{% endhighlight %}

定义一个带参数的block
{% highlight objc %}
//第一种
double (^multiplyTwoValues)(double, double);
 multiplyTwoValues ＝ ^ double (double firstValue, double secondValue) {
        return firstValue * secondValue;
    }；

//第二种
double (^multiplyTwoValues)(double, double) =
                              ^(double firstValue, double secondValue) {
                                  return firstValue * secondValue;
                              };
//调用
double result = multiplyTwoValues(2,4);
NSLog(@"The result is %f", result);
{% endhighlight %}

使用注意：
1、使用 block 定义异步接口:

{% highlight objc %}
- (void)downloadObjectsAtPath:(NSString *)path
                   completion:(void(^)(NSArray *objects, NSError *error))completion;
{% endhighlight %}

当你定义一个类似上面的接口的时候，尽量使用一个单独的 block 作为接口的最后一个参数。把需要提供的数据和错误信息整合到一个单独 block 中，比分别提供成功和失败的 block 要好。

以下是你应该这样做的原因：


* 通常这成功处理和失败处理会共享一些代码（比如让一个进度条或者提示消失）；
* Apple 也是这样做的，与平台一致能够带来一些潜在的好处；
* block 通常会有多行代码，如果不作为最后一个参数放在后面的话，会打破调用点；
* 使用多个 block 作为参数可能会让调用看起来显得很笨拙，并且增加了复杂性。

看上面的方法，完成处理的 block 的参数很常见：第一个参数是调用者希望获取的数据，第二个是错误相关的信息。这里需要遵循以下两点：

* 若 `objects` 不为 nil，则 `error` 必须为 nil
* 若 `objects` 为 nil，则 `error` 必须不为 nil

因为调用者更关心的是实际的数据，就像这样：


{% highlight objc %}
- (void)downloadObjectsAtPath:(NSString *)path
                   completion:(void(^)(NSArray *objects, NSError *error))completion {
    if (objects) {
        // do something with the data
    }
    else {
        // some error occurred, 'error' variable should not be nil by contract
    }
}
{% endhighlight %}


此外，Apple 提供的一些同步接口在成功状态下向 error 参数（如果非 NULL) 写入了垃圾值，所以检查 error 的值可能出现问题。

2、一些关键点：

* block 是在栈上创建的 
* block 可以复制到堆上
* Block会捕获栈上的变量(或指针)，将其复制为自己私有的const(变量)。
* (如果在Block中修改Block块外的)栈上的变量和指针，那么这些变量和指针必须用`__block`关键字申明(译者注：否则就会跟上面的情况一样只是捕获他们的瞬时值)。


如果 block 没有在其他地方被保持，那么它会随着栈生存并且当栈帧（stack frame）返回的时候消失。仅存在于栈上时，block对对象访问的内存管理和生命周期没有任何影响。

如果 block 需要在栈帧返回的时候存在，它们需要明确地被复制到堆上，这样，block 会像其他 Cocoa 对象一样增加引用计数。当它们被复制的时候，它会带着它们的捕获作用域一起，retain 他们所有引用的对象。

如果一个 block引用了一个栈变量或指针，那么这个block初始化的时候会拥有这个变量或指针的const副本，所以(被捕获之后再在栈中改变这个变量或指针的值)是不起作用的。(译者注：所以这时候我们在block中对这种变量进行赋值会编译报错:`Variable is not assignable(missing __block type specifier)`，因为他们是副本而且是const的.具体见下面的例程)。

当一个 block 被复制后，`__block` 声明的栈变量的引用被复制到了堆里，复制完成之后，无论是栈上的block还是刚刚产生在堆上的block(栈上block的副本)都会引用该变量在堆上的副本。

(下面代码是译者加的)

{% highlight objc %}
   ...
   CGFloat blockInt = 10;
   void (^playblock)(void) = ^{
        NSLog(@"blockInt = %zd", blockInt);
    };
    blockInt ++;
    playblock();
    ...
    
    //结果为:blockInt = 10
{% endhighlight %}


最重要的事情是 `__block` 声明的变量和指针在 block 里面是作为显示操作真实值/对象的结构来对待的。


block 在 Objective-C 的 runtime(运行时) 里面被当作一等公民对待：他们有一个 `isa` 指针，一个类也是用 `isa` 指针在Objective-C 运行时来访问方法和存储数据的。在非 ARC 环境肯定会把它搞得很糟糕，并且悬挂指针会导致 crash。`__block` 仅仅对 block 内的变量起作用，它只是简单地告诉 block：

> 嗨，这个指针或者原始的类型依赖它们在的栈。请用一个栈上的新变量来引用它。我是说，请对它进行双重解引用，不要 retain 它。
谢谢，哥们。


如果在定义之后但是 block 没有被调用前，对象被释放了，那么 block 的执行会导致 crash。 `__block`  变量不会在 block 中被持有，最后... 指针、引用、解引用以及引用计数变得一团糟。

[blocks_uth1]:  http://developer.apple.com/library/ios/#documentation/cocoa/Conceptual/Blocks/Articles/00_Introduction.html
[blocks_uth2]: http://ios-blog.co.uk/tutorials/programming-with-blocks-an-overview/

3、self 的循环引用


当使用代码块和异步分发的时候，要注意避免引用循环。 总是使用 `weak` 来引用对象，避免引用循环。（译者注：这里更为优雅的方式是采用影子变量@weakify/@strongify [这里有更为详细的说明](https://github.com/jspahrsummers/libextobjc/blob/master/extobjc/EXTScope.h)） 此外，把持有 block 的属性设置为 nil (比如 `self.completionBlock = nil`) 是一个好的实践。它会打破 block 捕获的作用域带来的引用循环。


**例子:**

{% highlight objc %}
__weak __typeof(self) weakSelf = self;
[self executeBlock:^(NSData *data, NSError *error) {
    [weakSelf doSomethingWithData:data];
}];
{% endhighlight %}

**不要这样:**

{% highlight objc %}
[self executeBlock:^(NSData *data, NSError *error) {
    [self doSomethingWithData:data];
}];
{% endhighlight %}

**多个语句的例子:**

{% highlight objc %}
__weak __typeof(self)weakSelf = self;
[self executeBlock:^(NSData *data, NSError *error) {
    __strong __typeof(weakSelf) strongSelf = weakSelf;
    if (strongSelf) {
        [strongSelf doSomethingWithData:data];
        [strongSelf doSomethingWithData:data];
    }
}];
{% endhighlight %}

**不要这样:**

{% highlight objc %}
__weak __typeof(self)weakSelf = self;
[self executeBlock:^(NSData *data, NSError *error) {
    [weakSelf doSomethingWithData:data];
    [weakSelf doSomethingWithData:data];
}];
{% endhighlight %}


你应该把这两行代码作为 snippet 加到 Xcode 里面并且总是这样使用它们。

{% highlight objc %}
__weak __typeof(self)weakSelf = self;
__strong __typeof(weakSelf)strongSelf = weakSelf;
{% endhighlight %}

这里我们来讨论下 block 里面的 self 的 `__weak` 和 `__strong`  限定词的一些微妙的地方。简而言之，我们可以参考 self 在 block 里面的三种不同情况。

1. 直接在 block 里面使用关键词 self
2. 在 block 外定义一个 `__weak` 的 引用到 self，并且在 block 里面使用这个弱引用
3. 在 block 外定义一个 `__weak` 的 引用到 self，并在在 block 内部通过这个弱引用定义一个 `__strong`  的引用。


**方案 1. 直接在 block 里面使用关键词 `self`**

如果我们直接在 block 里面用 self 关键字，对象会在 block 的定义时候被 retain，（实际上 block 是 [copied][blocks_caveat13]  但是为了简单我们可以忽略这个）。一个 const 的对 self 的引用在 block 里面有自己的位置并且它会影响对象的引用计数。如果这个block被其他的类使用并且(或者)彼此间传来传去，我们可能想要在 block 中保留 self，就像其他在 block 中使用的对象一样. 因为他们是block执行所需要的.

{% highlight objc %}
dispatch_block_t completionBlock = ^{
    NSLog(@"%@", self);
}

MyViewController *myController = [[MyViewController alloc] init...];
[self presentViewController:myController
                   animated:YES
                 completion:completionHandler];
{% endhighlight %}


没啥大不了。但是如果通过一个属性中的 `self` 保留 了这个 block（就像下面的例程一样）,对象( self )保留了 block 会怎么样呢？

{% highlight objc %}
self.completionHandler = ^{
    NSLog(@"%@", self);
}

MyViewController *myController = [[MyViewController alloc] init...];
[self presentViewController:myController
                   animated:YES
                 completion:self.completionHandler];
{% endhighlight %}


这就是有名的 retain cycle, 并且我们通常应该避免它。这种情况下我们收到 CLANG 的警告：

{% highlight objc %}
Capturing 'self' strongly in this block is likely to lead to a retain cycle （在 block 里面发现了 `self` 的强引用，可能会导致循环引用）
{% endhighlight %}
所以 `__weak` 就有用武之地了。

**方案 2. 在 block 外定义一个 `__weak` 的 引用到 self，并且在 block 里面使用这个弱引用**


这样会避免循坏引用，也是通常情况下我们的block作为类的属性被self retain 的时候会做的。

{% highlight objc %}
__weak typeof(self) weakSelf = self;
self.completionHandler = ^{
    NSLog(@"%@", weakSelf);
};

MyViewController *myController = [[MyViewController alloc] init...];
[self presentViewController:myController
                   animated:YES
                 completion:self.completionHandler];
{% endhighlight %}


这个情况下 block 没有 retain 对象并且对象在属性里面 retain 了 block 。所以这样我们能保证了安全的访问 self。 不过糟糕的是，它可能被设置成 nil 的。问题是：如何让 self 在 block 里面安全地被销毁。

考虑这么个情况：block 作为属性(property)赋值的结果，从一个对象被复制到另一个对象(如 myController)，在这个复制的 block 执行之前，前者（即之前的那个对象）已经被解除分配。

下面的更有意思。

**方案 3. 在 block 外定义一个 `__weak` 的 引用到 self，并在在 block 内部通过这个弱引用定义一个 `__strong`  的引用**

你可能会想，首先，这是避免 retain cycle  警告的一个技巧。

这不是重点，这个 self 的强引用是在block 执行时 被创建的，但是否使用 self 在 block 定义时就已经定下来了， 因此self (在block执行时) 会被 retain.

[Apple 文档][blocks_caveat1] 中表示 "为了 non-trivial cycles ，你应该这样" ：

{% highlight objc %}
MyViewController *myController = [[MyViewController alloc] init...];
// ...
MyViewController * __weak weakMyController = myController;
myController.completionHandler =  ^(NSInteger result) {
    MyViewController *strongMyController = weakMyController;
    if (strongMyController) {
        // ...
        [strongMyController dismissViewControllerAnimated:YES completion:nil];
        // ...
    }
    else {
        // Probably nothing...
    }
};
{% endhighlight %}


首先，我觉得这个例子看起来是错误的。如果 block 本身在 completionHandler 属性中被 retain 了，那么 self 如何被 delloc 和在 block 之外赋值为 nil 呢? completionHandler 属性可以被声明为  `assign` 或者 `unsafe_unretained` 的，来允许对象在 block 被传递之后被销毁。

我不能理解这样做的理由，如果其他对象需要这个对象（self），block 被传递的时候应该 retain 对象，所以 block 应该不被作为属性存储。这种情况下不应该用 `__weak`/`__strong` 

总之，其他情况下，希望 weakSelf 变成 nil 的话，就像第二种情况解释那么写（在 block 之外定义一个弱应用并且在 block 里面使用）。

还有，Apple的 "trivial block" 是什么呢。我们的理解是 trivial block 是一个不被传送的 block ，它在一个良好定义和控制的作用域里面，weak 修饰只是为了避免循环引用。


虽然有 Kazuki Sakamoto 和 Tomohiko Furumoto) 讨论的 [一][blocks_caveat2] [些][blocks_caveat3] [的][blocks_caveat4] [在线][blocks_caveat5] [参考][blocks_caveat6],  [Matt Galloway][blocks_caveat16] 的 ([Effective Objective-C 2.0][blocks_caveat14] 和 [Pro Multithreading and Memory Management for iOS and OS X][blocks_caveat15] ，大多数开发者始终没有弄清楚概念。

在 block 内用强引用的优点是，抢占执行的时候的鲁棒性。在 block 执行的时候, 再次温故下上面的三个例子：

**方案 1. 直接在 block 里面使用关键词 `self`**

如果 block 被属性 retain，self 和 block 之间会有一个循环引用并且它们不会再被释放。如果 block 被传送并且被其他的对象 copy 了，self 在每一个 copy 里面被 retain

**方案 2. 在 block 外定义一个 `__weak` 的 引用到 self，并且在 block 里面使用这个弱引用**

不管 block 是否通过属性被 retain ，这里都不会发生循环引用。如果 block 被传递或者 copy 了，在执行的时候，weakSelf 可能已经变成 nil。

block 的执行可以抢占，而且对 weakSelf 指针的调用时序不同可以导致不同的结果(如：在一个特定的时序下 weakSelf 可能会变成nil)。

{% highlight objc %}
__weak typeof(self) weakSelf = self;
dispatch_block_t block =  ^{
    [weakSelf doSomething]; // weakSelf != nil
    // preemption, weakSelf turned nil
    [weakSelf doSomethingElse]; // weakSelf == nil
};
{% endhighlight %}

**方案 3. 在 block 外定义一个 `__weak` 的 引用到 self，并在在 block 内部通过这个弱引用定义一个 `__strong`  的引用。**

不管 block 是否通过属性被 retain ，这里也不会发生循环引用。如果 block 被传递到其他对象并且被复制了，执行的时候，weakSelf 可能被nil，因为强引用被赋值并且不会变成nil的时候，我们确保对象 在 block 调用的完整周期里面被 retain了，如果抢占发生了，随后的对 strongSelf 的执行会继续并且会产生一样的值。如果 strongSelf 的执行到 nil，那么在 block 不能正确执行前已经返回了。

{% highlight objc %}
__weak typeof(self) weakSelf = self;
myObj.myBlock =  ^{
    __strong typeof(self) strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf doSomething]; // strongSelf != nil
      // preemption, strongSelf still not nil（抢占的时候，strongSelf 还是非 nil 的)
      [strongSelf doSomethingElse]; // strongSelf != nil
    }
    else {
        // Probably nothing...
        return;
    }
};
{% endhighlight %}
 
在ARC条件中，如果尝试用 `->` 符号访问一个实例变量，编译器会给出非常清晰的错误信息：

{% highlight objc %}
Dereferencing a __weak pointer is not allowed due to possible null value caused by race condition, assign it to a strong variable first. (对一个 __weak 指针的解引用不允许的，因为可能在竞态条件里面变成 null, 所以先把他定义成 strong 的属性)
{% endhighlight %}

可以用下面的代码展示

{% highlight objc %}
__weak typeof(self) weakSelf = self;
myObj.myBlock =  ^{
    id localVal = weakSelf->someIVar;
};
{% endhighlight %}


在最后

* **方案 1**: 只能在 block 不是作为一个 property 的时候使用，否则会导致 retain cycle。

* **方案 2**:  当 block 被声明为一个 property 的时候使用。

* **方案 3**: 和并发执行有关。当涉及异步的服务的时候，block 可以在之后被执行，并且不会发生关于 self 是否存在的问题。

[blocks_caveat1]: http://developer.apple.com/library/mac/#releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html
[blocks_caveat2]: http://dhoerl.wordpress.com/2013/04/23/i-finally-figured-out-weakself-and-strongself/
[blocks_caveat3]: http://blog.random-ideas.net/?p=160
[blocks_caveat4]: http://stackoverflow.com/questions/7904568/disappearing-reference-to-self-in-a-block-under-arc

[blocks_caveat5]: http://stackoverflow.com/questions/12218767/objective-c-blocks-and-memory-management
[blocks_caveat6]: https://github.com/AFNetworking/AFNetworking/issues/807
[blocks_caveat10]: https://twitter.com/pedrogomes
[blocks_caveat11]: https://twitter.com/dmakarenko
[blocks_caveat12]: https://ef.com
[blocks_caveat13]: https://developer.apple.com/library/ios/documentation/cocoa/conceptual/Blocks/Articles/bxVariables.html#//apple_ref/doc/uid/TP40007502-CH6-SW4
[blocks_caveat14]: http://www.effectiveobjectivec.com/
[blocks_caveat15]: http://www.amazon.it/Pro-Multithreading-Memory-Management-Ios/dp/1430241160
[blocks_caveat16]: https://twitter.com/mattjgalloway

4、属性可以存储一个代码块。为了让它存活到定义的块的结束，必须使用 copy （block 最早在栈里面创建，使用 copy让 block 拷贝到堆里面去）

5、使用 block 的另一个用处是可以让程序在后台较长久的运行。在以前，当 app 被按 home 键退出后，app 仅有最多 5 秒钟的时候做一些保存或清理资源的工作。但是应用可以调用 UIApplication 的beginBackgroundTaskWithExpirationHandler方法，让 app 最多有 10 分钟的时间在后台长久运行。这个时间可以用来做清理本地缓存，发送统计数据等工作。

让程序在后台长久运行的示例代码如下：

{% highlight objc %}
// AppDelegate.h 文件
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;

// AppDelegate.m 文件
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self beingBackgroundUpdateTask];
    // 在这里加上你需要长久运行的代码
    [self endBackgroundUpdateTask];
}

- (void)beingBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}

{% endhighlight %}

### 其他

GCD会自动利用更多的CPU内核（比如双核、四核），GCD会自动管理线程的生命周期（创建线程、调度任务、销毁线程），程序员只需要告诉GCD想要执行什么任务，不需要编写任何线程管理代码

GCD的队列可以分为2大类型：

1）并发队列（Concurrent Dispatch Queue）可以让多个任务并发（同时）执行（自动开启多个线程同时执行任务）并发功能只有在异步（dispatch_async）函数下才有效，GCD默认已经提供了全局的并发队列，供整个应用使用，不需要手动创建，使用dispatch_get_global_queue函数获得全局的并发队列

2）串行队列（Serial Dispatch Queue）让任务一个接着一个地执行（一个任务执行完毕后，再执行下一个任务），使用dispatch_queue_create函数创建串行队列，使用dispatch_get_main_queue()获得主队列
 

