---
layout: post
title: android第三方库PullToRefresh使用自定义属性
---
比如右上角和右下角的箭头怎么才能不显示，这时候就需要ptrShowIndicator属性，在定义布局xml中可以设置，头部加入：`xmlns:ptr="http://schemas.android.com/apk/res-auto"`

{% highlight objc %}
	<com.handmark.pulltorefresh.library.PullToRefreshListView
        android:id="@+id/qiubai_list"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:cacheColorHint="@color/navg_back_btn_bar"
        android:divider="@color/cell_separate_color"
        android:dividerHeight="5dip"
        android:fadingEdge="none"
        android:fadingEdgeLength="0dp"
        android:headerDividersEnabled="false"
        android:listSelector="@drawable/onclick_select_curri_group"
        android:overScrollMode="never"
        ptr:ptrShowIndicator="false"
        android:scrollbars="none" >
    </com.handmark.pulltorefresh.library.PullToRefreshListView>
{% endhighlight %}

