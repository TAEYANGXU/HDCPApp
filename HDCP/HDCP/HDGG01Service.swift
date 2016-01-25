//
//  HDGG01Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/8.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import CoreData

class HDGG01Service: HDRequestManager {

    
    /**
     逛逛主页数据
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDGG01_URL(successBlock:(hdResponse:HDGG01Response)->Void,failBlock:(error:NSError)->Void){

        super.doPostRequest(["limit":"20","offset":"0"], URL: Constants.HDGG01_URL) { (response) -> Void in

            if response.result.error == nil {
                
                let hdggResponse = Mapper<HDGG01Response>().map(response.result.value)
                
                let array2D = NSMutableArray()
                var array:NSMutableArray?
                
                for var i=0;i<hdggResponse?.result?.gg01List?.count;i++ {
                
                    if i%3 == 0 {
                        array = nil
                        array = NSMutableArray()
                        array2D.addObject(array!)
                        
                    }
                    
                    array?.addObject((hdggResponse?.result?.gg01List![i])!)
                    
                }
                
                array2D.removeLastObject()
                
                hdggResponse?.array2D = array2D
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    
                    //更新本地数据
                    self.deleteEntity()
                    self.addEntity(hdggResponse!)
                    
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        
                        successBlock(hdResponse: hdggResponse!)
                        
                    })
                    
                })
                
                
                
            }else{
                
                failBlock(error: response.result.error!)
            }

        }
        
    }
    
    
    /**
     *  将数据存到本地
     */
    func addEntity(hdggResponse:HDGG01Response){
        
        let context = HDCoreDataManager.shareInstance.managedObjectContext
    
        let result = NSEntityDescription.insertNewObjectForEntityForName("HDGG01ResultEntity", inManagedObjectContext: context) as? HDGG01ResultEntity
        
        for var i=0;i<hdggResponse.result?.gg01List?.count;i++ {
        
            let model = hdggResponse.result?.gg01List![i]
            
            let listModel = NSEntityDescription.insertNewObjectForEntityForName("HDGG01ListEntity", inManagedObjectContext: context) as? HDGG01ListEntity
            listModel?.image = model?.image
            listModel?.url = model?.url
            listModel?.type = model?.type
            listModel?.title = model?.title
            
            listModel?.result = result
            
        }
        
        let response = NSEntityDescription.insertNewObjectForEntityForName("HDGG01ResponseEntity", inManagedObjectContext: context) as? HDGG01ResponseEntity
        response?.request_id = hdggResponse.request_id
        response?.result = result
        
        HDCoreDataManager.shareInstance.saveContext()
        
        
    }
    /**
     *  查询本地数据
     */
    func getAllResponseEntity() -> HDGG01Response{
    
        let context = HDCoreDataManager.shareInstance.managedObjectContext
        
        let request = NSFetchRequest(entityName: "HDGG01ResponseEntity")
        
        request.relationshipKeyPathsForPrefetching = ["HDGG01ResultEntity","HDGG01ListEntity"]
        
        let hdGG01Response:HDGG01Response! = HDGG01Response()
        
        do{
            let list = try context.executeFetchRequest(request)
            let gg01List = NSMutableArray()
            
            if list.count>0 {
            
                let response = list[0] as! HDGG01ResponseEntity
                
                for model in (response.result?.gg01List)! {
                
                    let ggModel = HDGG01ListModel()
                    
                    ggModel.image = model.image
                    ggModel.title = model.title
                    ggModel.type = model.type!!.longValue
                    ggModel.url = model.url
                    
                    gg01List.addObject(ggModel)
                }
                
                let result = HDGG01Result()
                result.gg01List = NSArray(array: gg01List) as? Array<HDGG01ListModel>
                hdGG01Response.result = result
                
                
                //数据合成
                let array2D = NSMutableArray()
                var array:NSMutableArray?
                
                for var i=0;i<gg01List.count;i++ {
                    
                    if i%3 == 0 {
                        array = nil
                        array = NSMutableArray()
                        array2D.addObject(array!)
                        
                    }
                    
                    array?.addObject(gg01List[i])
                    
                }
                
                array2D.removeLastObject()
                
                hdGG01Response?.array2D = array2D

                
            }
            
        }catch{
        
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
            
        }
        
        return hdGG01Response
        
    }
    
    /**
     *  本地缓存是否存在
     */
    func isExistEntity()->Bool {
        
        
        let context = HDCoreDataManager.shareInstance.managedObjectContext
        
        let request = NSFetchRequest(entityName: "HDGG01ResponseEntity")
        
        request.relationshipKeyPathsForPrefetching = ["HDGG01ResultEntity","HDGG01ListEntity"]
        
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
     *  删除本地数据 因为设置了Cascade级联关系  当我们删除HDGG01ResponseEntity会把所有的数据删除
     */
    func deleteEntity(){
        
        let context = HDCoreDataManager.shareInstance.managedObjectContext
        
        let request = NSFetchRequest(entityName: "HDGG01ResponseEntity")
        
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
