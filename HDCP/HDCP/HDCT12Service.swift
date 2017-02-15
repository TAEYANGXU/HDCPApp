//
//  HDCT12Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 2017/2/15.
//  Copyright © 2017年 batonsoft. All rights reserved.
//

import UIKit
import ObjectMapper

class HDCT12Service: NSObject {

    func doGetRequest_HDCT12_URL(_ successBlcok:(_ hdResponse:HDCT11Response)->Void,failBlock:(_ error:NSError)->Void){
        
        HDRequestManager.doPostRequest(["cateid":"33" as AnyObject,"sign":"4864f65f7e5827e7ea50a48bb70f7a2a" as AnyObject,"limit":20 as AnyObject,"offset":0 as AnyObject,"uid":"8752979" as AnyObject,"timestamp":Int(Date().timeIntervalSince1970) as AnyObject], URL: Constants.HDCT12_URL) { (response) -> Void in
            
           
            
        }
    }
    
}
