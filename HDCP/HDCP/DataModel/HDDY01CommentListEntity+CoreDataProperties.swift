//
//  HDDY01CommentListEntity+CoreDataProperties.swift
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

extension HDDY01CommentListEntity {

    @NSManaged var cid: NSNumber?
    @NSManaged var userId: NSNumber?
    @NSManaged var userName: String?
    @NSManaged var content: String?
    @NSManaged var isAuthor: NSNumber?
    @NSManaged var isVip: NSNumber?
    @NSManaged var data: HDDY01DataEntity?

}
