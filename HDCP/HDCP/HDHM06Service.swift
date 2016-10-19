//
//  HDHM06Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/17.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM06Service {
    
    /**
     全部菜谱
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    func doGetRequest_HDHM06_URL(_ limit:Int,offset:Int,successBlock:@escaping (_ hdHM06Response:HDHM06Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
    
        HDRequestManager.doPostRequest(["limit":limit as AnyObject,"offset":offset as AnyObject], URL: Constants.HDHM06_URL) { (response) -> Void in
            
            if response.result.error == nil {
            
                /// JSON 转换成对象
                let hdResponse:HDHM06Response = Mapper<HDHM06Response>().map(JSONObject: response.result.value)!
                /// 回调
                successBlock(hdResponse)
                
            }else{
            
                failBlock(response.result.error! as NSError)
                
            }
            
        }
        
    }
    
}
