---
layout: post
title: UITableView自动布局之动态图片及文字
---

在做swift测试app的时候做了个看糗百的功能如下图
![](https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/images/qiubaiList.jpg)
这个界面中的内容和图片都是动态的，假如内容为`contentLabel`,图片为`contentImageView`,一开始我是设置`contentLabel`左上下右，`contentImageView`则设置左右下和高，并把高连到类做了一个变量contentImageViewHeight，