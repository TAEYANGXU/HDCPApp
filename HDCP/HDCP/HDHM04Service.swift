//
//  HDHM04Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM04Service {

    /**
     菜谱分类
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    func doGetRequest_HDHM04_URL(_ tagid:Int,limit:Int,offset:Int,successBlock:@escaping (_ hm04Response:HDHM04Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
    
        
        HDRequestManager.doPostRequest(["tagid":tagid as AnyObject,"keyword":"" as AnyObject,"limit":limit as AnyObject,"offset":offset as AnyObject], URL: Constants.HDHM04_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDHM04Response>().map(JSONObject: response.result.value)
                /// 回调
                successBlock(response!)
                
            }else{
                
                failBlock(response.result.error! as NSError)
            }
        }
        
    }
    
}
