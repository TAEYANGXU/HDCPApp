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
    func doGetRequest_HDHM02_URL(_ successBlock:@escaping (_ hdHM02Response:HDHM02Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
    
        HDRequestManager.doGetRequest(Constants.HDHM02_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let hd02Response = Mapper<HDHM02Response>().map(JSONObject: response.result.value)
                /// 回调
                successBlock(hd02Response!)
                
            }else{
                
                failBlock(response.result.error! as NSError)
            }
            
        }

    }
    
}
