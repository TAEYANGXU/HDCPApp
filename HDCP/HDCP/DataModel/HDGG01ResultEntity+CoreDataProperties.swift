//
//  HDGG01ResultEntity+CoreDataProperties.swift
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

extension HDGG01ResultEntity {

    @NSManaged var gg01List: NSSet?
    @NSManaged var response: HDGG01ResponseEntity?

}
