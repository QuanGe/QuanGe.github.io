---
layout: post
title: iOS充电日记－－关于NSRunLoop
---

##NSRunLoop是什么鬼
A run loop is very much like its name sounds. It is a loop your thread enters and uses to run event handlers in response to incoming events. Your code provides the control statements used to implement the actual loop portion of the run loop—in other words, your code provides the while or for loop that drives the run loop. Within your loop, you use a run loop object to "run” the event-processing code that receives events and calls the installed handlers.

The `NSRunLoop` class declares the programmatic interface to objects that manage input sources. An `NSRunLoop` object processes input for sources such as mouse and keyboard events from the window system, `NSPort` objects, and `NSConnection` objects. An `NSRunLoop` object also processes `NSTimer `events.

Your application cannot either create or explicitly manage `NSRunLoop` objects. Each `NSThread` object, including the application’s main thread, has an `NSRunLoop` object automatically created for it as needed. If you need to access the current thread’s run loop, you do so with the class method currentRunLoop.

Note that from the perspective of `NSRunloop`, `NSTimer` objects are not "input"—they are a special type, and one of the things that means is that they do not cause the run loop to return when they fire.

The `NSRunLoop` class is generally not considered to be thread-safe and its methods should only be called within the context of the current thread. You should never try to call the methods of an NSRunLoop object running in a different thread, as doing so might cause unexpected results.

##工作当中哪些会受其影响
当界面中有UIScrollView时，滑动UIScrollView有两样东西会受其影响：NSTimer和NSConnection。

测试核心代码为：[工程下载地址](https://github.com/QuanGe/TestAllInOne/tree/master/RunLoooopTest)

{% highlight objc %}
//
//  ViewController.m
//  RunLoooopTest
//
//  Created by 张如泉 on 15/9/24.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *dataTable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //**********************测试效果的方法：当控制台输出4时不停拖动tableview************************
    
    //这种方法的timer会被scrollview的滑动暂停
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(printLog:) userInfo:nil repeats:YES];
    
    //这种方法的timer不会被scrollview的滑动暂停
    NSTimer * timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(testURLConnection:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    [self.dataTable addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)printLog:(id)sender
{
    NSLog(@"%@",@(++self.view.tag));
    if(self.view.tag == 5)
        NSLog(@"开始访问网络");
}

- (void)testURLConnection:(id)sender
{
    //这种方式的的NSURLConnection不会被scrollview暂停 但是同样无法进行取消操作
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com"] ] queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"返回github结果");
    }];
    
    //这种方式的的NSURLConnection会被scrollview暂停 但是可以进行取消操作
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://code.csdn.net"] ]delegate:self startImmediately:NO];
    //加上这句话就不会被scrollView暂停
    //[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [connection start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RLTCell"];
    
    
    return cell;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offest = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        if(offest.y != 0)
            NSLog(@"滑动中。。。。");
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"返回百度结果");
    
}
@end

{% endhighlight %}

## 受影响原因
主线程的 Runloop 的RunloopMode 默认为 NSDefaultRunLoopMode，当用户滚动 tableview 或 scrollview 时，主线程的 Runloop 是处于 NSEventTrackingRunLoopMode 模式下的，不会执行 NSDefaultRunLoopMode 的任务，所以会出现一个问题，请求发出后，如果用户一直在操作UI上下滑动屏幕，那在滑动结束前是不会执行回调函数的，只有在滑动结束，RunloopMode 切回 NSDefaultRunLoopMode，才会执行回调函数。苹果一直把动画效果性能放在第一位，估计这也是苹果提升UI动画性能的手段之一。