---
layout: post
title: nginx相关
---

### 应用背景
现在有一组服务器 a、b、c、d 要求访问www.quange.com的时候能实现负载均衡分发到a、b、c、d，并且假如有一台服务器挂掉后，不影响网站的访问。
这时候就需要nginx。

### MAC上nginx的安装

安装nginx直接可以`brew install nginx`
安装完以后可以看到 输出
{% highlight objc %}
Docroot is: /usr/local/var/www

The default port has been set in /usr/local/etc/nginx/nginx.conf to 8080 so that
nginx can run without sudo.

nginx will load all files in /usr/local/etc/nginx/servers/.

To have launchd start nginx now and restart at login:
  brew services start nginx
Or, if you don't want/need a background service you can just run:
  nginx
{% endhighlight %}


### nginx配置

由上面的输出信息可以找到配置文件/usr/local/etc/nginx/nginx.conf
在http节点的下面添加upstream ，名称为bbbc，里面是几组服务器的ip和端口。那么location的proxy_pass就必须为http://bbbc。
而server的listen 端口为8080 server_name就是在浏览器输入的地址。比如下面的配置，在浏览器中应该输入http://www.quange.com:8080
#####前提是要在/etc/hosts中配置host。
{% highlight objc %} 
upstream bbbc {   
        server 127.0.0.1:3000; 
        server 127.0.0.1:3001; 
    }  
    server {
        listen       8080;
        server_name  www.quange.com;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
            proxy_pass http://bbbc; 
        }

{% endhighlight %}


### nginx操作

启动用

{% highlight objc %} 
nginx
{% endhighlight %}

停止
{% highlight objc %} 
nginx -s stop
{% endhighlight %}

不停止重新加载配置文件
{% highlight objc %} 
nginx -s reload
{% endhighlight %}


