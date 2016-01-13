//
//  HDHM03Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/13.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation


class HDHM03List: Mappable {
    
    var content:String?
    var title:String?
    var image:String?
    var url:String?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        content <- map["Content"]
        title <- map["Title"]
        image <- map["Image"]
        url <- map["Url"]
        
    }
    
}

class HDHM03Result: Mappable {
    
    var list:Array<HDHM03List>!
    var count:String?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        list <- map["list"]
        count <- map["count"]
        
    }
    
}

class HDHM03Response: Mappable {
    
    var request_id:String?
    var result:HDHM03Result!
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}