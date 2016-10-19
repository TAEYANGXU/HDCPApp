//
//  HDHM03Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/13.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM03Service {

    
    /**
     逛逛主页数据
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    func doGetRequest_HDHM03_URL(_ limit:Int,offset:Int,successBlock:@escaping (_ hdResponse:HDHM03Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
        
        HDRequestManager.doPostRequest(["type":"2" as AnyObject,"offset":offset as AnyObject,"limit":limit as AnyObject,"tagid":"0" as AnyObject], URL: Constants.HDHM03_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let hdggResponse = Mapper<HDHM03Response>().map(JSONObject: response.result.value)
                /// 回调
                successBlock(hdggResponse!)
                
            }else{
                
                failBlock(response.result.error! as NSError)
            }
            
        }
        
    }
    
}
