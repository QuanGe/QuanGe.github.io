---
layout: post
title: 项目环境搭建之CocoaPods的安装和使用
---

##CocoaPods是什么？

CocoaPods是iOS最常用最有名的类库管理工具了，可以帮你做三件事：

1、在正常设置配置文件后执行一行命令即可自动下载配置各种开源第三库如`JSONKit`，`AFNetWorking`、`ReactiveCocoa`、`MBProgressHUD`等

2、当第三库有更新的时候可以执行一行命令即可更新

3、公司又开了一个新项目，将配置文件拷到新项目，执行一行命令即可配置完第三库，方便快捷至极。

##如何下载和安装CocoaPods？

在安装CocoaPods之前，首先要在本地安装好Ruby环境[传送门](https://www.ruby-lang.org/zh_cn/downloads/)
针对中国国情，我们使用淘宝的Ruby镜像来访问cocoapods。按照下面的顺序在mac终端中敲入依次敲入

```
$ gem sources --remove https://rubygems.org/
//等有反应之后再敲入以下命令
$ gem sources -a http://ruby.taobao.org/
```

为了验证你的Ruby镜像是并且仅是taobao，可以用以下命令查看

```
$ gem sources -l
```

当终端输出

```
*** CURRENT SOURCES ***
http://ruby.taobao.org/
```

再执行

```
sudo gem install cocoapods
```

输入机子的密码 静静等待安装完成即可

##如何使用CocoaPods？

使用目的主要有两个：创建新项目加入第三库、编译运行包含CocoaPods类库的第三库的demo
1、创建新项目加入第三库MBProgressHUD（各种进度条）、ReactiveCocoa（RAC函数响应式编程）、ReactiveViewModel（MVVM模式）、AFNetworking（网络）、UALogger（具体到文件名的输出日志）
首先终端进入项目目录（终端输入cd 然后将项目拖入终端窗口然后按回车）

利用vim创建Podfile文件（一定得是这个文件名，而且没有后缀，然后在里面添加你需要下载的类库），即终端输入

```
$ vim Podfile
```

然后在Podfile文件中输入以下文字

```
platform :ios, '7.0'
pod 'MBProgressHUD'
pod 'ReactiveCocoa'
pod 'ReactiveViewModel'
pod 'AFNetworking'
pod 'UALogger'
```

然后按下键盘ESC键并输入命令`:wq`保存并退出,然后在终端窗口输入

```
$ pod install 
```

就去喝杯水等待完成吧,完成后终端窗口输出

```
Generating Pods project
Integrating client project
```

ok，打开项目目录中后缀为.xcworkspace文件即可开启你的项目旅程
2、编译运行包含CocoaPods类库的第三库的demo

像上面1中一样进入项目目录然后在终端输入命令

```
$ pod update
```

然后喝口水等待完成即可
那么 update 和install有啥区别呢 
`$ pod install`只会按照Podfile的要求来请求类库，如果类库版本号有变化，那么将获取失败。但是 `$ pod update`会更新所有的类库，获取最新版本的类库。而且你会发现，如果用了 `$ pod update`，再用 `$ pod install` 就成功了。所以当编译他人的demo的时候推荐用 `$ pod update`。

好了，有了以上教程，第三库的环境搭建就完了