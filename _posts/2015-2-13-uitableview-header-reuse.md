---
layout: post
title: UITableViewHeaderFooterView 重用
---

##UITableViewHeaderFooterView 到底重用了没有

在做问答模块的时候问题使用的UITableViewHeaderFooterView，答案使用的UITableViewCell，当我执行 tableview reload的时候，每个 UITableViewHeaderFooterView都会重新创建，根本没有重用，而UITableViewCell 却没有问题，代码如下
{% highlight objc %}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    NSString * identy =@"AskListTableViewHeader";
    
    AskListTableViewHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identy];
    if(header == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:identy bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:identy];
        header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identy];
    }

    return header;
}
{% endhighlight %}

每次reload 执行以后 dequeueReusableHeaderFooterViewWithIdentifier 总是调用AskListTableViewHeader 的awakeFromNib 内存是暴涨。

##怎么解决

1、google了一下，发现了[这篇文章](http://isaacschmidt.com/archives/383),大致思想是建一个UIViewController的子类，里面有个NSMutableDictionary的属性，来保存缓存的header，然后再实现两个方法
{% highlight objc %}
-(void)registerTableHeader:(id)view forReuseIdentifier:(NSString *)reuseIdentifier
{
    NSMutableArray *arrayForIdentifier = [self.m_pReusableHeaders objectForKey:reuseIdentifier];
    if (arrayForIdentifier == nil)
    {
        arrayForIdentifier = [[NSMutableArray alloc] init]; //creates an array to store views sharing a reuse identifier if one does not exist
        [self.m_pReusableHeaders  setObject:arrayForIdentifier forKey:reuseIdentifier];
    }
    
    [arrayForIdentifier addObject:view];
    
}


-   (id)reusableHeadersForReuseIdentifier:(NSString *)reuseIdentifier
{
    NSArray *arrayOfViewsForIdentifier = [self.m_pReusableHeaders  objectForKey:reuseIdentifier];
    if (arrayOfViewsForIdentifier == nil)
    {
        return nil;
    }
    
    NSInteger indexOfAvailableController = [arrayOfViewsForIdentifier indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
    {
        return  [obj superview] == nil;   //If my view doesn’t have a superview, it’s not on-screen.
    }];
    
    if (indexOfAvailableController != NSNotFound)
    {
        id availableHeader = [arrayOfViewsForIdentifier objectAtIndex:indexOfAvailableController];
        return availableHeader;    //Success!
    }
    
    return nil;
    
}
{% endhighlight %}

2、创建一个uitableview的category，利用oc运行时编程 为其添加属性保存nib及header，并且替换掉原来的`registerNib: forHeaderFooterViewReuseIdentifier:`和`dequeueReusableHeaderFooterViewWithIdentifier:`。头文件`UITableView+ReuseHeader.h`内容为
{% highlight objc %}
#import <UIKit/UIKit.h>

@interface UITableView (ReuseHeader)
@property(nonatomic,strong) NSMutableDictionary * reusableHeaders;
@property(nonatomic,strong) NSMutableDictionary * headersNibDic;
- (id)dequeueReusableHeaderOrFooterViewWithIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forHeaderOrFooterViewReuseIdentifier:(NSString *)identifier;
@end
{% endhighlight %}

`UITableView+ReuseHeader.m`内容为
{% highlight objc %}
#import "UITableView+ReuseHeader.h"

@implementation UITableView (ReuseHeader)

+ (void)load {
    [super load];
    Method registNibForHeaderFooter = class_getInstanceMethod(self, @selector(registerNib: forHeaderFooterViewReuseIdentifier:));
    Method registNibForHeaderOrFooter = class_getInstanceMethod(self, @selector(registerNib:forHeaderOrFooterViewReuseIdentifier:));
    method_exchangeImplementations(registNibForHeaderFooter, registNibForHeaderOrFooter);
    
    Method dequeueReusableHeaderFooter = class_getInstanceMethod(self, @selector(dequeueReusableHeaderFooterViewWithIdentifier:));
    Method dequeueReusableHeaderOrFooter = class_getInstanceMethod(self, @selector(dequeueReusableHeaderOrFooterViewWithIdentifier:));
    method_exchangeImplementations(dequeueReusableHeaderFooter, dequeueReusableHeaderOrFooter);
    
}

- (void)setReusableHeaders:(NSMutableDictionary*)header {
 
    objc_setAssociatedObject(self, @selector(reusableHeaders),
                             header,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  
}

- (NSMutableDictionary*)reusableHeaders {
    return objc_getAssociatedObject(self, @selector(reusableHeaders));
}

- (void)setHeadersNibDic:(NSMutableDictionary *)nibs {
    
    objc_setAssociatedObject(self, @selector(headersNibDic),
                             nibs,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSMutableDictionary*)headersNibDic {
    return objc_getAssociatedObject(self, @selector(headersNibDic));
}


-(void)registerTableHeader:(id)view forReuseIdentifier:(NSString *)reuseIdentifier
{
   
    NSMutableArray *arrayForIdentifier = [self.reusableHeaders objectForKey:reuseIdentifier];
    [arrayForIdentifier addObject:view];
}


- (id)dequeueReusableHeaderOrFooterViewWithIdentifier:(NSString *)identifier

{
    NSArray *arrayOfViewsForIdentifier = [self.reusableHeaders  objectForKey:identifier];
    if (arrayOfViewsForIdentifier == nil)
    {
        return nil;
    }
    
    NSInteger indexOfAvailableController = [arrayOfViewsForIdentifier indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                                            {
                                                return  [obj superview] == nil;   //If my view doesn’t have a superview, it’s not on-screen.
                                            }];
    
    if (indexOfAvailableController != NSNotFound)
    {
        id availableHeader = [arrayOfViewsForIdentifier objectAtIndex:indexOfAvailableController];
        return availableHeader;    //Success!
    }
    else
    {
        UINib * nib = [self.headersNibDic objectForKey:identifier];
        id view = [[nib instantiateWithOwner:self.delegate options:nil] objectAtIndex:0];
        NSMutableArray *arrayForIdentifier = [self.reusableHeaders objectForKey:identifier];
        [arrayForIdentifier addObject:view];
        
        return view;
            
        
    }
    
    return nil;
    
}

- (void)registerNib:(UINib *)nib forHeaderOrFooterViewReuseIdentifier:(NSString *)identifier
{
    //
    if(self.headersNibDic ==nil)
    {
        self.headersNibDic = [NSMutableDictionary dictionary];
    }
    
    [self.headersNibDic setObject:nib
                           forKey:identifier];
    
    if(self.reusableHeaders == nil)
        self.reusableHeaders = [NSMutableDictionary  dictionary];
    NSMutableArray *arrayForIdentifier = [self.reusableHeaders objectForKey:identifier];
    if (arrayForIdentifier == nil)
    {
        arrayForIdentifier = [[NSMutableArray alloc] init]; //creates an array to store views sharing a reuse identifier if one does not exist
        [self.reusableHeaders  setObject:arrayForIdentifier forKey:identifier];
    }
    
}
@end
{% endhighlight %}

我已经把代码传到github上，具体可以通过这个[传送门](https://github.com/QuanGe/ReuseTableHeaderViewController)来查看
