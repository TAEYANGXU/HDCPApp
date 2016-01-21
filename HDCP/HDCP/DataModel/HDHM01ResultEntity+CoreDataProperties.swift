//
//  HDHM01ResultEntity+CoreDataProperties.swift
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

extension HDHM01ResultEntity {

    @NSManaged var collectList: NSSet?
    @NSManaged var recipeList: NSSet?
    @NSManaged var tagList: NSSet?
    @NSManaged var wikiList: NSSet?
    @NSManaged var response: HDHM01ResponseEntity?

}
