//
//  HDHM02Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/12.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDHM02RecipeModel :Mappable{
    
    var viewCount:Int?
    var userName:String?
    var userId:Int?
    var title:String?
    var recipeId:Int?
    var isVip:String?
    
    required init?(_ map: Map) {
        mapping(map)
        
    }
    
    func mapping(map: Map) {
        
        viewCount <- map["ViewCount"]
        userName <- map["UserName"]
        userId <- map["UserId"]
        title <- map["Title"]
        recipeId <- map["RecipeId"]
        isVip <- map["IsVip"]
    }
    
}

class HDHM02List: Mappable {
    
    var tagId:Int?
    var title:String?
    var isShow:Bool?
    var recipe:Array<HDHM02RecipeModel>?
    
    init(){
    
        self.isShow = false
        
    }
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        tagId <- map["TagId"]
        title <- map["Title"]
        recipe <- map["Recipe"]
        
    }
    
}

class HDHM02Result: Mappable {
    
    var recipeList:Array<HDHM02List>!
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        recipeList <- map["list"]
        
    }
    
}

class HDHM02Response: Mappable {
    
    var request_id:String?
    var result:HDHM02Result!
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}