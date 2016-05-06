---
layout: post
title: ubuntu 16.04 mysql 相关
---

### 如何彻底卸载某一版本的数据库

彻底删除ubuntu下的mysql：
1、删除mysql的数据文件
{% highlight objc %}
sudo rm /var/lib/mysql/ -R
{% endhighlight %}

2、删除mqsql的配置文件
{% highlight objc %}
sudo rm /etc/mysql/ -R
{% endhighlight %}

3自动卸载mysql的程序
{% highlight objc %}
sudo apt-get autoremove mysql* --purge
sudo apt-get remove apparmor
{% endhighlight %}

### ubuntu 16.04上如何安装mysql 5.5.49版本
[此网址打开以后选择linux－generic平台，最后一个文件](http://dev.mysql.com/downloads/mysql/5.5.html#downloads)

然后按以下步骤安装
[参考官方原文](http://dev.mysql.com/doc/refman/5.5/en/binary-installation.html)

1、添加mysql用户组
{% highlight objc %}
sudo groupadd mysql
{% endhighlight %}

2、添加 mysql（不是当前用户）添加到 mysql 用户组 
{% highlight objc %}
sudo adduser  mysql mysql
{% endhighlight %}

3、解压 mysql-5.5.49-linux2.6-x86_64.tar.gz（我将此文件放在了git［当前用户］的`文档`文件夹中） 到 /usr/local 
进入 /usr/local 
{% highlight objc %}
cd /usr/local
sudo tar zvxf /home/git/文档/mysql-5.5.49-linux2.6-x86_64.tar.gz
sudo mv mysql-5.5.49-linux2.6-x86_64 mysql 
{% endhighlight %}

4、设置 mysql 目录的拥有者和所属的用户组 
{% highlight objc %}
cd mysql
sudo chown -R mysql .
sudo chgrp -R mysql .
{% endhighlight %}

5、安装所需要lib包
{% highlight objc %}
sudo apt-get install libaio1 
{% endhighlight %}

6、执行mysql 安装脚本
{% highlight objc %}
sudo scripts/mysql_install_db --user=mysql  
{% endhighlight %}

7、再次设置 mysql 目录的拥有者 
{% highlight objc %}
sudo chown -R root .
{% endhighlight %}

8、设置 data 目录的拥有者 
{% highlight objc %}
sudo chown -R mysql data
{% endhighlight %}

9、复制 mysql 配置文件 
{% highlight objc %}
sudo cp support-files/my-medium.cnf /etc/my.cnf  
{% endhighlight %}

10、启动 mysql 
{% highlight objc %}
sudo bin/mysqld_safe --user=mysql & 
sudo cp support-files/mysql.server /etc/init.d/mysql.server
{% endhighlight %}

11、初始化 root 用户密码
{% highlight objc %}
sudo bin/mysqladmin -u root password '111111'
{% endhighlight %}

12、启动 
{% highlight objc %}
sudo /etc/init.d/mysql.server start
{% endhighlight %}

13、停止
{% highlight objc %}
sudo /etc/init.d/mysql.server stop
{% endhighlight %}

14、查看状态
{% highlight objc %}
sudo /etc/init.d/mysql.server status 
{% endhighlight %}

15、开机启动
{% highlight objc %}
sudo update-rc.d -f mysql.server defaults  
{% endhighlight %}

16、停止开机启动
{% highlight objc %}
sudo update-rc.d -f mysql.server remove 
{% endhighlight %}

17、把 /usr/local/mysql/bin/mysql 命令加到用户命令中，这样就不用每次都加 mysql命令的路径 
{% highlight objc %}
sudo ln -s /usr/local/mysql/bin/mysql /usr/local/bin/mysql 
现在就直接可以使用 mysql 命令了
 mysql -u root -p  
{% endhighlight %}


