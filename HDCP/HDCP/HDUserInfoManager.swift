//
//  HDUserInfoManager.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/16.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class HDUserInfoManager: NSObject {
    
    // 是否已经加载
    private var loaded:Bool = false
    
    
    //用户信息
    var userName:String?
    
    //单例模式
    static var shareInstance: HDUserInfoManager {
        
        struct Singleton {
            static var instance: HDUserInfoManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Singleton.token) {
            Singleton.instance = HDUserInfoManager()
        }
        
        return Singleton.instance!
    }
    
    //加载用户数据
    func load(){
    
        if !loaded {
            
            loaded = true;
            loadUserInfo()
        
        }
    
    }
    
    //保存用户数据
    func save(){
    
        saveUserInfo()
    }
    
    /**
     *  初始化用户数据
     */
    func loadUserInfo(){
    
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.objectForKey("HD_CLIENT_LAST_USERNAME") != nil) {
            
            userName = defaults.objectForKey("HD_CLIENT_LAST_USERNAME") as? String
            
        }
        
    }
    
    /**
     *  保存或更新用户数据
     */
    func saveUserInfo(){
    
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let _ = userName {
            
            defaults .setObject(userName, forKey: "HD_CLIENT_LAST_USERNAME")
            
        }
        
        
        defaults.synchronize()
        
    }
    
    /**
     *  删除用户数据 切换用户或者退出登录
     */
    func deleteUserInfo(){
    
        let defaults = NSUserDefaults.standardUserDefaults()
        
        userName = nil
        defaults.removeObjectForKey("HD_CLIENT_LAST_USERNAME")
    
    }
}