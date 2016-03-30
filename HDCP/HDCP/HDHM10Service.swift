//
//  HDHM10Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/30.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM10Service {
    
    /**
     评论详情
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    
    func doGetRequest_HDHM10_URL(limit:Int,offset:Int,rid:Int,successBlock:(hdHM10Response:HDHM10Response)->Void,failBlock:(error:NSError)->Void){
        
        HDRequestManager.doPostRequest(["limit":limit,"offset":offset,"rid":rid,"type":0], URL: Constants.HDHM10_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let hdResponse = Mapper<HDHM10Response>().map(response.result.value)
                /// 回调
                successBlock(hdHM10Response: hdResponse!)
                
            }else{
                
                failBlock(error: response.result.error!)
            }
            
        }
        
    }

    
}