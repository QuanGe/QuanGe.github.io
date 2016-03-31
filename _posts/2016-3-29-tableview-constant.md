---
layout: post
title: UITableView自动布局之动态图片及文字
---

在做swift测试app的时候做了个看糗百的功能如下图
![](https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/images/qiubaiList.jpg)
这个界面中的内容和图片都是动态的，假如内容为`contentLabel`,图片为`contentImageView`,一开始我是设置`contentLabel`左上下右，`contentImageView`则设置左右下和高，并把高连到类做了一个变量contentImageViewHeight，

{% highlight objc %}
func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

return somecell
}
{% highlight objc %}

并在上面函数中动态设置`contentImageViewHeight.constant`的值,结果一运行总报NSLayoutConstraint冲突

后来查了下，做了下修改:将`contentImageView`的高删掉，运行，居然没问题了，也就是说`heightForRowAtIndexPath`动态设置高度以后，tableview会自动适配`contentLabel`和`contentImageView`，太强大了，涨姿势了