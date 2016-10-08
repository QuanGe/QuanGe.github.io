---
layout: post
title: 常用docker命令，及一些坑
---

###常用命令
 

####查看容器的root用户密码

{% highlight objc %}
docker logs <容器名orID> 2>&1 | grep '^User: ' | tail -n1
{% endhighlight %}

因为Docker容器启动时的root用户的密码是随机分配的。所以，通过这种方式就可以得到redmine容器的root用户的密码了。

#### 查看容器日志

{% highlight objc %}
docker logs -f <容器名orID>
{% endhighlight %}

#### 查看正在运行的容器

{% highlight objc %}
docker ps
docker ps -a为查看所有的容器，包括已经停止的。
{% endhighlight %}

#### 删除单个容器

{% highlight objc %}
docker rm <容器名orID>
{% endhighlight %}


#### 删除所有容器

{% highlight objc %}
docker rm $(docker ps -a -q)
{% endhighlight %}

#### 停止、启动、杀死一个容器

{% highlight objc %}
docker stop <容器名orID>
docker start <容器名orID>
docker kill <容器名orID>
{% endhighlight %}

#### 查看所有镜像

{% highlight objc %}
docker images
{% endhighlight %}

#### 删除所有镜像

{% highlight objc %}
docker rmi $(docker images | grep none | awk '{print $3}' | sort -r)
{% endhighlight %}

#### 运行一个新容器，同时为它命名、端口映射、文件夹映射。以redmine镜像为例

{% highlight objc %}
docker run --name redmine -p 9003:80 -p 9023:22 -d -v /var/redmine/files:/redmine/files -v /var/redmine/mysql:/var/lib/mysql sameersbn/redmine
{% endhighlight %}

#### 进入container

{% highlight objc %}
sudo docker exec -ti redmine sh//可以进入刚才启动的docker
{% endhighlight %}

#### 一个容器连接到另一个容器

{% highlight objc %}
docker run -i -t --name sonar -d -link mmysql:db   tpires/sonar-server
sonar
{% endhighlight %}

容器连接到mmysql容器，并将mmysql容器重命名为db。这样，sonar容器就可以使用db的相关的环境变量了。

#### 拉取镜像

{% highlight objc %}
docker pull <镜像名:tag>
{% endhighlight %}

例如
{% highlight objc %}
docker pull sameersbn/redmine:latest
{% endhighlight %}

#### 当需要把一台机器上的镜像迁移到另一台机器的时候，需要保存镜像与加载镜像。
机器a
{% highlight objc %}
docker save busybox-1 > /home/save.tar
{% endhighlight %}

使用scp将save.tar拷到机器b上，然后：
{% highlight objc %}
docker load < /home/save.tar
{% endhighlight %}

#### 构建自己的镜像

{% highlight objc %}
docker build -t <镜像名> <Dockerfile路径>
{% endhighlight %}
如Dockerfile在当前路径：
{% highlight objc %}
docker build -t xx/gitlab .
{% endhighlight %}

#### 重新查看container的stdout

{% highlight objc %}
# 启动top命令，后台运行
$ ID=$(sudo docker run -d ubuntu /usr/bin/top -b)
# 获取正在running的container的输出
$ sudo docker attach $ID
top - 02:05:52 up  3:05,  0 users,  load average: 0.01, 0.02, 0.05
Tasks:   1 total,   1 running,   0 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.1%us,  0.2%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:    373572k total,   355560k used,    18012k free,    27872k buffers
Swap:   786428k total,        0k used,   786428k free,   221740k cached
^C$
$ sudo docker stop $ID
{% endhighlight %}


#### 后台运行(-d)、并暴露端口(-p)

{% highlight objc %}
docker run -d -p 127.0.0.1:33301:22 centos6-ssh
{% endhighlight %}

#### 从Container中拷贝文件出来

{% highlight objc %}
sudo docker cp 7bb0e258aefe:/etc/debian_version .
{% endhighlight %}

拷贝7bb0e258aefe中的/etc/debian_version到当前目录下。

注意：只要7bb0e258aefe没有被删除，文件命名空间就还在，可以放心的把exit状态的container的文件拷贝出来

### 坑

#### ubuntu14下的docker是没有service服务。去除每次sudo运行docker命令，需要添加组：
{% highlight objc %}
# Add the docker group if it doesn't already exist.
$ sudo groupadd docker
#改完后需要重新登陆用户
$ sudo gpasswd -a ${USER} docker
{% endhighlight %}

#### ubuntu14的febootstrap没有-i命令

#### Dockerfile中的EXPOSE、docker run --expose、docker run -p之间的区别
Dockerfile的EXPOSE相当于docker run --expose，提供container之间的端口访问。docker run -p允许container外部主机访问container的端口








