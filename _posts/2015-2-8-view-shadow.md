---
layout: post
title: uiview 实现阴影效果
---

阴影可能对于ui来讲是常用的一种效果，可以让UI切图实现，当然也可以用几句代码实现，下面我们就用几行代码来实现UI控件的阴影效果

```
[[self.m_pEditView layer] setShadowOffset:CGSizeMake(0, 3)];//位移
[[self.m_pEditView layer] setShadowRadius:3];//阴影半径
[[self.m_pEditView layer] setShadowOpacity:1];//不透明度
[[self.m_pEditView layer] setShadowColor:[UIColor blackColor].CGColor];//颜色
```
