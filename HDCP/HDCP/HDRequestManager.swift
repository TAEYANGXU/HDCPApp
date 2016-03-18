//
//  HDRequestManager.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/5.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import Alamofire

public class HDRequestManager: NSObject {

    /**
     服务器数据请求:GET方式
     *
     * parameter url:    URL地址
     * parameter block:  返回结果集
     */
    static func doGetRequest(URL:String,completeBlock:((response:Response<AnyObject, NSError>)->Void)){
        
        HDLog.LogOut("PostURL", obj: URL)
        
        Alamofire.request(.GET, URL)
            .responseJSON { response in
                
                if response.result.error == nil {
                    
                    /**
                     *  请求成功
                     */
                    let text:String = NSString(data: response.data!, encoding: NSUTF8StringEncoding)! as String
                    HDLog.LogOut("Data", obj: text)
                    
                    
                }else{
                
                    /**
                    请求出错了
                    
                    - print: 错误信息
                    */
                    HDLog.LogOut("error", obj: (response.result.error?.description)!)
                    
                }
                
                completeBlock(response: response)
                
        }
        
    }
    
    
    /**
     服务器数据请求:POST方式
     *
     * parameter url:    URL地址
     * parameter block:  返回结果集
     */
    static func doPostRequest(param:[String : AnyObject],URL:String,completeBlock:((response:Response<AnyObject, NSError>)->Void)){
        
        HDLog.LogOut("PostURL", obj: URL)
        
        Alamofire.request(.POST, URL,parameters: param)
            .responseJSON { response in
                
                if response.result.error == nil {
                    
                    /**
                     *  请求成功
                     */
                    let text:String = NSString(data: response.data!, encoding: NSUTF8StringEncoding)! as String
                    HDLog.LogOut("Data", obj: text)
                    
                }else{
                    
                    /**
                    请求出错了
                    
                    - print: 错误信息
                    */
                    HDLog.LogOut("error", obj: (response.result.error?.description)!)
                }
        
                completeBlock(response: response)
        }
        
    }
    
}
