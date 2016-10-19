//
//  HDHM06Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/17.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM06ListModel: Mappable {
    
    var id:Int?
    var title:String?
    var cover:String?
    var userId:Int?
    var userName:String?
    var avatar:String?
    var recipeCount:Int?
    
    init(){}
    
    required init?(map: Map){
        mapping(map:map)
    }
    
    func mapping(map: Map) {
        
        id <- map["Id"]
        title <- map["Title"]
        cover <- map["Cover"]
        userId <- map["UserId"]
        userName <- map["UserName"]
        avatar <- map["Avatar"]
        recipeCount <- map["RecipeCount"]
        
    }
    
}


class HDHM06Result: Mappable {
    
    var count:Int?
    var list:[HDHM06ListModel]?
    
    init(){}
    
    required init?(map: Map){
        mapping(map:map)
    }
    func mapping(map: Map) {
        
        count <- map["count"]
        list <- map["list"]
        
    }
    
}

class HDHM06Response: Mappable {
    
    var request_id:String?
    var result:HDHM06Result?
    
    init(){}
    
    required init?(map: Map){
        mapping(map:map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}
