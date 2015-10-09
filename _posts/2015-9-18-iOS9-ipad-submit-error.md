---
layout: post
title: xcode7 iOS9 提交iPad程序审核中出现错误
---

##出现的错误
错误有两个：

1、![](https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/images/ios9ipadsubmit.png)

2、![](https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/images/ios9ipadsubmit2.jpg)

##解决方案

1、在info.plist 中添加 key：UIRequiresFullScreen  value：YES（Boolean）

2、在腾讯开放平台库中TencentOpenApi_IOS_Bundle找到info.plist 右键 选择show Raw keys/values 找到CFBundleIdentifier的key，删除掉

