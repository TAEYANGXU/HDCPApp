//
//  HDHM08Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/18.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM08AdDataModel: Mappable {
    
    var image:String?
    var title:String?
    var url:String?
    
    init(){}
    
    required init?(map: Map){
        mapping(map: map)
    }
    func mapping(map: Map) {
        
        image <- map["Image"]
        title <- map["Title"]
        url <- map["Url"]
        
    }
}

class HDHM08StuffModel: Mappable {
    
    var cate:String?
    var cateid:Int?
    var id:Int?
    var name:String?
    var type:Int?
    var weight:String?
    
    init(){}
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        cate <- map["cate"]
        cateid <- map["cateid"]
        id <- map["id"]
        name <- map["name"]
        type <- map["type"]
        weight <- map["weight"]
        
    }
}

class HDHM08StepModel: Mappable {
    
    var intro:String?
    var stepPhoto:String?
    
    init(){}
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        intro <- map["Intro"]
        stepPhoto <- map["StepPhoto"]
    }

}

class HDHM08TagModel: Mappable {
    
    var id:Int?
    var name:String?
    
    init(){}
    
    required init?(map: Map) {
        mapping(map:map)
    }
    
    func mapping(map: Map) {
        
        id <- map["Id"]
        name <- map["Name"]
    }
}

class HDHM08InfoModel: Mappable {
    
    var avatar:String?
    var commentCount:Int?
    var cookTime:String?
    var cover:String?
    var favoriteCount:String?
    var intro:String?
    var isFavorited:Bool?
    
    var mainStuff:Array<HDHM08StuffModel>?
    var otherStuff:Array<HDHM08StuffModel>?
    var photoCount:Int?
    var photoList:Array<String>?
    var readyTime:String?
    var recipeId:Int?
    var reviewTime:String?
    var steps:Array<HDHM08StepModel>?
    var stuff:Array<HDHM08StuffModel>?
    var tags:Array<HDHM08TagModel>?
    var tips:String?
    var title:String?
    var type:Int?
    var userCount:String?
    var userId:Int?
    var userName:String?
    var viewCount:Int?
    
    init(){}
    
    required init?(map: Map) {
        mapping(map:map)
    }
    
    func mapping(map: Map) {
        
        avatar <- map["Avatar"]
        commentCount <- map["CommentCount"]
        cookTime <- map["CookTime"]
        cover <- map["Cover"]
        favoriteCount <- map["FavoriteCount"]
        intro <- map["Intro"]
        isFavorited <- map["IsFavorited:Bool"]
        
        mainStuff <- map["MainStuff"]
        otherStuff <- map["OtherStuff"]
        photoCount <- map["PhotoCount"]
        photoList <- map["PhotoList"]
        readyTime <- map["ReadyTime"]
        recipeId <- map["RecipeId"]
        
        reviewTime <- map["ReviewTime"]
        steps <- map["Steps"]
        stuff <- map["Stuff"]
        tags <- map["Tags"]
        
        tips <- map["Tips"]
        title <- map["Title"]
        type <- map["Type"]
        userCount <- map["UserCount"]
        userId <- map["UserId"]
        userName <- map["UserName"]
        viewCount <- map["ViewCount"]
    }

}

/// 评论
class HDHM08Comment: Mappable {
    
    var avatar:String!
    var content:String!
    var createTime:String!
    var userId:String!
    var userName:String!
    var height:CGFloat!
    
    init(){}
    
    required init?(map: Map) {
        mapping(map:map)
    }
    
    func mapping(map: Map) {
        
        avatar <- map["Avatar"]
        content <- map["Content"]
        createTime <- map["CreateTime"]
        userId <- map["UserId"]
        userName <- map["UserName"]
    }

}


class HDHM08Result: Mappable {
    
    var adData:HDHM08AdDataModel?
    var adFlag:Bool?
    var info:HDHM08InfoModel?
    var comment:Array<HDHM08Comment>?
    
    init(){}
    
    required init?(map: Map){
        mapping(map:map)
    }
    func mapping(map: Map) {
        
        adData <- map["ad_data"]
        adFlag <- map["ad_flag"]
        info <- map["info"]
        comment <- map["comment"]
    }
    
}

class HDHM08Response: Mappable {
    
    var request_id:String?
    var result:HDHM08Result?
    
    init(){}
    
    required init?(map: Map){
        mapping(map:map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}
