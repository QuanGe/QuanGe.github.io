---
layout: post
title: 由android保存一张图片引发的联想
---

最近在做app的时候需要保存一张图片到sd卡，代码保存以后能在手机相册里看到，但是我保存以后在相册里不显示，但是在文件管家里可以看到这张图片，我试了试糗百的app，保存了一张图片，能在相册里看到，一开始我以为是图片命名问题，按照糗百的命名方式命名还是不行。

后来在保存图片后加了以下代码就可以了
{% highlight objc %}
sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE,Uri
                            .parse("file://" + _file)));
{% endhighlight %}
那么这个sendBroadcast到底是做什么的呢？广播，相当于iOS中NSNotificationCenter的postNotificationName。不过比iOS更加强大，iOS中只是app内适用，在android中发送一条广播其他app都可以收到，然后进行相应的处理。

### 发送广播比较
android
{% highlight objc %}
Intent it = new Intent("someNotification");
it.putExtra("some argv", "abcd");
sendBroadcast(it);
{% endhighlight %}

iOS
{% highlight objc %}
[[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingTaskDidCompleteNotification object:task userInfo:userInfo];
{% endhighlight %}


### 接收广播比较
android
{% highlight objc %}
private BroadcastReceiver br = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {
			String someargv = intent.getStringExtra("some argv");
		}
	};
IntentFilter ifilter = new IntentFilter("someNotification");
registerReceiver(br, ifilter);
{% endhighlight %}

iOS
{% highlight objc %}
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:AFNetworkingTaskDidCompleteNotification object:nil];
- (void)networkRequestDidFinish:(NSNotification *)notification {
	NSDictionary * userDic = [notification userInfo];
    //some code
}
{% endhighlight %}

### 取消接收广播比较
android
{% highlight objc %}
registerReceiver(br, ifilter);
{% endhighlight %}

iOS
{% highlight objc %}
[[NSNotificationCenter defaultCenter] removeObserver:self];
{% endhighlight %}

### 总结
个人还是喜欢iOS的单例模式，简洁
附app效果图
![](https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/images/girls05.png)
下载二维码一张
![](https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/images/ysw_android.png)