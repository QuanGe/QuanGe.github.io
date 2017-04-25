---
layout: post
title: iOS装13-自动打包
---

cd到任何一个文件夹 sudo vim aaa,里面内容如下：

{% highlight objc %}
#! /bin/bash

echo "准备开始打ipa包...................."

#工程环境路径
workspace_path=/Users/git/shijue_ios/iOSV4
#项目名称
project_name=500px
#app名称
app_name=500pxme
#build的路径
build_path=$workspace_path

echo "第一步，进入项目工程文件: $build_path"

cd $build_path

echo "第二步，执行build clean命令"

xcodebuild clean

echo "第三步，执行编译生成.app命令"

xcodebuild -workspace $project_name.xcworkspace -scheme $project_name -sdk iphoneos -configuration Release -derivedDataPath build

echo "在项目工程文件内生成一个build子目录，里面有${app_name}.App程序"

echo "第四步, 导出ipa包"

#.app生成后的路径
app_name_path=$build_path/build/Build/Products/Release-iphoneos/${app_name}.app
#.ipa生成后的路径
ipa_name_path=$build_path/build/Build/Products/Release-iphoneos/${app_name}.ipa


echo "生成的app路径是：$app_name_path"

#生成ipa包
xcrun -sdk iphoneos PackageApplication -v $app_name_path -o $ipa_name_path

echo "制作ipa包完成......................."
{% endhighlight %}


修改aaa的权限`chmod +x  aaa`

如果执行`./aaa`报

```
xcrun: error: unable to find utility "PackageApplication", not a developer tool or in PATH
```

则[下载PackageApplication](https://pan.baidu.com/s/1pL59OvT)放到以下目录

```
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/
```

然后执行 

```
sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer/
chmod +x /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/PackageApplication

```









