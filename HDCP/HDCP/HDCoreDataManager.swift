//
//  CoreDataManager.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/5.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import CoreData

public class HDCoreDataManager: NSObject {
    
    /**
     *  单利模式
     */
    
     public static let sharedInstance = HDCoreDataManager()
    
//    class var shareInstance: HDCoreDataManager {
//    
//        struct Singleton {
//            static var instance: HDCoreDataManager?
//            static var token: dispatch_once_t = 0
//        }
//        
//        dispatch_once(&Singleton.token) {
//            Singleton.instance = HDCoreDataManager()
//        }
//        
//        return Singleton.instance!
//    }
    
    /**
     *  应用程序Docment目录的NSURL类型
     */
    lazy var applicationDocumentsDirectory: NSURL = {
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    /**
     *  被管理的对象模型
     */
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        let modelURL = NSBundle.mainBundle().URLForResource("HDCP", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    /**
     *  持久化存储协调者
     */
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        
        
//        let optionsDictionary = NSDictionary(dictionary: [NSMigratePersistentStoresAutomaticallyOption:NSNumber(bool: true),NSInferMappingModelAutomaticallyOption:NSNumber(bool: true)])
        
        
        let optionsDictionary = NSDictionary(dictionary: [NSMigratePersistentStoresAutomaticallyOption:NSNumber(bool: true),NSInferMappingModelAutomaticallyOption:NSNumber(bool: true)])
        
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    /**
     *  被管理的对象上下文
     */
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    /**
    *  保存数据
    */
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}
