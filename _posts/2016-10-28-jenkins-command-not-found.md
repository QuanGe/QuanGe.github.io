---
layout: post
title: jenkins任务执行的时候会报 XXX command not found
---

###问题排查 
#### /usr/bin 目录下是否有你使用的程序

如果没有的话 
{% highlight objc %}
sudo ln -s /home/git/.rbenv/versions/2.1.8/bin/rspec /usr/bin/rspec
{% endhighlight %}
创建软连接

#### 由于jenkins默认使用的是jenkins用户执行任务，所有可能你的程序对jenkins用户没有权限

修改jenkins执行用户

{% highlight objc %}
vi /etc/sysconfig/jenkins
{% endhighlight %}

修改JENKINS_USER值：

{% highlight objc %}
## Type:        string
## Default:     "jenkins"
## ServiceRestart: jenkins
#
# Unix user account that runs the Jenkins daemon
# Be careful when you change this, as you need to update
# permissions of $JENKINS_HOME and /var/log/jenkins.
#
JENKINS_USER="git"
{% endhighlight %}

修改目录的相应权限：
{% highlight objc %}
sudo chown -R git /var/log/jenkins 
sudo chgrp -R git /var/log/jenkins

sudo chown -R git /var/lib/jenkins  
sudo chgrp -R git /var/lib/jenkins

sudo chown -R git /var/cache/jenkins 
sudo chgrp -R git /var/cache/jenkins
{% endhighlight %}

重启jenkins服务
{% highlight objc %}
sudo /etc/init.d/jenkins restart
sudo service jenkins restart
{% endhighlight %}

