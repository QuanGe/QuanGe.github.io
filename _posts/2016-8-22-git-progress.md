---
layout: post
title: 控制台之行git clone会有进度条显示百分比，如何实现，如何拿到其中的值
---

{% highlight objc %}
for((i=1;i<=10;i++));do { sleep 1 ;echo -e "\r" $(expr $i \* 4) "\c";} done;
{% endhighlight %}

如何拿到输出的所有值

{% highlight objc %}
require 'open3'

def copy_lines(str_in, str_out)
  str_in.each("\r") {|line| str_out.puts line}
end

Open3.popen3( 'cd  && cd /Users/git/Desktop/tryImport && git clone --progress  git@code.csdn.net:CSDN_Dev/labhub.git' ) do |stdin, stdout, stderr, t|
  stdin.close
  err_thr = Thread.new { copy_lines(stderr, $stderr) }
  puts "Reading STDOUT"
  copy_lines(stdout, $stdout)
  err_thr.join
end
{% endhighlight %}

