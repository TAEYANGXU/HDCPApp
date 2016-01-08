//
//  HDGG01Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/8.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDGG01ListModel:Mappable {
    
    var image:String?
    var title:String?
    var type:String?
    var url:String?
    
    required init?(_ map: Map) {
        
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        image <- map["Image"]
        title <- map["Title"]
        type <- map["Type"]
        url <- map["Url"]
        
    }
    
}

class HDGG01Result: Mappable {
    
    var gg01List:Array<HDGG01ListModel>?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        gg01List <- map["list"]
        
    }
    
}

class HDGG01Response: Mappable {
    
    var request_id:String?
    var result:HDGG01Result?
    var array2D:NSArray?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}