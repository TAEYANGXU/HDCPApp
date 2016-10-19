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
    
    func doGetRequest_HDHM10_URL(_ limit:Int,offset:Int,rid:Int,successBlock:@escaping (_ hdHM10Response:HDHM10Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
        
        HDRequestManager.doPostRequest(["limit":limit as AnyObject,"offset":offset as AnyObject,"rid":rid as AnyObject,"type":0 as AnyObject], URL: Constants.HDHM10_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let hdResponse = Mapper<HDHM10Response>().map(JSONObject: response.result.value)
                /// 回调
                successBlock(hdResponse!)
                
            }else{
                
                failBlock(response.result.error! as NSError)
            }
            
        }
        
    }

    
}
