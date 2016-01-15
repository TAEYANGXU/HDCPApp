//
//  Constants.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class Constants: NSObject {

    
    /**
     *   当前设备屏幕的宽带
     **/
    static let kSCREENWITH = UIScreen.mainScreen().bounds.width
    
    /**
     *   当前设备屏幕的高度
     **/
    static let kSCREENHEIGHT = UIScreen.mainScreen().bounds.height
    
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
    class func HDColor(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->(UIColor){
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a);
    }
    class func HDHEXRGBA(hex:UInt)->(UIColor){
        return CoreUtils.HDfromHexValue(hex, alpha: 1.0)
    }
    
    /**
     *  frame
     */
     
    class func HDFrame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)->CGRect{
        return CGRectMake(x, y, width, height)
    }
    
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
    /**
     *  搜索
     */
     
     /**
     *  分类
     */
     static let HDCG01_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404959036&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Search.getCateListV3"
     
     /**
     *  逛逛
     */
    static let HDGG01_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404961808&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Guang.getList"
     
     /**
     *  我的
     */
    
    /*******************************************END*********************************************/
   
}
