---
layout: post
title: Xcode12 相关
---

###  Xcode12 问题

`objc_msgSend`运行时方法报错，提示`No matching function for call to 'objc_msgSend'`,google 了下,有人反馈是Xcode12的bug。`Enable Strict Checking of objc_msgSend Calls` 配置设为`NO` 无效。


### xcversion 安装多版本Xcode

[xcversion](https://www.donnywals.com/installing-multiple-xcode-versions-with-xcversion/)

```
gem install xcode-install
xcversion list
xcversion install 11.3
xcversion select --symlink 11.3
xcversion uninstall 10.3

```


### 安装Xode10 或 11以后 报错 library not found for -libstdc++.6.0.9

将仓库里的文件放在下面目录即可

```
1.真机环境：/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/lib/
2.模拟器环境：/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/usr/lib/

```
