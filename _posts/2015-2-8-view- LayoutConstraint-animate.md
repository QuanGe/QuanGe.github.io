---
layout: post
title: 控件位移动画用NSLayoutConstraint来实现
---

现在很多项目都用autolayout布局了，如果实现一个空间从左到右的一个切入动画，可以通过设置位置`NSLayoutConstraint.constant`来实现，例如

{% highlight objc %}
[UIView animateWithDuration:0.5 animations:^{
            
            self.m_pEditLeft.constant = 0.0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
{% endhighlight %}

其中必须要调用`layoutIfNeeded`才可以，否则没有效果，在此做个笔记。