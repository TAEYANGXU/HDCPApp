//
//  HDHM06Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/17.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation


class HDHM06Service {
    
    /**
     全部菜谱
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    func doGetRequest_HDHM06_URL(limit:Int,offset:Int,successBlock:(hdHM06Response:HDHM06Response)->Void,failBlock:(error:NSError)->Void){
    
        HDRequestManager.doPostRequest(["limit":limit,"offset":offset], URL: Constants.HDHM06_URL) { (response) -> Void in
            
            if response.result.error == nil {
            
                let hdResponse:HDHM06Response = Mapper<HDHM06Response>().map(response.result.value)!
                successBlock(hdHM06Response: hdResponse)
                
            }else{
            
                failBlock(error: response.result.error!)
                
            }
            
        }
        
    }
    
}