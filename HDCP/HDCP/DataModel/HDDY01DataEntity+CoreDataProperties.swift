//
//  HDDY01DataEntity+CoreDataProperties.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/4/7.
//  Copyright © 2016年 batonsoft. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension HDDY01DataEntity {

    @NSManaged var actionType: NSNumber?
    @NSManaged var address: String?
    @NSManaged var commentCount: NSNumber?
    @NSManaged var commentCnt: NSNumber?
    @NSManaged var commentUrl: String?
    @NSManaged var createTime: String?
    @NSManaged var diggCnt: NSNumber?
    @NSManaged var diggCount: NSNumber?
    @NSManaged var diggId: NSNumber?
    @NSManaged var diggType: NSNumber?
    @NSManaged var entityType: NSNumber?
    @NSManaged var feedId: NSNumber?
    @NSManaged var formatTime: String?
    @NSManaged var id: NSNumber?
    @NSManaged var intro: String?
    @NSManaged var isDigg: NSNumber?
    @NSManaged var url: String?
    @NSManaged var hasVideo: NSNumber?
    @NSManaged var title: String?
    @NSManaged var tagId: NSNumber?
    @NSManaged var tagName: String?
    @NSManaged var tagUrl: String?
    @NSManaged var img: String?
    @NSManaged var content: String?
    @NSManaged var list: HDDY01ListEntity?
    @NSManaged var commentList: NSSet?

}
