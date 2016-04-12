---
layout: post
title: 闪屏页广告点击处理 
---

### 功能描述
本来是 splash面页－》主页，但是splash点击广告以后要求splash面页－》广告详情页，但是广告详情页返回后要求是 主页

### 实现

其实无论点击与否都是 splash面页－》主页，注意两点

##### 1、跳转到主页不能用动画 

{% highlight objc %}
	let main = UIStoryboard(name: "Main", bundle: nil);
    let modal=main.instantiateViewControllerWithIdentifier("GAdvDetailViewController");
    self.navigationController?.pushViewController(modal, animated: false);
{% endhighlight %}

##### 2、在主页中做处理

比如[Girls](https://github.com/QuanGe/Girls) 项目中主页是GHomeViewController，需要实现UINavigationControllerDelegate，另外在`viewDidLoad`中

{% highlight objc %}
	self.navigationController?.delegate = self
{% endhighlight %}

另外需要实现UINavigationControllerDelegate的didShowViewController代理方法


{% highlight objc %}
	func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
       
        let frontVc = self.navigationController?.childViewControllers[0]
        let nav:GNavigationController = self.navigationController as! GNavigationController
        //这里需要重新设navigationController的代理为自己
        nav.resetDelegate()
        //这里为是否点击了广告的判断条件
        if(frontVc!.view.tag==111)
        {
        	//如果点击了广告了 则跳转到 广告详情页 同样不需要动画跳转
            let main = UIStoryboard(name: "Main", bundle: nil);
            let modal=main.instantiateViewControllerWithIdentifier("GAdvDetailViewController");
            self.navigationController?.pushViewController(modal, animated: false);
        }
    }

{% endhighlight %}