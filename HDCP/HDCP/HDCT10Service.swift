//
//  HDCT10Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/15.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class HDCT10Service {
    
    /**
     *  话题
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDCT10_URL(limit:Int,offset:Int,successBlock:(hdResponse:HDCT10Response)->Void,failBlock:(error:NSError)->Void){
    
        HDRequestManager.doPostRequest(["limit":20,"offset":0,"uid":"8752979","timestamp":Int(NSDate().timeIntervalSince1970)], URL: Constants.HDCT10_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDCT10Response>().map(response.result.value)
                /// 回调
                successBlock(hdResponse: response!)
                
            }else{
                
                failBlock(error: response.result.error!)
            }
            
        }

    }
}