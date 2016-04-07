//
//  HDDY01ResultEntity+CoreDataProperties.swift
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

extension HDDY01ResultEntity {

    @NSManaged var response: HDDY01ResponseEntity?
    @NSManaged var list: NSSet?

}
