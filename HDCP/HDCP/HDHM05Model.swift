//
//  HDHM05Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM05ListModel: Mappable {
    
    var rid:Int?
    var title:String?
    var cover:String?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        rid <- map["Rid"]
        title <- map["Title"]
        cover <- map["Cover"]
        
    }
    
}


class HDHM05Result: Mappable {
    
    var count:Int?
    var list:[HDHM05ListModel]?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        count <- map["count"]
        list <- map["list"]
        
    }
    
}

class HDHM05Response: Mappable {
    
    var request_id:String?
    var result:HDHM05Result?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}