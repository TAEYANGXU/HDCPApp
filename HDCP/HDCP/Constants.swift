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
     *   主题颜色  1:251 161 45  2:148 205 106
     **/
    static let HDMainColor = UIColor(red: 251/255.0, green: 161/255.0, blue: 45/255.0, alpha: 1.0);
    
    /**
    *  颜色
    */
    class func HDColor(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->(UIColor){
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a);
    }
    
}
