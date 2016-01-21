//
//  HDCG02Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class HDCG01TagModel: Mappable {
    
    var id:Int?
    var name:String?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        id <- map["Id"]
        name <- map["Name"]
        
    }

    
}

class HDCG01ListModel: Mappable {
    
    var cate:String?
    var imgUrl:String?
    var tags:Array<HDCG01TagModel>?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        cate <- map["Cate"]
        imgUrl <- map["ImgUrl"]
        tags <- map["Tags"]
        
    }
    
}


class HDCG01Result: Mappable {
    
    var count:Int?
    var list:[HDCG01ListModel]?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        count <- map["count"]
        list <- map["list"]
        
    }
    
}

class HDCG01Response: Mappable {
    
    var request_id:String?
    var result:HDCG01Result?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}