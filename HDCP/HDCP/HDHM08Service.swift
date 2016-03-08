//
//  HDHM08Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/18.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class HDHM08Service {

    /**
     菜谱详情
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    func doGetRequest_HDHM08_URL(rid:Int,successBlock:(hdHM08Response:HDHM08Response)->Void,failBlock:(error:NSError)->Void){
    
        HDRequestManager.doPostRequest(["rid":rid], URL: Constants.HDHM08_URL) { (response) -> Void in
            
            if response.result.error == nil {
            
                let hdResponse = Mapper<HDHM08Response>().map(response.result.value)
                successBlock(hdHM08Response: hdResponse!)
                
            }else{
            
                failBlock(error: response.result.error!)
            }
            
        }
        
    }
}