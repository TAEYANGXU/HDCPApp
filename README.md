![](https://camo.githubusercontent.com/f0604df64b4db3dad5b2a23439b9c253abedeae3/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f53776966742d332e302d6f72616e67652e737667)<br/>

                                                            微菜谱

结构分析

    General : 公用类和方法，包括工程内ViewController,UITableViewCell基类(Base)，公用Extension(Category)，公用UI组件(CustomUI)，公用辅助方法和宏定义(Helper)。
    Vendors : 第三方库(有些需要用CocoaPods导入进来)
    Service : 网络请求及业务处理
    Model : 数据模型
    Core : 核心管理类
    GG : 逛逛
    Center : 我的
    Category : 分类
    Home : 菜谱
    DY : 动态

第三方库

    Alamofire : 网络数据请求库
    Kingfisher : 网络图片加载库
    MJRefresh : 下拉刷新
    MBProgressHUD ：提示HUD
    SnapKit ：UI自动布局库
    ObjectMapper ：对象映射，Json转Model
    ShareSDK ：实现微信好友，朋友圈，QQ，QQ空间分享(真机才能分享)
    CoreData ：数据本地存储
    HDVideoPlayer：网络视频播放(自定义)

项目备注

    App有些功能还没有实现,会抽空在后续更新。
    要求:IOS8.0以上,Xcode 8.0 以上。

项目运行

  > 运行App需要安装[CocoaPods1.1.0](http://www.cnblogs.com/wayne23/p/3912882.html)，安装完成后,打开终端进入HDCP目录,执行pod install 下载第三方库,下载完成即可运行。<br/> 
  > 打开[CoreData](http://blog.csdn.net/likendsl/article/details/16160677)的SQL语句输出开关<br/> 

Swift学习

  > [The Swift Programming Language 中文版](http://wiki.jikexueyuan.com/project/swift/)<br/> 
  > [Let's Swift – WRITE THE CODE. CHANGE THE WORLD.](http://letsswift.com/)<br/> 
  > [Swift.org](https://swift.org/)<br/> 
  > [Swift开放源码](https://github.com/apple/swift)<br/> 

项目效果图 

   ![](https://github.com/AlbertXYZ/HDCP/raw/master/Images/gif001.gif) ![](https://github.com/AlbertXYZ/HDCP/raw/master/Images/gif002.gif)  ![](https://github.com/AlbertXYZ/HDCP/raw/master/Images/gif003.gif)   ![](https://github.com/AlbertXYZ/HDCP/raw/master/Images/gif004.gif) 

