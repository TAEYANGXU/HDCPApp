//
//  HDDY02Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/4/1.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDDY02Service {
    
    /**
     *  动态详情
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDDY0201_URL(_ rid:Int,successBlock:@escaping (_ hdResponse:HDDY02Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
        
        HDRequestManager.doPostRequest(["rid":rid as AnyObject,"sign":"4864f65f7e5827e7ea50a48bb70f7a2a" as AnyObject,"uid":"8752979" as AnyObject,"timestamp":Int(Date().timeIntervalSince1970) as AnyObject], URL: Constants.HDDY0201_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDDY02Response>().map(JSONObject: response.result.value)
                /// 回调
                successBlock(response!)
                
            }else{
                
                failBlock(response.result.error! as NSError)
            }
            
        }
        
    }
    
    /**
     *  动态详情评论
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDDY0202_URL(_ limit:Int,offset:Int,rid:Int,successBlock:@escaping (_ hdResponse:HDDY0202Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
        HDRequestManager.doPostRequest(["limit":limit as AnyObject,"offset":offset as AnyObject,"rid":rid as AnyObject,"uuid":"7408f5dd81db1165cd1896e8175a75e4" as AnyObject,"sign":"4864f65f7e5827e7ea50a48bb70f7a2a" as AnyObject,"uid":"8752979" as AnyObject,"timestamp":Int(Date().timeIntervalSince1970) as AnyObject], URL: Constants.HDDY0202_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDDY0202Response>().map(JSONObject: response.result.value)
                /// 回调
                successBlock(response!)
                
            }else{
                
                failBlock(response.result.error! as NSError)
            }
            
        }
        
    }

}
