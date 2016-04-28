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

diskutil unmountDisk /dev/diskN

运行下面的命令，把N改成你 U 盘的序号。

sudo dd if=/path/to/ubuntu.dmg of=/dev/rdiskN bs=1m

退出 U 盘，把N改成你 U 盘的序号

diskutil eject /dev/diskN

准备好安装用的 U 盘后，还需要在硬盘上划出一块分区来给 ubuntu 使用，你可以使用系统自带的磁盘工具，或者是 BootCamp 进行分割。插入 U 盘重新启动 Mac，开机时按住 Option 键不放，直到出现磁盘选择为止。选择EFI boot 这一启动项，进入后选择 try ubuntu，进入 ubuntu 试用模式。此后便可如常安装。安装完成后，注意不要按重启这个按钮，选择继续试用 ubuntu，我们要解决启动引导的问题，否则重启是无法进入 ubuntu 的。接下来执行下面的命令以修复引导。

sudo apt-get install efibootmgr

sudo efibootmgr

sudo efibootmgr -o 0,80

之后就可以重新启动了。重启后可以进入 ubuntu。



