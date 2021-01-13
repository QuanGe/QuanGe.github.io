---
layout: post
title: iOS dumpdecrypted 砸壳
---

# 越狱

https://cydia-app.com/downloader/



https://unc0ver.dev/





# 砸壳





https://github.com/stefanesser/dumpdecrypted



cd code/GitHub/dumpdecrypted/



make



scp -P 2222 /Users/zhangruquan/code/GitHub/dumpdecrypted/dumpdecrypted.dylib root@127.0.0.1:/User/Downloads





运行终端ssh到iPhone或者iPad等设备

iproxy 2222 22



waiting for connection



以上窗口不要关闭,另开一个新的终端窗口,运行

ssh -p 2222 root@127.0.0.1



密码

alpine





终端运行(//列出当前运行的进程)

ps -e|grep Aweme





cd /



su mobile



cd /User/Downloads/



DYLD_INSERT_LIBRARIES=dumpdecrypted.dylib /var/containers/Bundle/Application/9BD9166E-95CB-40F4-AE11-54567A29C98A/Aweme.app/Aweme



scp -P 2222 root@127.0.0.1:/User/Downloads/Aweme.decrypted /Users/zhangruquan/



scp -r -P 2222 root@127.0.0.1:/var/containers/Bundle/Application/9BD9166E-95CB-40F4-AE11-54567A29C98A/Aweme.app /Users/zhangruquan



## Clutch砸壳

https://github.com/KJCracks/Clutch/releases

下载发布的程序放到越狱设备的usr/bin 中并通过ifile增加可运行权限

Clutch -i

Clutch -d 1



scp -r -P 2222 root@127.0.0.1:/private/var/mobile/Documents/Dumped/com.apple.TestFlight-iOS9.0-(Clutch-2.0.4 DEBUG).ipa /Users/zhangruquan



scp -r -P 2222 root@127.0.0.1:/private/var/mobile/Documents/Dumped/com.dfzx.study.yunbaby-iOS9.0-(Clutch-2.0.4 DEBUG).ipa  /Users/zhangruquan



scp -r -P 2222 root@127.0.0.1:/private/var/mobile/Documents/Dumped/C.ipa  /Users/zhangruquan



##  Frida-ios-dump安装



1、打开cydia添加源：http://build.frida.re并在搜索中下载安装frida。

2、安装完成后在Mac端执行frida-ps -U查看是否可以工作。



https://github.com/AloneMonkey/frida-ios-dump/tree/3.x

https://blog.csdn.net/yihen18/article/details/101035266



1、安装python 3.7

2、终端进入 cd /Applications/Python\ 3.7 

3、sudo ./Install_Certificates.command 

4、下载代码 https://github.com/AloneMonkey/frida-ios-dump

5、cd到代码目录下sudo pip3 install -r requirements.txt --upgrade

6、iproxy 2222 22









https://github.com/AloneMonkey/frida-ios-dump

https://stackoverflow.com/questions/49183801/ssl-certificate-verify-failed-with-urllib



sudo ./Install_Certificates.command 





cd 到 frida-ios-dump 目录下./dump.py 应用名称/bundle id 即可砸壳



 ./dump.py -l 可以查询可以砸壳的 app



myfile="Aweme" && export myfile && ./class-dump -H -o "$myfile"header "$myfile" && ./restore-symbol "$myfile" -o "$myfile"withsymbo && ./yololib "$myfile"withsymbo QGiioo.dylib





cd  /var/containers/Bundle/Application/

ls -l  根据日期选择要拷贝的APP



scp -r -P 2222 root@127.0.0.1:/var/containers/Bundle/Application/63021253-0E17-4242-BC7A-4E8D96954AE8/Aweme.app /Users/zhangruquan/code/App_copy

### 重签名后多设备支持
修改Info.plist

```
<key>UISupportedDevices</key>
	<array>
		<string>iPad5,1</string>
		<string>iPad5,2</string>
		<string>iPad5,3</string>
		<string>iPad5,4</string>
		<string>iPad6,11</string>
		<string>iPad6,12</string>
		<string>iPad6,7</string>
		<string>iPad6,8</string>
		<string>iPad7,11</string>
		<string>iPad7,12</string>
		<string>iPad7,5</string>
		<string>iPad7,6</string>
		<string>iPhone9,2</string>
		<string>iPhone9,4</string>
	</array>
```
