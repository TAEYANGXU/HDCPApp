//
//  HDDY01Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/30.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDDY01Service {
    
    /**
     *  动态
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDDY01_URL(limit:Int,offset:Int,successBlock:(hdResponse:HDDY01Response)->Void,failBlock:(error:NSError)->Void){
        
        HDRequestManager.doPostRequest(["sign":"4864f65f7e5827e7ea50a48bb70f7a2a","limit":20,"offset":0,"uid":"8752979","timestamp":Int(NSDate().timeIntervalSince1970)], URL: Constants.HDDY01_URL) { (response) -> Void in
            
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