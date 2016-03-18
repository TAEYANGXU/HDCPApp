//
//  Constants.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

struct HDColor {
    let color:UIColor
    init(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat){
        
        color = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

class Constants: NSObject {

    
    /**
     *   当前设备屏幕的宽带
     **/
    static let HDSCREENWITH = UIScreen.mainScreen().bounds.width
    
    /**
     *   当前设备屏幕的高度
     **/
    static let HDSCREENHEIGHT = UIScreen.mainScreen().bounds.height
    
    /**
     *   日志开关 true:开 false:关
     **/
    static let HDLOG:Bool = true
    
    /**
     *   提示消息
     **/
    static let HD_NO_NET_MSG = "网络好像不给力"
    
    /**
     *   视图间隔
     **/
    static let HDSpace = 10
    
    /**
     *   主题颜色
     **/
    static let HDMainColor = UIColor(red: 105/255.0, green: 149/255.0, blue: 0/255.0, alpha: 1.0);
    static let HDMainTextColor = UIColor(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 1.0);
    static let HDBGViewColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0);
    
    /**
    *  颜色
    */
    
    static func HDColor(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->(UIColor){
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a);
    }
    static func HDHEXRGBA(hex:UInt)->(UIColor){
        return CoreUtils.HDfromHexValue(hex, alpha: 1.0)
    }
    
    /**
     *  frame
     */
     
    static func HDFrame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)->CGRect{
        return CGRectMake(x, y, width, height)
    }
    
    /**
     *   key
     **/
    static let HDAppVersion:String = "Version"
    static let HDHistory:String = "History"
    static let HDSign:String = "HD_CLIENT_SIGN"
    
    /**
     *   通知名称
     **/
     
    static let HDREFRESHHDHM01 = "kHDREFRESHHDHM01"
    static let HDREFRESHHDGG01 = "kHDREFRESHHDGG01"
    static let HDREFRESHHDCT01 = "KHDREFRESHHDCT01"
    
    /*******************************************URL*********************************************/
     
     /**
     *  菜谱
     */
    
    static let HDHM01_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404277925&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Suggest.recipeV3"

    //排行榜
    static let HDHM02_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404785091&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Suggest.top"
    
    //营养餐桌
    static let HDHM03_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404884406&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Wiki.getListByType"
    
    //菜谱分类
    static let HDHM04_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404903331&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Search.getListV3"
    
    //菜谱专辑列表
    static let HDHM05_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404439649&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Collect.getRecipe"
    
    //全部菜谱
    static let HDHM06_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404992779&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Collect.getRecomList"
    
    //全部宝典
    static let HDHM07_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404979448&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Wiki.getListByType"
    
    //菜谱详情  
    static let HDHM08_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404474143&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Info.getInfoV3"
    
    //查看评论
    static let HDHM10_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1405150082&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Comment.getList"
    
     /**
     *  分类
     */
    static let HDCG01_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404959036&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Search.getCateListV3"
    
    //查找菜谱
    static let HDCG03_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1405306406&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Search.getListV3"
     
     /**
     *  逛逛
     */
    static let HDGG01_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404961808&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Guang.getList"
   
    //应用推荐
    static let HDGG02_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404985391&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Ad.getAdV3"
    
    //食材百科
    static let HDGG03_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404959036&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Search.getCateListV3"
    
     /**
     *  我的
     */
     
     //登录
     static let HDCT02_URL = "http://api.haodou.com/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&appsign=f3a04547cbd2f6fa17a2eb523c3ed892&channel=appstore&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7C65E9FB11-64B3-4B5C-A62C-4B53FD796AC4%7C97F90A81-F659-474D-B27E-BE58CDFF30C0&format=json&loguid=&method=Passport.login&nonce=1453797111&sessionid=1453787888&signmethod=md5&timestamp=1453797111&uuid=7408f5dd81db1165cd1896e8175a75e4&v=2&vc=45&vn=v6.0.1"
    
     //个人信息
     static let HDCT02_01_URL = "http://api.haodou.com/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&appsign=b09b40f855d159f234054f608ff7a2c9&channel=appstore&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7C65E9FB11-64B3-4B5C-A62C-4B53FD796AC4%7C97F90A81-F659-474D-B27E-BE58CDFF30C0&format=json&loguid=9428764&method=RecipeUser.getMe&nonce=1453797912&sessionid=1453787888&signmethod=md5&timestamp=1453797912&uuid=7408f5dd81db1165cd1896e8175a75e4&v=2&vc=45&vn=v6.0.1"
    
     //豆友
     static let HDCT08_URL = "http://api.haodou.com/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&appsign=bcf2e0dba529ceeb27fa9c79c41210f6&channel=appstore&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7C65E9FB11-64B3-4B5C-A62C-4B53FD796AC4%7C97F90A81-F659-474D-B27E-BE58CDFF30C0&format=json&loguid=8752979&method=Topic.indexPeople&nonce=1457967130&sessionid=1457966932&signmethod=md5&uuid=7408f5dd81db1165cd1896e8175a75e4&v=2&vc=46&vn=v6.0.3"
    
     //动态
     static let HDCT09_URL = "http://api.haodou.com/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&appsign=753396be0dc7f7d989347d55aa4a13ef&channel=appstore&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7C65E9FB11-64B3-4B5C-A62C-4B53FD796AC4%7C97F90A81-F659-474D-B27E-BE58CDFF30C0&format=json&loguid=8752979&method=UserFeed.getFollowUserFeed&nonce=1457967177&sessionid=1457966932&signmethod=md5&uuid=7408f5dd81db1165cd1896e8175a75e4&v=2&vc=46&vn=v6.0.3"
    
     //话题
     static let HDCT10_URL = "http://api.haodou.com/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&appsign=a76e39e5d361690850a458ae04f01c6c&channel=appstore&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7C65E9FB11-64B3-4B5C-A62C-4B53FD796AC4%7C97F90A81-F659-474D-B27E-BE58CDFF30C0&format=json&loguid=8752979&method=Topic.indexTopic&nonce=1457966947&sessionid=1457966932&signmethod=md5&uuid=7408f5dd81db1165cd1896e8175a75e4&v=2&vc=46&vn=v6.0.3"
    
    //协议
    static let HDCT07_URL = "http://m.haodou.com/about.php?do=privacy"
    /*******************************************END*********************************************/
   
}
