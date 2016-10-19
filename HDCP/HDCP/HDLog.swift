//
//  HDLog.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/18.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

/*
*   日志管理
*/
class HDLog {
    
    static func LogOut(_ obj:Any){
    
        if Constants.HDLOG {
        
            print("\(obj)")
            
        }
        
    }
    
    static func LogOut(_ obj_name:Any,obj:Any){
        
        if Constants.HDLOG {
            
            print("\(obj_name):  \(obj)")
            
        }
        
    }
    
    static func LogClassDestory(_ className:Any){
    
        if Constants.HDLOG {
            
            print("\(className) destory")
            
        }
    }
    
}
