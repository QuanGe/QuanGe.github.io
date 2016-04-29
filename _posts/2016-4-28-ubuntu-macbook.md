---
layout: post
title: macbook+ubuntu 16.04
---

### u盘启动制作

把 ISO 格式的镜像文件转换成 dmg 格式。

{% highlight objc %}
hdiutil convert /path/to/ubuntu.iso -format UDRW -o /path/to/ubuntu.dmg
{% endhighlight %}


插入空白 U盘，运行下列命令查看你其序号

{% highlight objc %}
diskutil list
{% endhighlight %}


运行下面的命令，把N改成你U盘的序号，通常是2或者1。
{% highlight objc %}
diskutil unmountDisk /dev/diskN
{% endhighlight %}


运行下面的命令，把N改成你 U 盘的序号。
{% highlight objc %}
sudo dd if=/path/to/ubuntu.dmg of=/dev/rdiskN bs=1m
{% endhighlight %}


退出 U 盘，把N改成你 U 盘的序号
{% highlight objc %}
diskutil eject /dev/diskN
{% endhighlight %}


### 安装
准备好安装用的 U 盘后，还需要在硬盘上划出一块分区来给 ubuntu 使用，你可以使用系统自带的磁盘工具，或者是 BootCamp 进行分割。插入 U 盘重新启动 Mac，开机时按住 Option 键不放，直到出现磁盘选择为止。选择EFI boot 这一启动项，进入后选择 try ubuntu，进入 ubuntu 试用模式。进入桌面以后 点安装 ，选则刚划出的分区 格式选第一个，挂载点选/，启动器选择安装在这个盘，安装完成后，注意不要按重启这个按钮，选择继续试用 ubuntu，我们要解决启动引导的问题，否则重启是无法进入 ubuntu 的。接下来执行下面的命令以修复引导。
{% highlight objc %}
sudo apt-get install efibootmgr
sudo efibootmgr
sudo efibootmgr -o 0,80
{% endhighlight %}


之后就可以重新启动了。重启后可以进入 ubuntu。

### WIFI问题
{% highlight objc %}
sudo apt-get install bcmwl-kernel-source     #Broadcom 802.11 Linux STA 无线驱动源
{% endhighlight %}


### RVM安装
[参考这里的步骤1/2/3](http://quange.github.io/rails-setup/)

### ruby各版本切换
需要多装几次比如1.9.3： rvm install 1.9.3 ，至少三次吧 ，如果有错误按错误提示后面加参数

### rubymine 
在这之前先安装jdk1.8.0_77
配置环境变量
gedit .profile
{% highlight objc %}
export JAVA_HOME="/home/git/文档/jdk1.8.0_77" 
export PATH=".:$JAVA_HOME/bin:$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
{% endhighlight %}
gedit .bashrc
{% highlight objc %}
export JAVA_HOME="/home/git/文档/jdk1.8.0_77"
export PATH=".:$JAVA_HOME/bin:$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
{% endhighlight %}

下载版本rubymine7.0 
破解序列号：

name: rubymine

LICENSE：

70414-12042010
00002VG0BeoZbwmNAMNCx5E882rBEM
Ysn1P!e"s830EDlHcWg8gmqYVkvZMo
Injf4yqlO1yy"82NiwNzyYInoT7AiX

### 如果重新打开终端输入ruby -v提示程序“ruby”尚未安装。 您可以使用以下命令安装：

{% highlight objc %}
/bin/bash --login
{% endhighlight %}

