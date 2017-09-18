 //
//  HDCG01Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper
 
class HDCG01Service {

    /**
     分类
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDCG02_URL(_ successBlock:@escaping (_ HDCG01Response:HDCG01Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
        
        
        HDRequestManager.doGetRequest(Constants.HDCG01_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDCG01Response>().map(JSONObject: response.result.value)
                
                successBlock(response!)
                
                self.addEntity(response!, finishBlcok: { () -> Void in
                    
                    /// 回调
                    successBlock(response!)
                    
                })
                
            }else{
                
                failBlock(response.result.error! as NSError)
            }
            
        }

        
    }

    
    /**
     *  将数据存到本地
     */
    func addEntity(_ cgResponse:HDCG01Response,finishBlcok:()->Void){
        
        if !isExistEntity() {
            
            let context = HDCoreDataManager.sharedInstance.managedObjectContext
            
            let result = NSEntityDescription.insertNewObject(forEntityName: "HDCG01ResultEntity", into: context) as? HDCG01ResultEntity
            
            for (i,_) in (cgResponse.result?.list?.enumerated())! {
                
                let model = cgResponse.result?.list![i]
                
                let listModel = NSEntityDescription.insertNewObject(forEntityName: "HDCG01ListEntity", into: context) as? HDCG01ListEntity
                
                listModel!.cate = model?.cate
                listModel?.imgUrl = model?.imgUrl
                listModel?.result = result
                
                for tagModel in (model?.tags)! {
                    
                    let tModel = NSEntityDescription.insertNewObject(forEntityName: "HDCG01TagEntity", into: context) as? HDCG01TagEntity
                    tModel?.id = tagModel.id as NSNumber?
                    tModel?.name = tagModel.name
                    tModel?.cate = model?.cate
                    
                }
                
            }
            
            
            let response = NSEntityDescription.insertNewObject(forEntityName: "HDCG01ResponseEntity", into: context) as? HDCG01ResponseEntity
            response?.request_id = cgResponse.request_id
            response?.result = result
            
            HDCoreDataManager.sharedInstance.saveContext()
            
            finishBlcok()
            
        }
        
    }
    
    /**
     *  本地缓存是否存在
     */
    func isExistEntity()->Bool {
    
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HDCG01ResponseEntity")
        
        request.relationshipKeyPathsForPrefetching = ["HDCG01ResultEntity","HDCG01ListEntity","HDCG01TagEntity"]
        
        var ret:Bool = false
        
        do{
            let list = try context.fetch(request)
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
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HDCG01ListEntity")
        
        //排序
        let sort = NSSortDescriptor(key: "cate", ascending: false)
        request.sortDescriptors = [sort]
        
        request.relationshipKeyPathsForPrefetching = ["HDCG01ResultEntity","HDCG01ListEntity","HDCG01TagEntity"]
        
        let tagList = NSMutableArray()
        
        do{
            
            let list = try context.fetch(request)
            if list.count>0 {
                
                for model in list {
                    
                    let tagModel = HDCG01ListModel()
                    tagModel.imgUrl = (model as AnyObject).imgUrl
                    tagModel.cate = (model as AnyObject).cate
                    tagList.add(tagModel)
                }
                

            }
        }catch{
            
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
            
        }
        
        return (NSArray(array:tagList) as? Array<HDCG01ListModel>)!
    }
    
    func getTagListByCate(_ cate:String) -> Array<HDCG01TagModel>{
    
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HDCG01TagEntity")
        
        //排序
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        let predicate = NSPredicate(format: "cate = %@", cate)
        request.predicate = predicate
        
        let tags = NSMutableArray()
        
        do{
            let list = try context.fetch(request)
            if list.count>0 {
                
                for model in list {
                    
                    let tagModel = HDCG01TagModel()
//                    tagModel.id = (model as AnyObject).id!!.longValue
                    tagModel.name = (model as AnyObject).name
                    tags.add(tagModel)
                    
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
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HDCG01ResponseEntity")
        
        do {
            
            let list =  try context.fetch(request) as Array
            
            if list.count>0 {
                
                for model in list {
                    
                    context.delete(model as! NSManagedObject)
                    
                }
                
                HDCoreDataManager.sharedInstance.saveContext()
                
            }
            
            
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
    }

    
}
