//
//  HDHM03Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/13.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class HDHM03Service {

    
    /**
     逛逛主页数据
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    func doGetRequest_HDHM03_URL(limit:Int,offset:Int,successBlock:(hdResponse:HDHM03Response)->Void,failBlock:(error:NSError)->Void){
        
        print("offset :\(offset)")
        
        HDRequestManager.doPostRequest(["type":"2","offset":offset,"limit":limit,"tagid":"0"], URL: Constants.HDHM03_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let hdggResponse = Mapper<HDHM03Response>().map(response.result.value)
                /// 回调
                successBlock(hdResponse: hdggResponse!)
                
            }else{
                
                failBlock(error: response.result.error!)
            }
            
        }
        
    }
    
}
