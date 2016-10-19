//
//  HDUserInfoManager.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/16.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

let single = HDUserInfoManager()

class HDUserInfoManager {
    
    // 是否已经加载
    fileprivate var loaded:Bool = false
    
    
    /**
     *  用户个人信息
     */
    
    //昵称
    var userName:String?
    //密码
    var passWord:String?
    //用户ID
    var userId:Int?
    //手机码号
    var mobile:String?
    //关注数
    var followCnt:Int?
    //粉丝数
    var fansCount:Int?
    //好友数
    var friendCnt:Int?
    //客服电话
    var consumerMobile:String?
    //出生年月
    var birthday:String?
    //用户头像
    var avatar:String?
    //登录标示
    var sign:String?
    //会员
    var vip:Int?
    //性别
    var gender:Int?
    
    //单例模式
    static var shareInstance: HDUserInfoManager {
        
        return single
    }
    
    /**
    *  加载用户数据
    */
    func load(){
    
        if !loaded {
            
            loaded = true;
            loadUserInfo()
        
        }
    
    }
    
    /**
    *  保存用户数据.
    */
    func save(){
    
        saveUserInfo()
    }
    
    /**
     *  删除用户数据 切换用户或者退出登录
     */
    func clear(){
    
        deleteUserdeInfo()
    }
    
    /**
     *  初始化用户数据
     */
    fileprivate func loadUserInfo(){
    
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "HD_CLIENT_USERNAME") != nil) {
            
            userName = defaults.object(forKey: "HD_CLIENT_USERNAME") as? String
            
        }
        
        if (defaults.object(forKey: "HD_CLIENT_PASSWORD") != nil) {
            
            passWord = defaults.object(forKey: "HD_CLIENT_PASSWORD") as? String
            
        }
        
        if (defaults.object(forKey: "HD_CLIENT_USERID") != nil) {
            
            userId = defaults.object(forKey: "HD_CLIENT_USERID") as? Int
            
        }
        
        if (defaults.object(forKey: "HD_CLIENT_MOBILE") != nil) {
            
            mobile = defaults.object(forKey: "HD_CLIENT_MOBILE") as? String
            
        }
        
        if (defaults.object(forKey: "HD_CLIENT_FOLLOWCNT") != nil) {
            
            followCnt = defaults.object(forKey: "HD_CLIENT_FOLLOWCNT") as? Int
            
        }
        
        if (defaults.object(forKey: "HD_CLIENT_FANSCNT") != nil) {
            
            fansCount = defaults.object(forKey: "HD_CLIENT_FANSCNT") as? Int
            
        }
        
        if (defaults.object(forKey: "HD_CLIENT_FRIENDCNT") != nil) {
            
            friendCnt = defaults.object(forKey: "HD_CLIENT_FRIENDCNT") as? Int
            
        }
        
        if (defaults.object(forKey: "HD_CLIENT_CONSUMERMOBILE") != nil) {
            
            consumerMobile = defaults.object(forKey: "HD_CLIENT_CONSUMERMOBILE") as? String
            
        }
        
        if (defaults.object(forKey: "HD_CLIENT_BIRTHDAY") != nil) {
            
            birthday = defaults.object(forKey: "HD_CLIENT_BIRTHDAY") as? String
            
        }
        
        if (defaults.object(forKey: "HD_CLIENT_AVATAR") != nil) {
            
            avatar = defaults.object(forKey: "HD_CLIENT_AVATAR") as? String
            
        }
        
        if (defaults.object(forKey: Constants.HDSign) != nil) {
            
            sign = defaults.object(forKey: Constants.HDSign) as? String
            
        }
        
        if (defaults.object(forKey: "HD_CLIENT_GENDER") != nil) {
            
            gender = defaults.object(forKey: "HD_CLIENT_GENDER") as? Int
            
        }
        
        if (defaults.object(forKey: "HD_CLIENT_VIP") != nil) {
            
            vip = defaults.object(forKey: "HD_CLIENT_VIP") as? Int
            
        }
        
    }
    
    /**
     *  保存或更新用户数据
     */
    fileprivate func saveUserInfo(){
    
        let defaults = UserDefaults.standard
        
        if let _ = userName {
            
            defaults .setValue(userName, forKey: "HD_CLIENT_USERNAME")
            
        }
        
        if let _ = passWord {
        
            defaults .setValue(userName, forKey: "HD_CLIENT_PASSWORD")
        }
        
        if let _ = userId {
            
            defaults .setValue(userId, forKey: "HD_CLIENT_USERID")
        }
        
        if let _ = mobile {
            
            defaults .setValue(mobile, forKey: "HD_CLIENT_MOBILE")
        }
        
        if let _ = followCnt {
            
            defaults .setValue(followCnt, forKey: "HD_CLIENT_FOLLOWCNT")
        }
        
        if let _ = fansCount {
            
            defaults .setValue(fansCount, forKey: "HD_CLIENT_FANSCNT")
        }
        
        if let _ = friendCnt {
            
            defaults .setValue(friendCnt, forKey: "HD_CLIENT_FRIENDCNT")
        }
        
        if let _ = consumerMobile {
            
            defaults .setValue(consumerMobile, forKey: "HD_CLIENT_CONSUMERMOBILE")
        }
        
        if let _ = birthday {
            
            defaults .setValue(birthday, forKey: "HD_CLIENT_BIRTHDAY")
        }
        
        if let _ = avatar {
            
            defaults .setValue(avatar, forKey: "HD_CLIENT_AVATAR")
        }
        
        if let _ = sign {
            
            defaults .setValue(sign, forKey: Constants.HDSign)
        }
        
        if let _ = gender {
            
            defaults .setValue(gender, forKey: "HD_CLIENT_GENDER")
        }
        
        if let _ = vip {
            
            defaults .setValue(sign, forKey: "HD_CLIENT_VIP")
        }
        
        
        defaults.synchronize()
        
    }
    
    /**
     *  删除用户数据 切换用户或者退出登录
     */
    fileprivate func deleteUserdeInfo(){
    
        let defaults = UserDefaults.standard
        
        userName = nil
        defaults.removeObject(forKey: "HD_CLIENT_USERNAME")
        
        passWord = nil
        defaults.removeObject(forKey: "HD_CLIENT_PASSWORD")
        
        userId = nil
        defaults.removeObject(forKey: "HD_CLIENT_USERID")
        
        mobile = nil
        defaults.removeObject(forKey: "HD_CLIENT_MOBILE")
        
        followCnt = nil
        defaults.removeObject(forKey: "HD_CLIENT_FOLLOWCNT")
        
        fansCount = nil
        defaults.removeObject(forKey: "HD_CLIENT_FANSCNT")
        
        friendCnt = nil
        defaults.removeObject(forKey: "HD_CLIENT_FRIENDCNT")
        
        consumerMobile = nil
        defaults.removeObject(forKey: "HD_CLIENT_CONSUMERMOBILE")
        
        birthday = nil
        defaults.removeObject(forKey: "HD_CLIENT_BIRTHDAY")
        
        avatar = nil
        defaults.removeObject(forKey: "HD_CLIENT_AVATAR")
    
        sign = nil
        defaults.removeObject(forKey: Constants.HDSign)
        
        gender = nil
        defaults.removeObject(forKey: "HD_CLIENT_GENDER")
        
        vip = nil
        defaults.removeObject(forKey: "HD_CLIENT_VIP")
        
        defaults.removeObject(forKey: Constants.HDHistory)
        
    }
}
