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
     *   主题颜色
     **/
    static let HDMainColor = UIColor(red: 105/255.0, green: 149/255.0, blue: 0/255.0, alpha: 1.0);
    static let HDMainTextColor = UIColor(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 1.0);

    /**
    *  颜色
    */
    class func HDColor(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->(UIColor){
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a);
    }
    
    /*******************************************URL*********************************************/
     
     /**
     *  首页
     */
     static let HDHM01_URL = "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404277925&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Suggest.recipeV3"
     
    /*******************************************END*********************************************/
    /**
     返回按钮
     
     - parameter sel: 事件
     
     - returns: 按钮
     
     self.navigationItem.leftBarButtonItem = Constants.HDBackBarButtonItem("doThing:", taget: self)
     
     */
    class func HDBackBarButtonItem(sel:Selector,taget:AnyObject)->(UIBarButtonItem){
    
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 10, 20)
        button.setBackgroundImage(UIImage(named: "back_icon_white"), forState: UIControlState.Normal)
        button.addTarget(taget, action: sel, forControlEvents: UIControlEvents.TouchUpInside)
        button.contentMode = UIViewContentMode.ScaleToFill
        let backItem = UIBarButtonItem(customView: button)
        
        return backItem;
    }
}
