//
//  HDCT02Model.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/17.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class HDCT02Response:Mappable {
    
    var request_id:String?
    var result:HDCT02Result?
    
    required init?(map: Map){
        mapping(map: map)
    }
    func mapping(map: Map) {
        
        request_id <- map["request_id"]
        result <- map["result"]
        
    }
    
}

class HDCT02Result: Mappable {
    
    var allFollowCnt:Int?
    var area:Array<HDCT02AreaModel>?
    var avatar:String?
    var avatarBig:String?
    var birthday:String?
    
    var changeUrl:String?
    
    var consumerMobile:String?
    
    var couponCnt:Int?
    var couponUrl:String?
    
    var fansCount:Int?
    var favoriteCnt:Int?
    var favoriteList:Array<HDCT02FavoriteListModel>?
    
    var feedCnt:Int?
    var followCnt:Int?
    var friendCnt:Int?
    var gender:Int?
    var goodsCount:Int?
    
    var levelName:String?
    var mobile:String?
    
    var newCouponCnt:Int?
    var noticeCnt:Int?
    
    var orderUrl:String?
    var taskUrl:String?
    var userName:String?
    
    
    var userId:Int?
    var vip:Int?
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        area <- map["Area"]
        allFollowCnt <- map["AllFollowCnt"]
        avatar <- map["Avatar"]
        avatarBig <- map["AvatarBig"]
        birthday <- map["Birthday"]
        
        changeUrl <- map["ChangeUrl"]
        consumerMobile <- map["ConsumerMobile"]
        
        couponCnt <- map["CouponCnt"]
        couponUrl <- map["CouponUrl"]
        
        fansCount <- map["FansCount"]
        favoriteCnt <- map["FavoriteCnt"]
        favoriteList <- map["FavoriteList"]
        
        feedCnt <- map["FeedCnt"]
        followCnt <- map["FollowCnt"]
        friendCnt <- map["FriendCnt"]
        gender <- map["Gender"]
        goodsCount <- map["GoodsCount"]
        
        levelName <- map["LevelName"]
        mobile <- map["Mobile"]
        
        newCouponCnt <- map["NewCouponCnt"]
        noticeCnt <- map["NoticeCnt"]
        
        orderUrl <- map["OrderUrl"]
        taskUrl <- map["TaskUrl"]
        userName <- map["UserName"]
        userId <- map["UserId"]
        vip <- map["Vip"]
        
    }
    
}


class HDCT02AreaModel: Mappable {
    
    var cityId:Int?
    var cityName:String?
    var provinceId:Int?
    var provinceName:String?
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        cityId <- map["CityId"]
        cityName <- map["CityName"]
        provinceId <- map["ProvinceId"]
        provinceName <- map["ProvinceName"]
        
    }
    
}

class HDCT02FavoriteListModel: Mappable {
    
    var id:Int?
    var name:String?
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        id <- map["Id"]
        name <- map["Name"]
        
    }
    
}
