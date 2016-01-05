//
//  HDHM01Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/5.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM01Service: HDRequestManager {

    /**
     菜谱主页数据
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    func doGetRequest_HDHM01_URL(successBlock:((hdResponse:HDHM01Response)->Void),failBlock:((error:NSError)->Void)){
    
        
        super.doGetRequest(Constants.HDHM01_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                let hdHM01Response = Mapper<HDHM01Response>().map(response.result.value)
                successBlock(hdResponse:hdHM01Response!)
                
            }else{
                
                failBlock(error:response.result.error!)
            }

        }
        
    }
    
}
