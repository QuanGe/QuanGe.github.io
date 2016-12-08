---
layout: post
title: linux 个人常用命令和快捷键
---

### 查询某个项目所有内容中包含某个关键字的文件
{% highlight objc %}
find . -name "*rb"  |xargs grep  "SyncClient.push"
{% endhighlight %}

### 查询某文件中包含某关键字的 结果，包括行号

{% highlight objc %}
cat -n  ./lib/gitlab_git/repository.rb |grep ".push"
{% endhighlight %}

### 查找某进程 并且杀掉

{% highlight objc %}
ps -ef  grep Chrome //查找出Chrome的线程
ps aux  grep Chrome //查找出Chrome的线程
pgrep Chrome //查找出Chrome的线程
kill -s 9 1827 //其中 -s 9制定了传递给进程的信号是9 即强迫、尽快终止进程

kill -s 9 $(pgrep Chrome)
{% endhighlight %}

### 终端中鼠标移到命令行开头或结尾

{% highlight objc %}
control + a
control + e
{% endhighlight %}

### 终端中删除此行

{% highlight objc %}
control + u
{% endhighlight %}

### 创建文件夹 删除文件夹 拷贝 移动

{% highlight objc %}
mkdir aaa //创建文件夹
rm -r aaa //删除文件夹
cp -r aaa bbb //拷贝aaa 为bbb
mv aaa bbb // 将aaa 移动到bbb文件夹内
{% endhighlight %}


### vim 常用命令

{% highlight objc %}
i进入编辑模式
/aaa 查找aaa n下一个 N上一个
w下一个单词b上一单词
dd 删除当前行
yy复制当前行
在VIM中用iw或者aw表示一个单词，两者稍有区别。
选择光标所在的单词：viw （v进入visual模式，然后iw）
复制光标所在的单词：yiw
u 撤销
:set number 显示行号

yy : copy 光标所在的行
nyy: copy n line
yw: copy 光标所在的单词
nyw: copy 光标所在位置到其后的n 个单词(未必是同一行)
y$:  copy 光标所在位置到行尾($是行尾的标示)
ny$:  copy 光标所在位置之后的n行(包括当前行，当前行=y$)
p:  paste 在光标所在位置之右

dd : delete current line
ndd:  delete n line
dw: delete current word
ndw: delete n word
d$ : delete to the end of line.
nd$ : delete n line. (current line = d$)
x: delete one character(无论是ascii 还是unicode)
nx: delete n characters.
{% endhighlight %}






