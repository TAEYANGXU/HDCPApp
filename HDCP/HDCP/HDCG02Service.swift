 //
//  HDCG02Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class HDCG02Service: HDRequestManager {

    /**
     分类
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    func doGetRequest_HDCG02_URL(successBlock:(hdCG02Response:HDCG02Response)->Void,failBlock:(error:NSError)->Void){
        
        
        super.doGetRequest(Constants.HDCG01_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                let response = Mapper<HDCG02Response>().map(response.result.value)
                successBlock(hdCG02Response: response!)
                
            }else{
                
                failBlock(error: response.result.error!)
            }
            
        }

        
    }

    
}
