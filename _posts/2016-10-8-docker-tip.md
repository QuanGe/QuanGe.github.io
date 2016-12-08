---
layout: post
title: 常用docker命令，及一些坑
---

### 常用命令
 

#### 查看容器的root用户密码

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
alias dl=’docker ps -l -q’ 将长命令简化为dl，以后直接敲dl就可以了
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


#### RUN命令 vs CMD命令

Docker的新手用户比较容易混淆RUN和CMD这两个命令。 
RUN命令在构建（Build）Docker时执行，这时CMD命令不执行。CMD命令在RUN命令执行时才执行。我们来理清关系，假设Dockerfile内容如下：
{% highlight objc %}
FROM thelanddownunder
MAINTAINER crocdundee
# docker build将会执行下面的命令：
RUN apt-get update
RUN apt-get install softwares
# dokcer run默认执行下面的命令：
CMD [“softwares”]
{% endhighlight %}
Build时执行RUN，RUN时执行CMD，也就是说，CMD才是镜像最终执行的命令。

#### CMD命令 vs ENTRYPOINT命令
又是两条容易混淆的命令！具体细节我们就不说了，举个例子，假设一个容器的Dockerfile指定CMD命令，如下：
{% highlight objc %}
FROM ubuntu
CMD [“echo”]
{% endhighlight %}
另一个容器的Dockerfile指定ENTRYPOINT命令，如下：
{% highlight objc %}
FROM ubuntu
ENTRYPOINT [“echo”]
{% endhighlight %}
运行第一个容器：
{% highlight objc %}
docker run image1 echo hello
{% endhighlight %}
得到的结果：
{% highlight objc %}
hello
{% endhighlight %}

运行第二个容器：
{% highlight objc %}
docker run image2 echo hello
{% endhighlight %}

得到的结果：
{% highlight objc %}
echo hello
{% endhighlight %}

看到不同了吧？实际上，CMD命令是可覆盖的，docker run后面输入的命令与CMD指定的命令匹配时，会把CMD指定的命令替换成docker run中带的命令。而ENTRYPOINT指定的命令只是一个“入口”，docker run后面的内容会全部传给这个“入口”，而不是进行命令的替换，所以得到的结果就是“echo hello”。


#### Docker容器有自己的IP地址吗？
刚接触Docker的人或许会有这样的疑问：Docker容器有自己的IP地址吗？Docker容器是一个进程？还是一个虚拟机？嗯…也许两者兼 具？哈哈，其实，Docker容器确实有自己的IP，就像一个具有IP的进程。只要分别在主机和Docker容器中执行查看ip的命令就知道了。

查看主机的ip：

{% highlight objc %}
$ ip -4 -o addr show eth0
{% endhighlight %}

得到结果：
{% highlight objc %}
2: eth0 inet 162.243.139.222/24
{% endhighlight %}

查看Docker容器的ip：
{% highlight objc %}
$ docker run ubuntu ip -r -o addr show eth0
{% endhighlight %}

得到结果：
{% highlight objc %}
149: eth0   inet 172.17.0.43/16
{% endhighlight %}

两者并不相同，说明Docker容器有自己的ip。


#### 把镜像的依赖关系绘制成图
docker images命令有一个很拉风的选项：-viz，可以把镜像的依赖关系绘制成图并通过管道符号保存到图片文件：
{% highlight objc %}
# 生成一个依赖关系的图表
$ docker images -viz | dot -T png -o docker.png
{% endhighlight %}

这样，主机的当前路径下就生成了一张png图，然后，用python开启一个微型的HTTP服务器：
{% highlight objc %}
python -m SimpleHTTPServer
{% endhighlight %}

然后在别的机器上用浏览器打开：
{% highlight objc %}
http://machinename:8000/docker.png
{% endhighlight %}

OK，依赖关系一目了然！

#### Docker把东西都存到哪里去了？

Docker实际上把所有东西都放到/var/lib/docker路径下了。切换成super用户，到/var/lib/docker下看看，你能学到很多有趣的东西。执行下面的命令：
{% highlight objc %}
$ sudo su
# cd /var/lib/docker
# ls -F
containers/ graph/ repositories volumes/
{% endhighlight %}

可以看到不少目录，containers目录当然就是存放容器（container）了，graph目录存放镜像，文件层（file system layer）存放在graph/imageid/layer路径下，这样你就可以看看文件层里到底有哪些东西，利用这种层级结构可以清楚的看到文件层是如 何一层一层叠加起来的。

#### Docker源代码：Go, Go, Go, Golang!

Docker的源代码全部是用Go语言写的。Go是一门非常酷的语言。其实，不只是Docker，很多优秀的软件都是用Go写的。对我来说，Docker源文件中，有4个是我非常喜欢阅读的：

######### commands.go
docker的命令行接口，是对REST API的一个轻量级封装。Docker团队不希望在命令中出现逻辑，因此commands.go只是向REST API发送指令，确保其较小的颗粒性。

######### api.go
REST API的路由（接受commands.go中的请求，转发到server.go）

######### server.go
大部分REST API的实现

######### buildfile.go
Dockerfile的解析器

有的伙计惊叹”Wow!Docker是怎么实现的？！我无法理解！”没关系，Docker是开源软件，去看它的源代码就可以了。如果你不太清楚Dockerfile中的命令是怎么回事，直接去看buildfile.go就明白了。




