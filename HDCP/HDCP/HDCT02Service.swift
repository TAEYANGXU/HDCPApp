//
//  HDCT02Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/17.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class HDCT02Service {
    
    /**
    *  登录
    *
    * parameter successBlock: 成功
    * parameter failBlock:    失败
    */
    
    func doGetRequest_HDCT02_URL(name:String,pwd:String,successBlock:(hdResponse:HDCT02Response)->Void,failBlock:(error:NSError)->Void){
    
        HDRequestManager.doPostRequest(["name":name,"pwd":"w2eRuQ%2BRlzi%2BK48lE6Hl8BYy8ryWOVlZjy6oz3qEHQgvGDsvchjIuoR0BkdSTxXVGhlRL%2FR3t3WazrIzl%2Fi6RbITk14kSLAXqwV%2B%2B%2BKojJbXW3%2FpjTQo%2FujiTKMIXYxZlGg9ulpaSVOyHzRiBGc0vjdFsR2CRzjekbCEwuwX5M0%3D","uuid":"7408f5dd81db1165cd1896e8175a75e4"], URL: Constants.HDCT02_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                //使用SwiftyJSON解析
                let json = JSON(data: response.data!)
                
                if json["status"] == 201 {
                
                    //登录失败
                    print("errormsg = \(json["result"]["errormsg"])")
                    
                }else{
                    // JSON 转换成对象
                    let response = Mapper<HDCT02Response>().map(response.result.value)
                    // 回调
                     successBlock(hdResponse: response!)
                    
                }
                
            }else{
                
                failBlock(error: response.result.error!)
            }
            
        }
        
    }
    
    /**
    *  个人信息
    *
    * parameter successBlock: 成功
    * parameter failBlock:    失败
    */
    func doGetRequest_HDCT02_01_URL(userId:String,successBlock:(hdResponse:HDCT02Response)->Void,failBlock:(error:NSError)->Void){
    
        
        HDRequestManager.doPostRequest(["uid":userId,"sign":"4864f65f7e5827e7ea50a48bb70f7a2a","uuid":"7408f5dd81db1165cd1896e8175a75e4"], URL: Constants.HDCT02_01_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                // JSON 转换成对象
                let response = Mapper<HDCT02Response>().map(response.result.value)
                // 回调
                successBlock(hdResponse: response!)
                
            }else{
                
                failBlock(error: response.result.error!)
            }
            
        }
    }
    
    
}