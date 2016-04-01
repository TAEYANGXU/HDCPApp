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
    func doGetRequest_HDDY02_URL(rid:Int,successBlock:(hdResponse:HDDY01Response)->Void,failBlock:(error:NSError)->Void){
        
        HDRequestManager.doPostRequest(["rid":rid,"sign":"4864f65f7e5827e7ea50a48bb70f7a2a","uid":"8752979","timestamp":Int(NSDate().timeIntervalSince1970)], URL: Constants.HDDY02_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDDY01Response>().map(response.result.value)
                /// 回调
                successBlock(hdResponse: response!)
                
            }else{
                
                failBlock(error: response.result.error!)
            }
            
        }
        
    }
}