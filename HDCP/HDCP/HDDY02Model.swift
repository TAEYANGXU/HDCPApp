//
//  HDDY02Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/4/1.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDDY02Response:Mappable {
    
    var request_id:String?
    var result:HDDY02Result?
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}

class HDDY02Result: Mappable {
    
    var info:HDDY02InfoModel?
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        info <- map["info"]
        
    }
    
}

class HDDY02InfoModel: Mappable {
    
    var UserId:Int?
    var RecipeId:Int?
    var Rate:Int?
    var Status:Int?
    
    var Cover:String?
    var Title:String?
    var Intro:String?
    var CreateTime:String?
    var CookTime:String?
    var ReadyTime:String?
    var Tips:String?
    
    var PhotoCount:Int?
    var ReviewTime:String?
    var Type:Int?
    var UserCount:String?
    
    
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        
    }
    
}