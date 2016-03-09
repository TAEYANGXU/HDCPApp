//
//  HDCG03Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/22.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class HDCG03Service {
    
    /**
     菜谱搜索
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDCG03_URL(keyword:String,limit:Int,offset:Int,successBlock:(hm04Response:HDHM04Response)->Void,failBlock:(error:NSError)->Void){
        
        
        HDRequestManager.doPostRequest(["tagid":"","keyword":keyword,"limit":limit,"offset":offset], URL: Constants.HDCG03_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDHM04Response>().map(response.result.value)
                /// 回调
                successBlock(hm04Response: response!)
                
            }else{
                
                failBlock(error: response.result.error!)
            }
        }
        
    }
    
}