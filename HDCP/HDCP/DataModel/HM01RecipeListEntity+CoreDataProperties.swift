//
//  HM01RecipeListEntity+CoreDataProperties.swift
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

extension HM01RecipeListEntity {

    @NSManaged var cover: String?
    @NSManaged var rid: NSNumber?
    @NSManaged var title: String?
    @NSManaged var userName: String?
    @NSManaged var result: HDHM01ResultEntity?

}
