---
layout: post
title: iOS cocoaPods清除缓存
---

It might help to clear the CocoaPods cache (rm -rf ~/Library/Caches/CocoaPods) and reset the CocoaPods integration again (rm -rf Pods, in your project) and run finally `pod install` again. It might be necessary to run it twice. (See https://github.com/realm/realm-cocoa/issues/2701)

