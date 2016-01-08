//
//  HDGG01Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/8.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDGG01Service: HDRequestManager {

    
    /**
     逛逛主页数据
     
     - parameter successBlock: 成功
     - parameter failBlock:    失败
     */
    func doGetRequest_HDGG01_URL(successBlock:(hdResponse:HDGG01Response)->Void,failBlock:(error:NSError)->Void){

        super.doPostRequest(["limit":"20","offset":"0"], URL: Constants.HDGG01_URL) { (response) -> Void in

            if response.result.error == nil {
                
                let hdggResponse = Mapper<HDGG01Response>().map(response.result.value)
                
                let array2D = NSMutableArray()
                var array:NSMutableArray?
                
                for var i=0;i<hdggResponse?.result?.gg01List?.count;i++ {
                
                    if i%3 == 0 {
                        array = nil
                        array = NSMutableArray()
                        array2D.addObject(array!)
                        
                    }
                    
                    array?.addObject((hdggResponse?.result?.gg01List![i])!)
                    
                }
                
                array2D.removeLastObject()
                
                hdggResponse?.array2D = array2D
                
                successBlock(hdResponse: hdggResponse!)
                
            }else{
                
                failBlock(error: response.result.error!)
            }

        }
        
    }
    
}
