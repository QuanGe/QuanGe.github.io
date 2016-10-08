---
layout: post
title: sonar代码质量分析相关
---

###docker相关

[docker官网](https://www.docker.com/)

[docker Mac版本下载地址](https://download.docker.com/mac/stable/Docker.dmg)

[docker 镜像库dockerhub](https://hub.docker.com/_/sonarqube/)

### 部署sonar

在dockerhub中搜索sonar镜像 找到带`official`标签的 

####下载镜像

{% highlight objc %}
docker pull sonarqube //默认最新版
docker pull sonarqube:alphine //:后面跟的是标签或版本号
{% endhighlight %}

#### 运行镜像

{% highlight objc %}
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
sudo docker exec -ti sonarqube sh//可以进入刚才启动的docker
{% endhighlight %}

#### 可以通过http://localhost:9000/ 网址访问sonar服务器 帐号密码 都为admin

### sonarQube scanner 这是执行执行分析的工具 

[下载地址](http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner)

具体配置 查看上面连接即可 


{% highlight objc %}
 //先cd到某项目下面 然后
/private/etc/sonar-scanner-2.7/bin/sonar-scanner  -Dsonar.login=admin -Dsonar.password=admin
{% endhighlight %}

