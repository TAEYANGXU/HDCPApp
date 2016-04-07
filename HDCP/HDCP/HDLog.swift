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
    
    static func LogOut(obj:AnyObject){
    
        if Constants.HDLOG {
        
            print("\(obj)")
            
        }
        
    }
    
    static func LogOut(obj_name:AnyObject,obj:AnyObject){
        
        if Constants.HDLOG {
            
            print("\(obj_name):  \(obj)")
            
        }
        
    }
    
    static func LogClassDestory(className:AnyObject){
    
        if Constants.HDLOG {
            
            print("\(className) destory")
            
        }
    }
    
}