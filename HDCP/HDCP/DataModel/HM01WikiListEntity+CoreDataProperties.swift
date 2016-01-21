//
//  HM01WikiListEntity+CoreDataProperties.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/21.
//  Copyright © 2016年 batonsoft. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension HM01WikiListEntity {

    @NSManaged var url: String?
    @NSManaged var content: String?
    @NSManaged var cover: String?
    @NSManaged var title: String?
    @NSManaged var userName: String?
    @NSManaged var result: HDHM01ResultEntity?

}
