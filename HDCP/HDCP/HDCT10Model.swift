//
//  HDCT10Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/15.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class HDCT10Response:Mappable {
    
    var request_id:String?
    var result:HDCT10Result?
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}

class HDCT10Result: Mappable {
    
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        
        
    }
    
}


class HDCT10DataModel: Mappable {
    
    var ActionType:Int?
    var Address:String?
    var CommentCnt:Int?
    var CommentCount:Int?
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
    }
    
}

class HDCT10ImagesModel: Mappable {
    
    var intro:Int?
    var smallUrl:String?
    var url:String?
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        intro <- map["Intro"]
        smallUrl <- map["SmallUrl"]
        url <- map["Url"]
    }
    
}



class HDCT10TopicTagsModel: Mappable {
    
    var id:Int?
    var name:String?
    var tagUrl:String?
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        id <- map["Id"]
        name <- map["Name"]
        tagUrl <- map["TagUrl"]
    }
    
}