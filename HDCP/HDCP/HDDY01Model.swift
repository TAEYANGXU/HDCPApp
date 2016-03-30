//
//  HDDY01Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/30.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDDY01Response:Mappable {
    
    var request_id:String?
    var result:HDDY01Result?
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}

class HDDY01Result: Mappable {
    
    var list:Array<HDDY01ListModel>?
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        list <- map["list"]
        
    }
    
}

class HDDY01ListModel: Mappable {
    
    var data:HDDY01DataModel?
    var userInfo:HDDY01UserInfoModel?
    
    var rowHeight:CGFloat?
    var contentHeight:CGFloat?
    var fcommentRow:Int?
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        data <- map["data"]
        userInfo <- map["userInfo"]
        
    }
    
}

class HDDY01UserInfoModel: Mappable {
    
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


class HDDY01DataModel: Mappable {
    
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
    var images:Array<HDDY01ImagesModel>?
    var intro:String?
    var isDigg:Int?
    var topicTags:Array<HDDY01TopicTagsModel>?
    var url:String?
    var hasVideo:Int?
    var title:String?
    var tagId:Int?
    var tagName:String?
    var tagUrl:String?
    var img:String?
    var content:String?
    var commentList:Array<HDDY01CommentListModel>?
    
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
        hasVideo <- map["HasVideo"]
        title <- map["Title"]
        tagId <- map["TagId"]
        tagName <- map["TagName"]
        tagUrl <- map["TagUrl"]
        img <- map["Img"]
        content <- map["Content"]
        commentList <- map["CommentList"]
        
    }
    
}

class HDDY01CommentListModel: Mappable {
    
    var cid:Int?
    var userId:Int?
    var userName:String?
    var content:String?
    var isAuthor:Int?
    var isVip:Int?
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        cid <- map["Cid"]
        userId <- map["UserId"]
        userName <- map["UserName"]
        content <- map["Content"]
        isAuthor <- map["IsAuthor"]
        isVip <- map["IsVip"]
    }
    
}

class HDDY01ImagesModel: Mappable {
    
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



class HDDY01TopicTagsModel: Mappable {
    
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