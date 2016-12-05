---
layout: post
title: redis 操作简单命令
---

{% highlight objc %}
redis-cli -h 192.168.5.179 -p 6379 //连接数据库
keys * 查看所有key
type onekey 查看某个key数据类型
hkeys onekey 如果key为hash类型，可以列出所有filed
hvals onekey 如果key为hash类型，可以列出所有值
flushall 清空所有数据
hdel
del
set
get
hset
hget
{% endhighlight %}
