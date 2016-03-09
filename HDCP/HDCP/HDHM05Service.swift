//
//  HDHM05Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class HDHM05Service {

    /**
     菜谱分专辑列表
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    func doGetRequest_HDHM05_URL(cid:Int,limit:Int,offset:Int,successBlock:(hm05Response:HDHM05Response)->Void,failBlock:(error:NSError)->Void){
        
        
        HDRequestManager.doPostRequest(["cid":cid,"gid":0,"limit":limit,"offset":offset], URL: Constants.HDHM05_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDHM05Response>().map(response.result.value)
                /// 回调
                successBlock(hm05Response: response!)
                
            }else{
                
                failBlock(error: response.result.error!)
            }
        }
        
    }
    
}
