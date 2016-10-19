//
//  HDHM05Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM05Service {

    /**
     菜谱分专辑列表
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    func doGetRequest_HDHM05_URL(_ cid:Int,limit:Int,offset:Int,successBlock:@escaping (_ hm05Response:HDHM05Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
        
        
        HDRequestManager.doPostRequest(["cid":cid as AnyObject,"gid":0 as AnyObject,"limit":limit as AnyObject,"offset":offset as AnyObject], URL: Constants.HDHM05_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDHM05Response>().map(JSONObject: response.result.value)
                /// 回调
                successBlock(response!)
                
            }else{
                
                failBlock(response.result.error! as NSError)
            }
        }
        
    }
    
}
