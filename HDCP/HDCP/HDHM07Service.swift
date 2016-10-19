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
    func doGetRequest_HDHM07_URL(_ limit:Int,offset:Int,successBlock:@escaping (_ hdHM07Response:HDHM07Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
    
        HDRequestManager.doPostRequest(["type":1 as AnyObject,"tagid":0 as AnyObject,"limit":limit as AnyObject,"offset":offset as AnyObject], URL: Constants.HDHM07_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let hdResponse:HDHM07Response = Mapper<HDHM07Response>().map(JSONObject: response.result.value)!
                /// 回调
                successBlock(hdResponse)
                
            }else{
                
                failBlock(response.result.error! as NSError)
                
            }
            
        }

        
    }
}
