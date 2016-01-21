//
//  HDCG01ResponseEntity+CoreDataProperties.swift
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

extension HDCG01ResponseEntity {

    @NSManaged var request_id: String?
    @NSManaged var result: HDCG01ResultEntity?

}
