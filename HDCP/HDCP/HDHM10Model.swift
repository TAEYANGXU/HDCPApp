//
//  HDHM10Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/30.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM10Result: Mappable {

    var count:Int?
    var list:Array<HDHM10Comment>?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        count <- map["count"]
        list <- map["list"]
    }
    
}

class HDHM10Response: Mappable {
    
    var request_id:String?
    var result:HDHM10Result?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}

class HDHM10Comment: Mappable {
    
    var avatar:String!
    var content:String!
    var createTime:String!
    var userId:String!
    var userName:String!
    var height:CGFloat!
    
    init(){}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        avatar <- map["Avatar"]
        content <- map["Content"]
        createTime <- map["CreateTime"]
        userId <- map["UserId"]
        userName <- map["UserName"]
    }
    
}