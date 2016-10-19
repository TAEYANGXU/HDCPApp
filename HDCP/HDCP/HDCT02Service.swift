//
//  HDCT02Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/17.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDCT02Service {
    
    /**
    *  登录
    *
    * parameter successBlock: 成功
    * parameter failBlock:    失败
    */
    
    func doGetRequest_HDCT02_URL(_ name:String,pwd:String,successBlock:@escaping (_ hdResponse:HDCT02Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
    
        HDRequestManager.doPostRequest(["name":name as AnyObject,"pwd":"w2eRuQ%2BRlzi%2BK48lE6Hl8BYy8ryWOVlZjy6oz3qEHQgvGDsvchjIuoR0BkdSTxXVGhlRL%2FR3t3WazrIzl%2Fi6RbITk14kSLAXqwV%2B%2B%2BKojJbXW3%2FpjTQo%2FujiTKMIXYxZlGg9ulpaSVOyHzRiBGc0vjdFsR2CRzjekbCEwuwX5M0%3D" as AnyObject,"uuid":"7408f5dd81db1165cd1896e8175a75e4" as AnyObject], URL: Constants.HDCT02_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
//                //使用SwiftyJSON解析data
//                let json = JSON(data: response.data!)
//                
//                if json["status"] == 201 {
//                
//                    //登录失败
//                    let str = json["result"]["errormsg"]
//                    HDLog.LogOut("errormsg = ", obj: str.string!)
//                    
//                }else{
//                    // JSON 转换成对象
//                    let response = Mapper<HDCT02Response>().map(JSONObject: response.result.value)
//                    // 回调
//                     successBlock(response!)
//                    
//                }
                
            }else{
                
                failBlock(response.result.error! as NSError)
            }
            
        }
        
    }
    
    /**
    *  个人信息
    *
    * parameter successBlock: 成功
    * parameter failBlock:    失败
    */
    func doGetRequest_HDCT02_01_URL(_ userId:String,successBlock:@escaping (_ hdResponse:HDCT02Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
    
        
        HDRequestManager.doPostRequest(["uid":userId as AnyObject,"sign":"4864f65f7e5827e7ea50a48bb70f7a2a" as AnyObject,"uuid":"7408f5dd81db1165cd1896e8175a75e4" as AnyObject], URL: Constants.HDCT02_01_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                // JSON 转换成对象
                let response = Mapper<HDCT02Response>().map(JSONObject: response.result.value)
                
                //保存用户个人信息
                HDUserInfoManager.shareInstance.sign = "4864f65f7e5827e7ea50a48bb70f7a2a"
                HDUserInfoManager.shareInstance.userName = response?.result?.userName
                HDUserInfoManager.shareInstance.userId = response?.result?.userId
                HDUserInfoManager.shareInstance.mobile = response?.result?.mobile
                HDUserInfoManager.shareInstance.followCnt = response?.result?.allFollowCnt
                HDUserInfoManager.shareInstance.fansCount = response?.result?.fansCount
                HDUserInfoManager.shareInstance.friendCnt = response?.result?.friendCnt
                HDUserInfoManager.shareInstance.consumerMobile = response?.result?.consumerMobile
                HDUserInfoManager.shareInstance.birthday = response?.result?.birthday
                HDUserInfoManager.shareInstance.avatar = response?.result?.avatar
                HDUserInfoManager.shareInstance.vip = response?.result?.vip
                HDUserInfoManager.shareInstance.gender = response?.result?.gender
                HDUserInfoManager.shareInstance.save()
                
                // 回调
                successBlock(response!)
                
            }else{
                
                failBlock(response.result.error! as NSError)
            }
            
        }
    }
    
    
}
