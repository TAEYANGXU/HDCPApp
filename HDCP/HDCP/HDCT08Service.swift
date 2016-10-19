//
//  HDCT08Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/15.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDCT08Service {
    
    /**
     *  豆友列表
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDCT08_URL(_ limit:Int,offset:Int,successBlock:@escaping (_ hdResponse:HDCT08Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
    
        HDRequestManager.doPostRequest(["limit":20 as AnyObject,"offset":0 as AnyObject,"uid":"8752979" as AnyObject,"timestamp":Int(Date().timeIntervalSince1970) as AnyObject,"sign":"4864f65f7e5827e7ea50a48bb70f7a2a" as AnyObject], URL: Constants.HDCT08_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDCT08Response>().map(JSONObject: response.result.value)
                /// 回调
                successBlock(response!)
                
            }else{
                
                failBlock(response.result.error! as NSError)
            }
            
        }
        
    }
    
    
}
