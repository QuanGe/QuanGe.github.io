---
layout: post
title: rails 实现login登录系统（一）
---

### rails创建一个login的工程，用来实现服务器和web登录功能
cd
mkdir quange
cd quange
rails new login

如果执行rails new login 没反映，但是已经列出功能目录来了， 则control+c
cd login 
ls -a

可以看到很多文件夹，下面我们大概说一下各个文件夹的功能
app :存放程序的控制器、模型、视图、帮助方法、邮件和静态资源文件。本文主要关注的是这个文件夹。
bin ：存放运行程序的 rails 脚本，以及其他用来部署或运行程序的脚本。
config：设置程序的路由，数据库等
config.ru ：基于 Rack 服务器的程序设置，用来启动程序。
db/ ：存放当前数据库的模式，以及数据库迁移文件
Gemfile, Gemfile.lock  ：如果你用过iOS的pods ，他们相当于Podfile文件，如果没用过，我想说 就是配置第三库都有哪些及哪个版本
lib ：程序的扩展模块 一些其他项目可以拿过来直接用的 通用代码神马的，领带就是自己添加的rake任务
log ：程序的日志文件 对于服务器来讲 ，日志 相当重要哦 ，切忌
public：唯一对外开放的文件夹，存放静态文件和编译后的资源文件，我们可以cd到里面看到 是404 500 什么的网页
Rakefile ：保存并加载可在命令行中执行的任务。任务在 Rails 的各组件中定义。如果想添加自己的任务，不要修改这个文件，把任务保存在 lib/tasks 文件夹中。
README.rdoc ：这还用说么readme 哪个项目没有？
test ：单元测试，固件等测试用文件
tmp ：临时文件，例如缓存，PID，会话文件
vendor：存放第三方代码。经常用来放第三方 gem。

### 让web网页访问的时候提示 “泉哥登录系统”

rails 项目主要由四大部分组成 route（对客户端都开放哪些接口） viewcontroller（接口怎么实现） view（web网页如何显示） model（对应数据库的哪个表，及都怎么操作）

ok，我们现在需要有个login的index的接口 ，得有以上内容，先来viewcontroller 和 view吧 

rails g controller login index
或者
rails generate controller login index

rails会给我们生成
 create  app/controllers/login_controller.rb
       route  get "login/index"
      invoke  erb
      create    app/views/login
      create    app/views/login/index.html.erb
      invoke  test_unit
      create    test/functional/login_controller_test.rb
      invoke  helper
      create    app/helpers/login_helper.rb
      invoke    test_unit
      create      test/unit/helpers/login_helper_test.rb
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/login.js.coffee
      invoke    scss
      create      app/assets/stylesheets/login.css.scss
看到没rails还挺周到的 连css js，route都给我们弄好了 

好了。用rubymine打开我们的项目吧 
打开app/views/login/index.html.erb 将里面的内容改为 <h1>泉哥登录系统</h1>


ok 运行吧 
bundle install 

rails server 或者rails s

打开浏览器 访问 http://localhost:3000/login/index

我们已经看到我们想要的效果了，but 我想要http://localhost:3000 也是这样的。

打开config/routes.rb 可以看到 get "login/index" ，这句话的意思的是 我们对客户端开放一个接口是 login/index，也可以是get "login/index" => 'login#index'。我们要在下面添加 root :to => 'login#index'

然后 我们执行 
rake routes 
就可以看到 当前项目 由多少个接口
现在 如果在运行服务器的话 按下control+c 停止服务器 然后 再执行rails s
再访问http://localhost:3000 还是不显示 泉哥登录系统 ，仔细看界面Welcome aboard的第二步，要删除public/index.html。删除后再试，可以了。如果还不可以，那就是浏览器缓存，清理一下就可以了



