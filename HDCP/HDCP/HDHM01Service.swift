//
//  HDHM01Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/5.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import CoreData

class HDHM01Service: HDRequestManager {

    /**
     *  菜谱主页数据
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDHM01_URL(successBlock:((hdResponse:HDHM01Response)->Void),failBlock:((error:NSError)->Void)){
    
        
        super.doGetRequest(Constants.HDHM01_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                let hdHM01Response = Mapper<HDHM01Response>().map(response.result.value)
               
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    
                    //更新本地数据
                    self.deleteEntity()
                    self.addEntity(hdHM01Response!)
                    
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        
                        successBlock(hdResponse:hdHM01Response!)
                        
                    })
                    
                })
                
                
                
                
            }else{
                
                failBlock(error:response.result.error!)
            }

        }
        
    }
    
    /**
     *  将数据存到本地
     */
    func addEntity(hdHM01Response:HDHM01Response){
    
        let context = HDCoreDataManager.shareInstance.managedObjectContext
        
        
        let result = NSEntityDescription.insertNewObjectForEntityForName("HDHM01ResultEntity", inManagedObjectContext: context) as? HDHM01ResultEntity
        
        /// 菜谱专辑
        
        for var i=0;i<hdHM01Response.result?.collectList?.count;i++ {
            
            let model = hdHM01Response.result?.collectList![i]
            
            let collectModel = NSEntityDescription.insertNewObjectForEntityForName("HM01CollectListEntity", inManagedObjectContext: context) as? HM01CollectListEntity
            
            collectModel!.cid = model!.cid
            collectModel!.content = model!.content
            collectModel!.cover = model!.cover
            collectModel!.title = model!.title
            collectModel!.userName = model!.userName
            /**
            *   设置关联
            */
            collectModel?.result = result
        }
        
        /// 滚动栏
        for var i=0;i<hdHM01Response.result?.recipeList?.count;i++ {
            
            let model = hdHM01Response.result?.recipeList?[i]
            
            let recipeModel = NSEntityDescription.insertNewObjectForEntityForName("HM01RecipeListEntity", inManagedObjectContext: context) as? HM01RecipeListEntity
            recipeModel!.rid = model!.rid
            recipeModel!.cover = model!.cover
            recipeModel!.title = model!.title
            recipeModel!.userName = model!.userName
            /**
            *   设置关联
            */
            recipeModel?.result = result
        }
        
        /// 厨房宝典
        for var i=0;i<hdHM01Response.result?.wikiList?.count;i++ {
            
            let model = hdHM01Response.result?.wikiList?[i]
            
            let wikiModel = NSEntityDescription.insertNewObjectForEntityForName("HM01WikiListEntity", inManagedObjectContext: context) as? HM01WikiListEntity

            wikiModel!.cover = model!.cover
            wikiModel!.title = model!.title
            wikiModel!.userName = model!.userName
            wikiModel?.url = model!.url
            wikiModel?.content = model!.content
            /**
            *   设置关联
            */
            wikiModel?.result = result
        }
        
        //分类
        for var i=0;i<hdHM01Response.result?.tagList?.count;i++ {
            
            let model = hdHM01Response.result?.tagList?[i]
            
            let tagModel = NSEntityDescription.insertNewObjectForEntityForName("HM01TagListEntity", inManagedObjectContext: context) as? HM01TagListEntity
            
            tagModel!.id = model!.id
            tagModel!.name = model!.name
            /**
            *   设置关联
            */
            tagModel?.result = result
        }
        
        
        let response = NSEntityDescription.insertNewObjectForEntityForName("HDHM01ResponseEntity", inManagedObjectContext: context) as? HDHM01ResponseEntity
        response?.request_id = hdHM01Response.request_id
        response?.result = result
        
        /**
        *  保存
        */
        HDCoreDataManager.shareInstance.saveContext()
    }
    
    /**
     *  删除本地数据 因为设置了Cascade级联关系  当我们删除HDHM01ResponseEntity会把所有的数据删除
     */
    func deleteEntity(){
    
        let context = HDCoreDataManager.shareInstance.managedObjectContext
        
        let request = NSFetchRequest(entityName: "HDHM01ResponseEntity")
        
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
    
    /**
    *  查询本地数据
    */
    func getAllResponseEntity() -> HDHM01Response{
    
        
        let context = HDCoreDataManager.shareInstance.managedObjectContext
        let request = NSFetchRequest(entityName: "HDHM01ResponseEntity")
        
        //一句SQL查出所有数据
        request.relationshipKeyPathsForPrefetching = ["HDHM01ResultEntity","HM01TagListEntity","HM01WikiListEntity","HM01RecipeListEntity","HM01CollectListEntity"]
        
        let hmResponse = HDHM01Response()
        
        do {
            
            let list =  try context.executeFetchRequest(request) as Array
            
            if list.count>0 {
                
                // 组装Response
                let response = list[0] as! HDHM01ResponseEntity
                hmResponse.request_id = response.request_id
                
                let collectList = NSMutableArray()
                
                for model in response.result!.collectList! {
                    
                    let cModel = CollectListModel()
                    cModel.title = model.title
                    cModel.userName = model.userName
                    cModel.content = model.content
                    cModel.cover = model.cover
                    cModel.cid = model.cid!!.longValue
                    collectList.addObject(cModel)
                    
                }
                
                let recipeList = NSMutableArray()
                for model in response.result!.recipeList! {
                    
                    let rModel = RecipeListModel()
                    rModel.title = model.title
                    rModel.userName = model.userName
                    rModel.cover = model.cover
                    rModel.rid = model.rid!!.longValue
                    recipeList.addObject(rModel)
                    
                }
                
                let wikiList = NSMutableArray()
                for model in response.result!.wikiList! {
                    
                    let wModel = WikiListModel()
                    wModel.title = model.title
                    wModel.userName = model.userName
                    wModel.cover = model.cover
                    wModel.content = model.content
                    wModel.url = model.url
                    wikiList.addObject(wModel)
                    
                }
                
                let tagList = NSMutableArray()
                for model in response.result!.tagList! {
                    
                    let tModel = TagListModel()
                    tModel.id = model.id!!.longValue
                    tModel.name = model.name
                    tagList.addObject(tModel)
                    
                }
                
                let result = HDHM01Result()
                result.collectList = NSArray(array: collectList) as? Array<CollectListModel>
                result.recipeList = NSArray(array: recipeList) as? Array<RecipeListModel>
                result.tagList = NSArray(array: tagList) as? Array<TagListModel>
                result.wikiList = NSArray(array: wikiList) as? Array<WikiListModel>
                
                hmResponse.result = result
            }
            
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return hmResponse
    }
    
    
    /**
     *  本地缓存是否存在
     */
    func isExistEntity()->Bool {
        
        let context = HDCoreDataManager.shareInstance.managedObjectContext
        let request = NSFetchRequest(entityName: "HDHM01ResponseEntity")
        
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
    
}
