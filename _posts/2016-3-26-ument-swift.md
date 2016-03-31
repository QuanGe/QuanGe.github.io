---
layout: post
title: 友盟swift添加
---

在pod中添加`pod 'UMengAnalytics-NO-IDFA'`然后执行`pod install` ，项目也添加成功了。但是到底怎么用呢，因为友盟提供的是`.a`文件，pod无法生成`framwork`,
一开始 我是这么用的 `import MobClick`,提示`no such module MobClick`,后来搜了搜，说要添加个桥连接文件，具体操作，添加个oc的类就会提示你加桥连接文件，然后删掉oc类。
然后在类似`Girls-Bridging-Header.h`的文件里添加`#import "MobClick.h"` ,然后再运行，仍然提示`no such module MobClick`,尼玛急坏我了，这可咋整，后来想起来要删掉 `import MobClick`,然后再运行，ok木问题了。在这里记录下，省的以后swift小白遇到着急

