//
//  HDHM07Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/17.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM07Service {
 
    /**
    全部宝典
    
    - parameter successBlock: 成功
    - parameter failBlock:    失败
    */
    func doGetRequest_HDHM07_URL(limit:Int,offset:Int,successBlock:(hdHM07Response:HDHM07Response)->Void,failBlock:(error:NSError)->Void){
    
        HDRequestManager.doPostRequest(["type":1,"tagid":0,"limit":limit,"offset":offset], URL: Constants.HDHM07_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let hdResponse:HDHM07Response = Mapper<HDHM07Response>().map(response.result.value)!
                /// 回调
                successBlock(hdHM07Response: hdResponse)
                
            }else{
                
                failBlock(error: response.result.error!)
                
            }
            
        }

        
    }
}