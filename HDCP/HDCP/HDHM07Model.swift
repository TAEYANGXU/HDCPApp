//
//  HDHM07Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/17.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM07ListModel: Mappable {
    
    var title:String?
    var url:String?
    var image:String?
    var content:String?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        url <- map["Url"]
        title <- map["Title"]
        image <- map["Image"]
        content <- map["Content"]
        
    }
    
}


class HDHM07Result: Mappable {
    
    var count:Int?
    var list:[HDHM07ListModel]?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        count <- map["count"]
        list <- map["list"]
        
    }
    
}

class HDHM07Response: Mappable {
    
    var request_id:String?
    var result:HDHM07Result?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}