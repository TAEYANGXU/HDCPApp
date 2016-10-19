//
//  HDHM08Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/18.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM08Service {

    /**
     菜谱详情
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    func doGetRequest_HDHM08_URL(_ rid:Int,successBlock:@escaping (_ hdHM08Response:HDHM08Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
    
        HDRequestManager.doPostRequest(["rid":rid as AnyObject], URL: Constants.HDHM08_URL) { (response) -> Void in
            
            if response.result.error == nil {
            
                /// JSON 转换成对象'
                let hdResponse = Mapper<HDHM08Response>().map(JSONObject: response.result.value)
//                let hdResponse = Mapper<HDHM08Response>().map(JSONObject: response.result.value)
                /// 回调
                successBlock(hdResponse!)
                
            }else{
            
                failBlock(response.result.error! as NSError)
            }
            
        }
        
    }
}
