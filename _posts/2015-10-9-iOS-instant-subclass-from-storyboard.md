---
layout: post
title: 如何实例化一个从故事板中继承的子类
---

摘要：今天有一个这样的需求，一个界面ViewControllerA用故事版storyboard布局，另外一个界面ViewControllerB跟这个界面极其相似，可以用ViewControllerB类继承ViewControllerA，那么在用的时候如何实例化这个ViewControllerB类呢


##解决方案

[stackoverflow](http://stackoverflow.com/questions/14111572/how-to-use-single-storyboard-uiviewcontroller-for-multiple-subclass)

1、按下`option`键，然后鼠标按下故事版中ViewControllerA黄色对象进行拖动，拖到故事版中，直到鼠标地方出现一个绿色加号然后松开鼠标

2、这时候有两个ViewControllerA重叠在了一起，将上面的拖动，拖到一个空白的地方

3、将刚才拖动的对象的class 和 storyboardid 都改为ViewControllerB

{% highlight objc %}

UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
ViewControllerB* modal=[mainStoryboard instantiateViewControllerWithIdentifier:@"ViewControllerB"];
[self.navigationController pushViewController:modal animated:YES];

{% endhighlight %}

![](http://i.stack.imgur.com/NiXj4.gif)