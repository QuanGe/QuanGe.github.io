---
layout: post
title: iOS充电日记－－JavaScriptCore
---

摘要：最近我们客户端想实现代码高亮，由于显示网页不是用的UIWebView而是用的DTCoreText，这就需要将代码片段进行加工，那就考虑prettify.js这个文件了，如何将OC的NSString传到js里并且返回处理后的结果


##JavaScriptCore简介

OS X Mavericks 和 iOS 7 引入了 JavaScriptCore 库，它把 WebKit 的 JavaScript 引擎用 Objective-C 封装，提供了简单，快速以及安全的方式接入世界上最流行的语言。
而且JavaScriptCore是开源的哦，如果感兴趣，大家可以到[这里](https://github.com/phoboslab/JavaScriptCore-iOS)下载源码


##核心类介绍
先来看看<JavaScriptCore/JavaScriptCore.h>里面都有什么吧
{% highlight objc %}
#ifndef JavaScriptCore_h
#define JavaScriptCore_h

#include <JavaScriptCore/JavaScript.h>
#include <JavaScriptCore/JSStringRefCF.h>

#if defined(__OBJC__) && JSC_OBJC_API_ENABLED

#import "JSContext.h"
#import "JSValue.h"
#import "JSManagedValue.h"
#import "JSVirtualMachine.h"
#import "JSExport.h"

#endif

#endif /* JavaScriptCore_h */
{% endhighlight %}

里面主要有JSContext、JSValue、JSManagedValue、JSVirtualMachine、JSExport。而我们常用的只有前两个类。JSContext 是运行 JavaScript 代码的环境。一个 JSContext 是一个全局环境的实例，如果你写过一个在浏览器内运行的 JavaScript，JSContext 类似于 window。创建一个 JSContext 后，可以很容易地运行 JavaScript 代码来创建变量，做计算，甚至定义方法：
{% highlight objc %}
//第一个简单的例子
JSContext *context = [[JSContext alloc] init];
JSValue *jsVal = [context evaluateScript:@"21+7"];
int iVal = [jsVal toInt32];
NSLog(@"JSValue: %@, int: %d", jsVal, iVal);
{% endhighlight %}
任何出自 JSContext 的值都被包裹在一个 JSValue 对象中。像 JavaScript 这样的动态语言需要一个动态类型，所以 JSValue 包装了每一个可能的 JavaScript 值：字符串和数字；数组、对象和方法；甚至错误和特殊的 JavaScript 值诸如 null 和 undefined。

JSValue 包括一系列方法用于访问其可能的值以保证有正确的 Foundation 类型，包括：

{% highlight objc %}
<pre>
@textblock
   Objective-C type  |   JavaScript type
 --------------------+---------------------
         nil         |     undefined
        NSNull       |        null
       NSString      |       string
       NSNumber      |   number, boolean
     NSDictionary    |   Object object
       NSArray       |    Array object
        NSDate       |     Date object
       NSBlock (1)   |   Function object (1)
          id (2)     |   Wrapper object (2)
        Class (3)    | Constructor object (3)
@/textblock
</pre>
{% endhighlight %}


###下标值
对 JSContext 和 JSValue 实例使用下标的方式我们可以很容易地访问我们之前创建的 context 的任何值。JSContext 需要一个字符串下标，而 JSValue 允许使用字符串或整数标来得到里面的对象和数组：
{% highlight objc %}
JSContext *context = [[JSContext alloc] init];
[context evaluateScript:@"var arr = [21, 7 , 'iderzheng.com'];"];
JSValue *jsArr = context[@"arr"]; // Get array from JSContext

NSLog(@"JS Array: %@; Length: %@", jsArr, jsArr[@"length"]);
jsArr[1] = @"blog"; // Use JSValue as array
jsArr[7] = @7;

NSLog(@"JS Array: %@; Length: %d", jsArr, [jsArr[@"length"] toInt32]);

NSArray *nsArr = [jsArr toArray];
NSLog(@"NSArray: %@", nsArr);
{% endhighlight %}

你也许也有疑问他们是怎么做到的，我们可以看看JSValue的头文件可以发现
{% highlight objc %}
/*!
@category
@discussion Instances of JSValue implement the following methods in order to enable
support for subscript access by key and index, for example:

@textblock
JSValue *objectA, *objectB;
JSValue *v1 = object[@"X"]; // Get value for property "X" from 'object'.
JSValue *v2 = object[42];   // Get value for index 42 from 'object'.
object[@"Y"] = v1;          // Assign 'v1' to property "Y" of 'object'.
object[101] = v2;           // Assign 'v2' to index 101 of 'object'.
@/textblock

An object key passed as a subscript will be converted to a JavaScript value,
and then the value converted to a string used as a property name.
*/
@interface JSValue (SubscriptSupport)

- (JSValue *)objectForKeyedSubscript:(id)key;
- (JSValue *)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(id)object forKeyedSubscript:(NSObject <NSCopying> *)key;
- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index;

@end

{% endhighlight %}

这里是用了非正式协议，这里我也写了测试代码

{% highlight objc %}
//
//  JSCTest.h
//  JavaScriptCoreTest
//
//  Created by 张如泉 on 15/11/6.
//  Copyright © 2015年 quange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSCTest : NSObject

- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index;
@end

//
//  JSCTest.m
//  JavaScriptCoreTest
//
//  Created by 张如泉 on 15/11/6.
//  Copyright © 2015年 quange. All rights reserved.
//

#import "JSCTest.h"

@implementation JSCTest
- (id)objectAtIndexedSubscript:(NSUInteger)index
{
return @(110);
}
- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index
{
return;
}
@end

JSCTest *test = [[JSCTest alloc] init];
NSLog(@"测试下标取值%@",test[0]);
{% endhighlight %}

###调用方法
那么 如何调用一个在js写好的函数 ，并且传参数呢 
JSValue 包装了一个 JavaScript 函数，我们可以从 Objective-C / Swift 代码中使用 Foundation 类型作为参数来直接调用该函数。再次，JavaScriptCore 很轻松的处理了这个桥接：
{% highlight objc %}
NSString *path = [[NSBundle mainBundle]pathForResource:@"test"ofType:@"js"];
NSString *testScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
JSContext *context = [[JSContext alloc] init];
[context evaluateScript:testScript];
context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
NSLog(@"JS Error: %@", exception);
};
JSValue *function = context[@"factorial"];
JSValue *result = [function callWithArguments:@[@(10)]];
NSLog(@"10的阶乘factorial(10) = %d", [result toInt32]);
{% endhighlight %}

在这里用context.exceptionHandler可以来监测js中发生的错误

###实战

那么 我们要怎样实现我们真实的目的 通过prettify.js来高亮我们的代码呢 我一开始是这样写的

{% highlight objc %}
//
NSString *path = [[NSBundle mainBundle]pathForResource:@"test"ofType:@"js"];
NSString *testScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
JSContext *context = [[JSContext alloc] init];
[context evaluateScript:testScript];
context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
NSLog(@"JS Error: %@", exception);
};
JSValue *function = context[@"prettyPrintOne"];
JSValue *result = [function callWithArguments:@[@"main \n{\n printf(); \n}",@"cpp",@(1)]];
NSLog(@"代码转化结果 = %@", [result toString]);
{% endhighlight %}

结果js报错了 JS Error: ReferenceError: Can't find variable: document。

于是我去google，才发现，js里面如果有window document 等，但是JSContext通过alloc实例化，js引擎中根本没有这些，可以先实例化一个UIWebView，软后JSContext 通过[web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]来获取就没问题了

修改后的代码为

{% highlight objc %}
NSString *path = [[NSBundle mainBundle]pathForResource:@"prettify"ofType:@"js"];
NSString *testScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
UIWebView * web = [[UIWebView alloc] init];
JSContext *context = [web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
[context evaluateScript:testScript];
context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
NSLog(@"JS Error: %@", exception);
};
JSValue *function = context[@"prettyPrintOne"];
JSValue *result = [function callWithArguments:@[@"main \n{\n printf(); \n}",@"cpp",@(1)]];
//JSValue *result = [context evaluateScript:@"prettyPrintOne('main','cpp',1)"];
NSLog(@"factorial(10) = %@", [result toString]);
{% endhighlight %}

控制台输出
{% highlight objc %}
高亮后的结果为 = <ol class="linenums"><li value="1" class="L0"><span class="pln">main </span></li><li class="L1"><span class="pun">{</span></li><li class="L2"><span class="pln"> printf</span><span class="pun">();</span><span class="pln"> </span></li><li class="L3"><span class="pun">}</span></li></ol>
{% endhighlight %}
哇塞 很酷 有没有
[这里](https://github.com/QuanGe/TestAllInOne/tree/master/JavaScriptCoreTest)是所有代码的例子

