---
layout: post
title: iOS App内数据的统一管理之Rocket Data
---

# 概览

Rocket Data provides a simple, synchronous API to manage immutable models. Each user of the library owns a data provider which wraps the immutable model. You can set and edit data providers synchronously. Under the hood, any changes are asynchronously propagated to other data providers and the cache. This allows your application logic to be simple and your model management to never block the main thread or slow down your app.

Rocket Data 提供了简单的、同步更新的api去管理那些不可变的模型。库中的每个data provider 都持有不可变的模型。你可以同步编辑、设置data provider。在这个第三方库中，任何数据的更新都会异步通知data provider和缓存。这样使你的app逻辑变得简单，并且永远不会阻塞主线程或使app变的卡顿。

# 如何使用

To setup the library in your app, you need to do a few steps:

1、Implement your CacheDelegate

2、Create your DataModelManager

3、Make your models implement the Model or SimpleModel protocol

4、(Optional) Add extensions to classes for a simpler API

## 实现自己的 CacheDelegate
{% highlight swift %}
public protocol CacheDelegate {

func modelForKey<T: SimpleModel>(_ cacheKey: String?, context: Any?, completion: @escaping (T?, NSError?)->())

//通过key获取model
func setModel(_ model: SimpleModel, forKey cacheKey: String, context: Any?)
//通过key保存model

func collectionForKey<T: SimpleModel>(_ cacheKey: String?, context: Any?, completion: @escaping ([T]?, NSError?)->())

//通过key获取数组models

func setCollection(_ collection: [SimpleModel], forKey cacheKey: String, context: Any?)

//通过key保存数组models
func deleteModel(_ model: SimpleModel, forKey cacheKey: String?, context: Any?)
}

//通过key删除model
{% endhighlight %}

## 我们自己创建 DataModelManager

在DataModelManager的注释中发下以下注释
{% highlight swift %}
/**
Class which holds onto the cache delegate and consistency manager. You should only have one of these per application.
Ideally, you should add an extension which adds a singleton accessor like:

let sharedInstance = DataModelManager(cacheDelegate: MyCacheDelegate())

Whenever you initialize a data provider, you need to pass in this shared data model manager. You can add an extension to make this easy. For example:

extension DataProvider<T> {
    convenience init() {
        self.init(dataModelManager: DataModelManager.sharedInstance)
    }
}

All the methods in this class are thread safe.
*/
{% endhighlight %}


注释里写的很明白，第一步
{% highlight swift %}
let sharedInstance = DataModelManager(cacheDelegate: MyCacheDelegate())
{% endhighlight %}
第二步
{% highlight swift %}
extension DataProvider{
    convenience init() {
        self.init(dataModelManager: DataModelManager.sharedInstance)
    }
}
{% endhighlight %}
## 使用的时候模型需要遵守的协议

协议有两种SimpleModel和 Model

### SimpleModel
这种是最简单的，只要实现以下方法

{% highlight swift %}
var modelIdentifier: String? { get }
func isEqual(to model: SimpleModel) -> Bool
{% endhighlight %}


modelIdentifier  应该返回一个唯一的标示
func isEqual(to model: SimpleModel) -> Bool  ，你也可以不实现 ，如果你的模型实现了 Equatable。会自动使用==来实现




### model

{% highlight swift %}
var modelIdentifier: String? { get }
func isEqual(to model: SimpleModel) -> Bool
func map(_ transform: (Model) -> Model?) -> Self?
func forEach(_ visit: (Model) -> Void)
func merge(_ model: Model) -> Model
{% endhighlight %}



func map(_ transform: (Model) -> Model?) -> Self?  这里主要处理什么呢 ？看官方文档 

The ability to create new models by mapping on old models. The protocol allows the library to iterate over child nodes (and then recursively iterate over the whole tree) and then replace these models with updated models. This ability is not required by SimpleModel and therefore will not get consistency for child models.

Rocket Data supports deleting models. When a model is deleted, the map function in the Model protocol will return nil for a model. This means the model should remove this child model. If the child model is required, we recommend you cascade this delete and return nil for the current model. You do not need to worry about this for SimpleModels.

大概意思就是修改或者删除了model A，如果这个model持有其他的model B，在处理A的时候也要处理B。如果你的model 很简单 那么直接用 SimpleModel。而且我也打断点跟踪了下只用调用了DataModelManager.updateModel(model, updateCache: updateCache, context: context)的时候触发map函数




func forEach(_ visit: (Model) -> Void) 这里主要处理什么呢 ？看看注释里写的 

This method should iterate over all the child models in self.

在这个方法里应该便利所有的子model。意思是 如果你的model 没有子model，可以使用 SimpleModel



func merge(_ model: Model) -> Model   这里主要处理什么呢 ？看看注释里写的 

Optional method. Do not implement this method unless you want to support projections (not common).

可选的方法，除非你想支持这种merge特性，否则不要去实现这个方法


## Data Providers


Data providers are the main interface with the library and most of your code will interact with data providers. They are a wrapper around an immutable model or models. They listen to any changes on their models and notify their delegate whenever something changes. There are two types of data providers: DataProvider and CollectionDataProvider.

DataProviders are backed by a DataModelManager. The initializer requires you pass in a DataModelManager, but you can simplify this API with an extension. See Setup for more info.

DataProviders also offer the ability to pause updates. See Other Features.

数据持有者可以持有单个或者多个不可变的对象，如果只有一个用 DataProvider 如果有多个用CollectionDataProvider。

#### 存数据

{% highlight swift %}
ShopItemsCollectionDataProvider.setData(feedItems, cacheKey: "shop")
ShopItemsCollectionDataProvider.append(newItems)
{% endhighlight %}


#### 更新某数据

{% highlight swift %}
DataModelManager.sharedInstance.updateModel(self, updateCache: false)
{% endhighlight %}

#### 从缓存中取数据
{% highlight swift %}
ShopItemsCollectionDataProvider.fetchDataFromCache(withCacheKey: "shop")
{ [weak self] items, error in
    self?.adapter?.reloadData(completion: nil)
}
{% endhighlight %}

#### 从内存中取数据
{% highlight swift %}
ShopItemsCollectionDataProvider.data
{% endhighlight %}

#### 更新数据协议

{% highlight swift %}

public protocol DataProviderDelegate: class {
/**
This delegate method is called whenever we get an update from the consistency manager that our model has changed and we need to refresh.
For example, if someone else sets data with the same ID as this data, then this data will get updated if it has changed.
It will only be called when the method has actually changed.

- paramter dataProvider: The data provider which has changed. If you have multiple data providers, you can use === to determine which one has changed.
- paramter context: Whenever you make a change to a model, you can pass in a context. This context will be passed back to you here.
*/
func dataProviderHasUpdatedData<T>(_ dataProvider: DataProvider<T>, context: Any?)
}

public protocol CollectionDataProviderDelegate: class {
/**
This delegate method is called whenever we get an update from the consistency manager that our model has changed and we need to refresh.
For example, if someone else sets data with the same ID as this data, then this data will get updated if it has changed.
It will only be called when the data has actually changed.

- parameter dataProvider: The data provider which has changed. If you have multiple data providers, you can use === to determine which one has changed.
- parameter collectionChanges: This object contains information about which indexes were inserted/deleted.
If you access the array of changes, then an ordering of the changes is provided.
If you iterate over these changes, and apply them in order, you will be deleting/inserting the correct indexes.
For instance, if index 3 and 5 were deleted, they would be in decreasing order.
In this way, deleting index 5 does not alter index 3.
You can use this information to run animations on your data or only update certain rows of the view.
- parameter context: Whenever you make a change to a model, you can pass in a context. This context will be passed back to you here.
*/
func collectionDataProviderHasUpdatedData<T>(_ dataProvider: CollectionDataProvider<T>, collectionChanges: CollectionChange, context: Any?)
}

{% endhighlight %}




