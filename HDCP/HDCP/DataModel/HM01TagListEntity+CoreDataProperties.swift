//
//  HM01TagListEntity+CoreDataProperties.swift
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

extension HM01TagListEntity {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var result: HDHM01ResultEntity?

}
