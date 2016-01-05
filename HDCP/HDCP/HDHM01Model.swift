//
//  HDHM01Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class CollectListModel:Mappable {
    
    var cid:String?
    var content:String?
    var cover:String?
    var title:String?
    var userName:String?
    
    init(){}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        cid <- map["Cid"]
        content <- map["Content"]
        cover <- map["Cover"]
        title <- map["Title"]
        userName <- map["UserName"]
        
    }
    
}

class RecipeListModel: Mappable {
    
    var cover:String?
    var rid:String?
    var title:String?
    var userName:String?
    
    init(){}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        rid <- map["Rid"]
        cover <- map["Cover"]
        title <- map["Title"]
        userName <- map["UserName"]
    }
}

class TagListModel: Mappable {
    
    var id:String?
    var name:String?
    
    init(){}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        id <- map["Id"]
        name <- map["Name"]
    }
}

class WikiListModel:Mappable {
    
    var url:String?
    var content:String?
    var cover:String?
    var title:String?
    var userName:String?
    
    init(){}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        url <- map["Url"]
        content <- map["Content"]
        cover <- map["Cover"]
        title <- map["Title"]
        userName <- map["UserName"]
        
    }
    
}

class HDHM01Result: Mappable {

    var collectList:Array<CollectListModel>?
    var recipeList:Array<RecipeListModel>?
    var tagList:Array<TagListModel>?
    var wikiList:Array<WikiListModel>?
    
    init(){}

    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        collectList <- map["collect_list"]
        recipeList <- map["recipe_list"]
        tagList <- map["tag_list"]
        wikiList <- map["wiki_list"]

    }

}

class HDHM01Response: Mappable {

    var request_id:String?
    var result:HDHM01Result?

    init(){}

    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {

        request_id <- map["request_id"]
        result <- map["result"]

    }

}


