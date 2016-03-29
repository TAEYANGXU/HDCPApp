//
//  HDHM02Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/12.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM02Service {

    /**
     排行榜
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    func doGetRequest_HDHM02_URL(successBlock:(hdHM02Response:HDHM02Response)->Void,failBlock:(error:NSError)->Void){
    
        HDRequestManager.doGetRequest(Constants.HDHM02_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let hd02Response = Mapper<HDHM02Response>().map(response.result.value)
                /// 回调
                successBlock(hdHM02Response: hd02Response!)
                
            }else{
                
                failBlock(error:response.result.error!)
            }
            
        }

    }
    
}
