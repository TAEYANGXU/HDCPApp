                                                            微菜谱

用到的第三方库

    Alamofire : 网络请求库(Swift)
    SDWebImage : 图片加载库(OC)
    MJRefresh : 下拉刷新(OC)
    MBProgressHUD ：提示HUD(OC)
    SnapKit ：Swift版的Masonry,自动布局
    ObjectMapper ：对象映射，Json转Model(Swift)
    ShareSDK ：实现微信好友，朋友圈，QQ，QQ空间分享
    CoreData ：所有Tab主页做了本地存储

目录结构分析

    General : 公用类和方法，包括工程内ViewController,UITableViewCell基类(Base)，公用Extension(Category)，公用UI组件(CustomUI)，公用辅助方法(Helper)和宏定义(Marco)。
    Vendors : 第三方库(有些需要用Pods导入进来)
    Service : 网络请求及业务处理
    Model : 数据模型
    Core : 核心管理类
    GG : 逛逛
    Center : 我的
    Category : 分类
    Home : 菜谱

后续工作

    修复现有问题
    实现未实现的功能

备注

    App有些功能还没有实现,会抽空在后续更新,敬请期待。
    要求:IOS8.0以上,Xcode 7.0 以上。
    如果哪里写得不好可以相互交流,本人QQ:498193471 非诚勿扰 谢谢 

APP运行

  运行App需要安装[CocoaPods](http://www.cnblogs.com/wayne23/p/3912882.html "CocoaPods安装和使用")，安装完成后,打开终端进入HDCP目录,执行pod install 下载第三方库,下载完成即可运行。

效果图

   ![](https://github.com/AlbertXYZ/HDCP/raw/master/Images/CP.gif)  ![](https://github.com/AlbertXYZ/HDCP/raw/master/Images/GG.gif)   ![](https://github.com/AlbertXYZ/HDCP/raw/master/Images/FL.gif) ![](https://github.com/AlbertXYZ/HDCP/raw/master/Images/PHB.gif)  ![](https://github.com/AlbertXYZ/HDCP/raw/master/Images/FXCP.gif) 

