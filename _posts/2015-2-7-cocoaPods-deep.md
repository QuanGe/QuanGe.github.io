---
layout: post
title: CocoaPods的使用搭建环境之Today Extension
---

当你的项目中有IOS 8 的Today Extension项目时，执行 

```
$ pod install 
```

不会报错，也能生成项目workspace,但是在Today Extension项目里引用头文件
{% highlight objc %}
#import "AFNetworking.h"
#import "UALogger.h"
{% endhighlight %}

修改 viewDidLoad函数如下
{% highlight objc %}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
               
                break;
            }
            default:
                break;
        }
        
        UALog(@"网络状态数字返回：%i", status);
        UALog(@"网络状态返回: %@", AFStringFromNetworkReachabilityStatus(status));
        
    }];

}

{% endhighlight %}

编译会报错误，提示找不到文件，我的主项目起的名字为 testPodToday，Today Extension项目起的名字为News，经过查看项目配置文件发现News里pod没有配置头文件路径，于是自己添加

```
"${PODS_ROOT}/Headers/Public" "${PODS_ROOT}/Headers/Public/AFNetworking" "${PODS_ROOT}/Headers/Public/MBProgressHUD" "${PODS_ROOT}/Headers/Public/ReactiveCocoa" "${PODS_ROOT}/Headers/Public/ReactiveCocoa/ReactiveCocoa" "${PODS_ROOT}/Headers/Public/ReactiveViewModel" "${PODS_ROOT}/Headers/Public/UALogger"
```

到`<Header Search Paths>`里，并拉到最下面定义`<User-Defined>`如：`key:PODS_ROOT value:${SRCROOT}/Pods`
好了，再编译，这次报的是

`"_AFStringFromNetworkReachabilityStatus", referenced from:
___34-[TodayViewController viewDidLoad]_block_invoke in TodayViewController.o`

即找不到pod lib库，
回到项目配置文件 将

```
-ObjC -l"Pods-AFNetworking" -l"Pods-MBProgressHUD" -l"Pods-ReactiveCocoa" -l"Pods-ReactiveViewModel" -l"Pods-UALogger" -framework "CoreGraphics" -framework "MobileCoreServices" -framework "Security" -framework "SystemConfiguration"
```

添加到<Other Linker Flags>的value中，然后点击Xcode的Build Phases，在下面的<link Binary With Libraries>的选项点＋号选择`LibPods.a`

Add .然后编译
好了，已经编译成功了，大功告成
相关代码已传到code.csdn 
[代码传送门](https://code.csdn.net/woashizhangsi/ios-test-pod)

