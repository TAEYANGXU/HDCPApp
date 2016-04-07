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
    func doGetRequest_HDDY0201_URL(rid:Int,successBlock:(hdResponse:HDDY02Response)->Void,failBlock:(error:NSError)->Void){
        
        HDRequestManager.doPostRequest(["rid":rid,"sign":"4864f65f7e5827e7ea50a48bb70f7a2a","uid":"8752979","timestamp":Int(NSDate().timeIntervalSince1970)], URL: Constants.HDDY0201_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDDY02Response>().map(response.result.value)
                /// 回调
                successBlock(hdResponse: response!)
                
            }else{
                
                failBlock(error: response.result.error!)
            }
            
        }
        
    }
    
    /**
     *  动态详情评论
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDDY0202_URL(limit:Int,offset:Int,rid:Int,successBlock:(hdResponse:HDDY0202Response)->Void,failBlock:(error:NSError)->Void){
        HDRequestManager.doPostRequest(["limit":limit,"offset":offset,"rid":rid,"uuid":"7408f5dd81db1165cd1896e8175a75e4","sign":"4864f65f7e5827e7ea50a48bb70f7a2a","uid":"8752979","timestamp":Int(NSDate().timeIntervalSince1970)], URL: Constants.HDDY0202_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDDY0202Response>().map(response.result.value)
                /// 回调
                successBlock(hdResponse: response!)
                
            }else{
                
                failBlock(error: response.result.error!)
            }
            
        }
        
    }

}