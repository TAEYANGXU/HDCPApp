//
//  HDRequestManager.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/5.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import Alamofire

open class HDRequestManager: NSObject {

    /**
     服务器数据请求:GET方式
     *
     * parameter url:    URL地址
     * parameter block:  返回结果集
     */
    static func doGetRequest(_ URL: String, completeBlock: @escaping (_ response: DataResponse<Any>) -> Void) {

//        HDLog.LogOut("PostURL" as AnyObject, obj: URL as AnyObject)
        print("PostURL\(URL as AnyObject)")
        Alamofire.request(URL).responseJSON { response in
            if response.result.error == nil {

                /**
                 *  请求成功
                 */
                let text: String = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)! as String
//                HDLog.LogOut("Data" as AnyObject, obj: text as AnyObject)
                print("Data\(text as AnyObject)")

            } else {

                /**
                 请求出错了
                 
                 - print: 错误信息
                 */
//                HDLog.LogOut("error" as AnyObject, obj: (response.result.error)! as AnyObject)
                print("error\((response.result.error)! as AnyObject)")

            }

            completeBlock(response)
        }

    }


    /**
     服务器数据请求:POST方式
     *
     * parameter url:    URL地址
     * parameter block:  返回结果集
     */
    static func doPostRequest(_ param: [String: AnyObject], URL: String, completeBlock: @escaping (_ response: DataResponse<Any>) -> Void) {

        //HDLog.LogOut("PostURL" as AnyObject, obj: URL as AnyObject)
        print("PostURL\(URL as AnyObject)")
        
        Alamofire.request(URL, method: .post, parameters: param, encoding: URLEncoding.default).responseJSON { response in

            if response.result.error == nil {

                /**
                 *  请求成功
                 */
                let text: String = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)! as String
//                HDLog.LogOut("Data" as AnyObject, obj: text as AnyObject)
                print("Data\(text as AnyObject)")
            } else {

                /**
                 请求出错了
                 
                 - print: 错误信息
                 */
//                HDLog.LogOut("error" as AnyObject, obj: (response.result.error)! as AnyObject)
                print("error\((response.result.error)! as AnyObject)")
            }

            completeBlock(response)
        }

    }

}
