---
layout: post
title: UINavigationController为什么要隐藏顶部栏，自己写 
---

有二：
1、如果你实现了`scrollViewDidScroll`,打算在里面处理一些东西的话，UINavigationController它会自动调用此函数为了自动调整scrollview来实现scroll的顶部有个顶部栏的位移，如果不想这样必须手动调用vc的`automaticallyAdjustsScrollViewInsets = false` 
2、如果你既有`UINavigationController`又有`UITabBarController`，你打算怎么弄？如果是`UINavigationController－》UITabBarController－》子vc`，那么你在每个子VC中设置不了顶部栏的titile，如果你是`UINavigationController－》UITabBarController－》UINavigationController－》子vc `恭喜你可以设置title了，但是底部栏跳转后不隐藏，即使你手动写代码可以隐藏以后感觉也很low

所有隐藏掉顶部栏吧 

