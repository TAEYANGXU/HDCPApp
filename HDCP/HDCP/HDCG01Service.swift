 //
//  HDCG01Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import CoreData
 
class HDCG01Service: HDRequestManager {

    /**
     分类
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDCG02_URL(successBlock:(HDCG01Response:HDCG01Response)->Void,failBlock:(error:NSError)->Void){
        
        
        super.doGetRequest(Constants.HDCG01_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                let response = Mapper<HDCG01Response>().map(response.result.value)
                
                
                self.addEntity(response!, finishBlcok: { () -> Void in
                    
                    successBlock(HDCG01Response: response!)
                    
                })
                
            }else{
                
                failBlock(error: response.result.error!)
            }
            
        }

        
    }

    
    /**
     *  将数据存到本地
     */
    func addEntity(cgResponse:HDCG01Response,finishBlcok:()->Void){
        
        if !isExistEntity() {
            
            let context = HDCoreDataManager.shareInstance.managedObjectContext
            
            let result = NSEntityDescription.insertNewObjectForEntityForName("HDCG01ResultEntity", inManagedObjectContext: context) as? HDCG01ResultEntity
            
            for var i=0;i<cgResponse.result?.list!.count;i++ {
                
                let model = cgResponse.result?.list![i]
                
                let listModel = NSEntityDescription.insertNewObjectForEntityForName("HDCG01ListEntity", inManagedObjectContext: context) as? HDCG01ListEntity
                
                listModel!.cate = model?.cate
                listModel?.imgUrl = model?.imgUrl
                listModel?.result = result
                
                for tagModel in (model?.tags)! {
                    
                    let tModel = NSEntityDescription.insertNewObjectForEntityForName("HDCG01TagEntity", inManagedObjectContext: context) as? HDCG01TagEntity
                    tModel?.id = tagModel.id
                    tModel?.name = tagModel.name
                    tModel?.cate = model?.cate
                    
                }
                
            }
            
            let response = NSEntityDescription.insertNewObjectForEntityForName("HDCG01ResponseEntity", inManagedObjectContext: context) as? HDCG01ResponseEntity
            response?.request_id = cgResponse.request_id
            response?.result = result
            
            HDCoreDataManager.shareInstance.saveContext()
            
            finishBlcok()
            
        }
        
    }
    
    /**
     *  本地缓存是否存在
     */
    func isExistEntity()->Bool {
    
        
        let context = HDCoreDataManager.shareInstance.managedObjectContext
        
        let request = NSFetchRequest(entityName: "HDCG01ResponseEntity")
        
        request.relationshipKeyPathsForPrefetching = ["HDCG01ResultEntity","HDCG01ListEntity","HDCG01TagEntity"]
        
        var ret:Bool = false
        
        do{
            let list = try context.executeFetchRequest(request)
            if list.count>0 {
                ret = true
            }
        }catch{
            
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
            
        }
        
        return ret
    }
    
    /**
     *  查询本地数据
     */
    func getAllTagListEntity()->Array<HDCG01ListModel>{
        
        let context = HDCoreDataManager.shareInstance.managedObjectContext
        
        let request = NSFetchRequest(entityName: "HDCG01ListEntity")
        
        //排序
        let sort = NSSortDescriptor(key: "cate", ascending: false)
        request.sortDescriptors = [sort]
        
        request.relationshipKeyPathsForPrefetching = ["HDCG01ResultEntity","HDCG01ListEntity","HDCG01TagEntity"]
        
        let tagList = NSMutableArray()
        
        do{
            
            let list = try context.executeFetchRequest(request)
            if list.count>0 {
                
                for model in list {
                    
                    let tagModel = HDCG01ListModel()
                    tagModel.imgUrl = model.imgUrl
                    tagModel.cate = model.cate
                    tagList.addObject(tagModel)
                }
                

            }
        }catch{
            
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
            
        }
        
        return (NSArray(array:tagList) as? Array<HDCG01ListModel>)!
    }
    
    func getTagListByCate(cate:String) -> Array<HDCG01TagModel>{
    
        let context = HDCoreDataManager.shareInstance.managedObjectContext
        let request = NSFetchRequest(entityName: "HDCG01TagEntity")
        
        //排序
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        let predicate = NSPredicate(format: "cate = %@", cate)
        request.predicate = predicate
        
        let tags = NSMutableArray()
        
        do{
            let list = try context.executeFetchRequest(request)
            if list.count>0 {
                
                for model in list {
                    
                    let tagModel = HDCG01TagModel()
                    tagModel.id = model.id!!.longValue
                    tagModel.name = model.name
                    tags.addObject(tagModel)
                    
                }
                
            }
        }catch{
            
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
            
        }

        return (NSArray(array:tags) as? Array<HDCG01TagModel>)!
        
    }
    
    /**
     *  删除本地数据 因为设置了Cascade级联关系  当我们删除HDGG01ResponseEntity会把所有的数据删除
     */
    func deleteEntity(){
        
        let context = HDCoreDataManager.shareInstance.managedObjectContext
        
        let request = NSFetchRequest(entityName: "HDCG01ResponseEntity")
        
        do {
            
            let list =  try context.executeFetchRequest(request) as Array
            
            if list.count>0 {
                
                for model in list {
                    
                    context.deleteObject(model as! NSManagedObject)
                    
                }
                
                HDCoreDataManager.shareInstance.saveContext()
                
            }
            
            
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
    }

    
}
