//
//  HDHM04Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM04Stuff: Mappable {
    
    var id:Int?
    var name:String?
    var type:Int?
    var weight:String?
    
    init(id:Int,name:String,type:Int,weight:String){
        
        self.id = id;
        self.name = name;
        self.type = type;
        self.weight = weight;
        
    }
    
    
    
    required init?(map: Map){
        mapping(map: map)
    }
    func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        type <- map["type"]
        weight <- map["weight"]
        
    }
    
}

class HDHM04ListModel: Mappable {
    
    var avatar:String?
    var commentCount:Int?
    var cover:String?
    var favoriteCount:Int?
    var intro:String?
    var recipeId:Int?
    
    var stuff:Array<HDHM04Stuff>?
    
    var title:String?
    var userId:String?
    var userName:String?
    var viewCount:Int?
    
    init(){}
    
    required init?(map: Map){
        mapping(map:map)
    }
    func mapping(map: Map) {
        
        avatar <- map["Avatar"]
        commentCount <- map["CommentCount"]
        cover <- map["Cover"]
        favoriteCount <- map["FavoriteCount"]
        intro <- map["Intro"]
        recipeId <- map["RecipeId"]
        
        stuff <- map["Stuff"]
        
        title <- map["Title"]
        userId <- map["UserId"]
        userName <- map["UserName"]
        viewCount <- map["ViewCount"]
        
    }
    
}


class HDHM04Result: Mappable {
    
    var count:Int?
    var list:[HDHM04ListModel]?
    
    init(){}
    
    required init?(map: Map){
        mapping(map:map)
    }
    func mapping(map: Map) {
        
        count <- map["count"]
        list <- map["list"]
        
    }
    
}

class HDHM04Response: Mappable {
    
    var request_id:String?
    var result:HDHM04Result?
    
    init(){}
    
    required init?(map: Map){
        mapping(map:map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}
