---
layout: post
title: rails 安装配置及学习资源
---

最近要整代码托管了，需要学习ruby和rails，ruby是们语言，rails相当于maven让开发更加便捷。rubymine是ruby的IDE，[下载传送](http://confluence.jetbrains.com/display/RUBYDEV/Previous+RubyMine+Releases)，7.04可以破解。[rails学习网站](http://guides.ruby-china.org/getting_started.html)这里面教你怎么搭建一个自己的博客网站。下面就是ruby环境的安装：


####步骤0 － 安装系统需要的包

{% highlight objc %}
# For Mac 
# 先安装 [Xcode](http://developer.apple.com/xcode/) 开发工具，它将帮你安装好 Unix 环境需要的开发包
# 然后安装 [Homebrew](http://brew.sh)
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
OS X 安装 Rails 必要的一些三方库

$ brew install libxml2 libxslt libiconv

$ brew install gnupg gnupg2
{% endhighlight %}

####步骤1 － 安装 RVM

RVM 是干什么的这里就不解释了，后面你将会慢慢搞明白。

{% highlight objc %}
$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
$ curl -sSL https://get.rvm.io | bash -s stable
# 如果上面的连接失败，可以尝试: 
$ curl -L https://raw.githubusercontent.com/wayneeseguin/rvm/master/binscripts/rvm-installer | bash -s stable
期间可能会问你 sudo 管理员密码，以及自动通过 Homebrew 安装依赖包，等待一段时间后就可以成功安装好 RVM。

然后，载入 RVM 环境（新开 Termal 就不用这么做了，会自动重新载入的）

$ source ~/.rvm/scripts/rvm
检查一下是否安装正确

$ rvm -v
rvm 1.22.17 (stable) by Wayne E. Seguin <wayneeseguin@gmail.com>, Michal Papis <mpapis@gmail.com> [https://rvm.io/]

{% endhighlight %}

####步骤2 － 用 RVM 安装 Ruby 环境

{% highlight objc %}
$ rvm requirements
$ rvm install 2.3.0
同样继续等待漫长的下载，编译过程，完成以后，Ruby, Ruby Gems 就安装好了。

{% endhighlight %}

####步骤3 － 设置 Ruby 版本

{% highlight objc %}
RVM 装好以后，需要执行下面的命令将指定版本的 Ruby 设置为系统默认版本

$ rvm use 2.3.0 --default
同样，也可以用其他版本号，前提是你有用 rvm install 安装过那个版本

这个时候你可以测试是否正确

$ ruby -v
ruby 2.3.0 ...

$ gem -v
2.1.6

$ gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
安装 Bundler

$ gem install bundler
步骤4 － 安装 Rails 环境

上面 3 个步骤过后，Ruby 环境就安装好了，接下来安装 Rails

$ gem install rails
然后测试安装是否正确

$ rails -v
Rails 4.2.5

{% endhighlight %}

####rubymine破解
 
name: rubymine

LICENSE：

70414-12042010 
00002VG0BeoZbwmNAMNCx5E882rBEM 
Ysn1P!e"s830EDlHcWg8gmqYVkvZMo 
Injf4yqlO1yy"82NiwNzyYInoT7AiX

