//
//  HDGG01Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/8.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

class HDGG01Service {

    
    /**
     逛逛主页数据
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDGG01_URL(_ successBlock:@escaping (_ hdResponse:HDGG01Response)->Void,failBlock:@escaping (_ error:NSError)->Void){

        HDRequestManager.doPostRequest(["limit":"20" as AnyObject,"offset":"0" as AnyObject], URL: Constants.HDGG01_URL) { (response) -> Void in

            if response.result.error == nil {
                
                /// JSON 转换成对象
                let hdggResponse = Mapper<HDGG01Response>().map(JSONObject: response.result.value)
                
                let array2D = NSMutableArray()
                var array:NSMutableArray?
                
                for (i,_) in (hdggResponse?.result?.gg01List?.enumerated())! {
                
                    if i%3 == 0 {
                        array = nil
                        array = NSMutableArray()
                        array2D.add(array!)
                        
                    }
                    
                    array?.add((hdggResponse?.result?.gg01List![i])!)
                    
                }
                
                array2D.removeLastObject()
                
                hdggResponse?.array2D = array2D
                DispatchQueue.global().async {
                    
                    //更新本地数据
                    //                    self.deleteEntity()
                    //                    self.addEntity(response!)
                    DispatchQueue.main.async {
                        // 主线程中
                        successBlock(hdggResponse!)
                    }
                }
                
            }else{
                
                failBlock(response.result.error! as NSError)
            }

        }
        
    }
    
    
    /**
     *  将数据存到本地
     */
    func addEntity(_ hdggResponse:HDGG01Response){
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
    
        let result = NSEntityDescription.insertNewObject(forEntityName: "HDGG01ResultEntity", into: context) as? HDGG01ResultEntity
        
        for (i,_) in (hdggResponse.result?.gg01List?.enumerated())! {
        
            let model = hdggResponse.result?.gg01List![i]
            
            let listModel = NSEntityDescription.insertNewObject(forEntityName: "HDGG01ListEntity", into: context) as? HDGG01ListEntity
            listModel?.image = model?.image
            listModel?.url = model?.url
            listModel?.type = model?.type as NSNumber?
            listModel?.title = model?.title
            
            listModel?.result = result
            
        }
        
        let response = NSEntityDescription.insertNewObject(forEntityName: "HDGG01ResponseEntity", into: context) as? HDGG01ResponseEntity
        response?.request_id = hdggResponse.request_id
        response?.result = result
        
        HDCoreDataManager.sharedInstance.saveContext()
        
        
    }
    /**
     *  查询本地数据
     */
    func getAllResponseEntity() -> HDGG01Response{
    
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HDGG01ResponseEntity")
        
        request.relationshipKeyPathsForPrefetching = ["HDGG01ResultEntity","HDGG01ListEntity"]
        
        let hdGG01Response:HDGG01Response! = HDGG01Response()
        
        do{
            let list = try context.fetch(request)
            let gg01List = NSMutableArray()
            
            if list.count>0 {
            
                let response = list[0] as! HDGG01ResponseEntity
                
                for model in (response.result?.gg01List)! {
                
                    let ggModel = HDGG01ListModel()
                    
                    ggModel.image = (model as AnyObject).image
                    ggModel.title = (model as AnyObject).title
//                    ggModel.type = model.type!!.longValue
                    ggModel.url = (model as AnyObject).url
                    
                    gg01List.add(ggModel)
                }
                
                let result = HDGG01Result()
                result.gg01List = NSArray(array: gg01List) as? Array<HDGG01ListModel>
                hdGG01Response.result = result
                
                
                //数据合成
                let array2D = NSMutableArray()
                var array:NSMutableArray?
                
                for i in 0 ..< gg01List.count {
                    
                    if i%3 == 0 {
                        array = nil
                        array = NSMutableArray()
                        array2D.add(array!)
                        
                    }
                    
                    array?.add(gg01List[i])
                    
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
        
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HDGG01ResponseEntity")
        
        request.relationshipKeyPathsForPrefetching = ["HDGG01ResultEntity","HDGG01ListEntity"]
        
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
     *  删除本地数据 因为设置了Cascade级联关系  当我们删除HDGG01ResponseEntity会把所有的数据删除
     */
    func deleteEntity(){
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HDGG01ResponseEntity")
        
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
