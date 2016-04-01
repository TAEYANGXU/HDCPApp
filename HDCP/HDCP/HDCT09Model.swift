//
//  HDCT09Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/15.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDCT09Response:Mappable {
    
    var request_id:String?
    var result:HDCT09Result?
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}

class HDCT09Result: Mappable {
    
    var ct09GroupList:Array<HDCT09GroupModel>?
    var ct09HotList:Array<HDCT09HotModel>?
    var ct09ADList:Array<HDCT09ADModel>?
    var todayStar:Array<HDCT09TodayStarModel>?
    
    var groupTitle:String?
    var groupUrl:String?
    var hotTitle:String?
    var hotUrl:String?
    var todayStarTitle:String?
    var todayStarUrl:String?
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        ct09GroupList <- map["group"]
        ct09HotList <- map["hot"]
        ct09ADList <- map["ad"]
        todayStar <- map["todayStar"]
        
        groupTitle <- map["groupTitle"]
        groupUrl <- map["groupUrl"]
        hotTitle <- map["hotTitle"]
        hotUrl <- map["hotUrl"]
        todayStarTitle <- map["todayStarTitle"]
        todayStarUrl <- map["todayStarUrl"]
        
    }
    
}

class HDCT09TodayStarModel: Mappable {
    
    var userId:Int!
    var userName:String!
    var avatar:String!
    var url:String!
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        userId <- map["UserId"]
        url <- map["Url"]
        avatar <- map["Avatar"]
        userName <- map["UserName"]
        
    }
    
}

class HDCT09ADModel: Mappable {
    
    var img:String!
    var url:String!
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        img <- map["Img"]
        url <- map["Url"]
        
    }
    
}

class HDCT09GroupModel: Mappable {
    
    var cateId:Int!
    var desc:String!
    var img:String!
    var name:String!
    var url:String!
    var viewDesc:String!
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        cateId <- map["CateId"]
        desc <- map["Desc"]
        img <- map["Img"]
        name <- map["Name"]
        url <- map["Url"]
        viewDesc <- map["ViewDesc"]
        
    }
    
}

class HDCT09HotModel: Mappable {
    
    var avatar:String!
    var commentCount:Int!
    var digCount:Int!
    var img:String!
    var previewContent:String!
    var tagId:Int!
    var tagName:String!
    var title:String!
    var topicId:Int!
    var url:String!
    var userId:Int!
    var userName:String!
    var vip:Int!
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        avatar <- map["Avatar"]
        commentCount <- map["CommentCount"]
        digCount <- map["DigCount"]
        img <- map["Img"]
        previewContent <- map["PreviewContent"]
        tagId <- map["TagId"]
        tagName <- map["TagName"]
        title <- map["Title"]
        topicId <- map["TopicId"]
        url <- map["Url"]
        userId <- map["UserId"]
        userName <- map["UserName"]
        vip <- map["Vip"]
        
    }
    
}