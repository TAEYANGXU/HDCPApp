//
//  HDCG02Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class HDCG02TagModel: Mappable {
    
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

class HDCG02ListModel: Mappable {
    
    var cate:String?
    var imgUrl:String?
    var tags:Array<HDCG02TagModel>?
    
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


class HDCG02Result: Mappable {
    
    var count:Int?
    var list:[HDCG02ListModel]?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        count <- map["count"]
        list <- map["list"]
        
    }
    
}

class HDCG02Response: Mappable {
    
    var request_id:String?
    var result:HDCG02Result?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}