---
layout: post
title: iOS 14适配之--UITableView
---

# 概览

最近升级了Xcode12 ，编译完项目发现有个bug，就是UITableView里面的部分cell无法点击，通过`Debug View Hierarchy` 发现最上面有个`UITableViewCellContentView`类型的view。
![错误原因](http://quangelab.com/images/ios14tableview.jpg)

# 如何修改

这个其实是写代码不规范造成的，正确的操作 在`UITableViewCell`自定义过程中
{% highlight objc %}
[self.contentView addSubview:self.bottomBoxView];
{% endhighlight %}
错误
{% highlight objc %}
[self addSubview:self.bottomBoxView];
{% endhighlight %}

因为代码中有大量的代码，如何快速的修复？

{% highlight objc %}
@interface UIView (FixiOS14Bug)
@end

@implementation UIView (FixiOS14Bug)
+ (void)load {
    Method addSubview = class_getInstanceMethod(self, @selector(addSubview:));
    Method customAddSubview = class_getInstanceMethod(self, @selector(customAddSubview:));
    method_exchangeImplementations(addSubview, customAddSubview);
}

-(void)customAddSubview:(UIView*)view
{
    [self customAddSubview:view];
    if ([self isKindOfClass:[UITableViewCell class]]  && ![NSStringFromClass([view class]) containsString:@"UITableViewCellContentView"]) {
       
        UITableViewCell* cell =  (UITableViewCell*)self;
        cell.contentView.hidden = [cell.contentView subviews].count == 0;
    }
}
@end
{% endhighlight %}



