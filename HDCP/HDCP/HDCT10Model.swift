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

class HDCT10UserInfoModel: Mappable {
    
    var avatar:String?
    var gender:Int?
    var intro:String?
    var openUrl:String?
    var relation:Int?
    var userId:Int?
    var userName:String?
    var vip:Int?

    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        avatar <- map["Avatar"]
        gender <- map["Gender"]
        intro <- map["Intro"]
        openUrl <- map["OpenUrl"]
        relation <- map["Relation"]
        userId <- map["UserId"]
        userName <- map["UserName"]
        vip <- map["Vip"]
    }
    
}


class HDCT10DataModel: Mappable {
    
    var actionType:Int?
    var address:String?
    var commentCnt:Int?
    var commentCount:Int?
    var commentUrl:String?
    var createTime:String?
    var diggCnt:Int?
    var diggCount:Int?
    var diggId:Int?
    var diggType:Int?
    var entityType:Int?
    var feedId:Int?
    var formatTime:String?
    var id:Int?
    var images:Array<HDCT10ImagesModel>?
    var intro:String?
    var isDigg:Int?
    var topicTags:Array<HDCT10TopicTagsModel>?
    var url:String?
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
     
        actionType <- map["ActionType"]
        address <- map["Address"]
        commentCnt <- map["CommentCnt"]
        commentCount <- map["CommentCount"]
        commentUrl <- map["CommentUrl"]
        createTime <- map["CreateTime"]
        diggCnt <- map["DiggCnt"]
        diggCount <- map["DiggCount"]
        diggId <- map["DiggId"]
        diggType <- map["DiggType"]
        entityType <- map["EntityType"]
        feedId <- map["FeedId"]
        formatTime <- map["FormatTime"]
        id <- map["Id"]
        images <- map["Images"]
        intro <- map["Intro"]
        isDigg <- map["IsDigg"]
        topicTags <- map["TopicTags"]
        url <- map["Url"]
        
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