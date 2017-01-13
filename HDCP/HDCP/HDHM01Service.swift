//
//  HDHM01Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/5.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

class HDHM01Service {
    
    /**
     *  菜谱主页数据
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    
    func doGetRequest_HDHM01_URL(_ successBlock:@escaping ((_ hdResponse:HDHM01Response)->Void),failBlock:@escaping ((_ error:NSError)->Void)){
    
        
        HDRequestManager.doGetRequest(Constants.HDHM01_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
//                let hdHM01Response = Mapper<HDHM01Response>().map(JSONObject: response.result.value)
                let hdHM01Response = Mapper<HDHM01Response>().map(JSONObject: response.result.value)
                /**
                *  防止卡顿
                */
                DispatchQueue.global().async {
                    
                    //更新本地数据
                    self.deleteEntity()
                    self.addEntity(hdHM01Response!)

                    DispatchQueue.main.async {
                        successBlock(hdHM01Response!)
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
    func addEntity(_ hdHM01Response:HDHM01Response){
    
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        
        
        let result = NSEntityDescription.insertNewObject(forEntityName: "HDHM01ResultEntity", into: context) as? HDHM01ResultEntity
        
        /// 菜谱专辑
        
        for (i,_) in (hdHM01Response.result?.collectList?.enumerated())! {
            
            let model = hdHM01Response.result?.collectList![i]
            
            let collectModel = NSEntityDescription.insertNewObject(forEntityName: "HM01CollectListEntity", into: context) as? HM01CollectListEntity
            
            collectModel!.cid = model!.cid as NSNumber?
            collectModel!.content = model!.content
            collectModel!.cover = model!.cover
            collectModel!.title = model!.title
            collectModel!.userName = model!.userName
            /**
            *   设置关联
            */
            collectModel?.result = result
        }
        
        
        if !isExistRecipeListEntity() {
            
            /// 滚动栏
            for (i,_) in (hdHM01Response.result?.recipeList?.enumerated())! {
                
                let model = hdHM01Response.result?.recipeList?[i]
                
                let recipeModel = NSEntityDescription.insertNewObject(forEntityName: "HM01RecipeListEntity", into: context) as? HM01RecipeListEntity
                recipeModel!.rid = model!.rid as NSNumber?
                recipeModel!.cover = model!.cover
                recipeModel!.title = model!.title
                recipeModel!.userName = model!.userName
                /**
                *   设置关联
                */
                recipeModel?.result = result
            }
            
        }
        
        /// 厨房宝典
        for (i,_) in (hdHM01Response.result?.wikiList?.enumerated())! {
            
            let model = hdHM01Response.result?.wikiList?[i]
            
            let wikiModel = NSEntityDescription.insertNewObject(forEntityName: "HM01WikiListEntity", into: context) as? HM01WikiListEntity

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
        for (i,_) in (hdHM01Response.result?.tagList?.enumerated())! {
            
            let model = hdHM01Response.result?.tagList?[i]
            
            let tagModel = NSEntityDescription.insertNewObject(forEntityName: "HM01TagListEntity", into: context) as? HM01TagListEntity
            
            tagModel!.id = model!.id as NSNumber?
            tagModel!.name = model!.name
            /**
            *   设置关联
            */
            tagModel?.result = result
        }
        
        
        let response = NSEntityDescription.insertNewObject(forEntityName: "HDHM01ResponseEntity", into: context) as? HDHM01ResponseEntity
        response?.request_id = hdHM01Response.request_id
        response?.result = result
        
        /**
        *  保存
        */
        HDCoreDataManager.sharedInstance.saveContext()
    }
    
    /**
     *  删除本地数据 因为设置了Cascade级联关系  当我们删除HDHM01ResponseEntity会把所有的数据删除
     */
    func deleteEntity(){
    
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HDHM01ResponseEntity")
        
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
    
    /**
    *  查询本地数据
    */
    func getAllResponseEntity() -> HDHM01Response{
    
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HDHM01ResponseEntity")
        
        /**
        
        一开始查询HDHM01ResponseEntity的时候，并没有一起查询出HDHM01ResultEntity，HM01TagListEntity，HM01WikiListEntity，HM01RecipeListEntity，HM01CollectListEntity，所以在遍历HDHM01ResponseEntity的集合的时候，会逐个去查询，所以产生了大量的查询语句，这无疑是低效的，能一起查出来的东西为什么要分多次呢？，其实很简单，只需要加这么一行：
        */
        request.relationshipKeyPathsForPrefetching = ["HDHM01ResultEntity","HM01TagListEntity","HM01WikiListEntity","HM01RecipeListEntity","HM01CollectListEntity"]
        
        
        let hmResponse = HDHM01Response()
        
        do {
            
            let list =  try context.fetch(request) as Array
            
            if list.count>0 {
                
                // 组装Response
                let response = list[0] as! HDHM01ResponseEntity
                hmResponse.request_id = response.request_id
                
                let collectList = NSMutableArray()
                
                for model in response.result!.collectList! {
                    
                    let cModel = CollectListModel()
                    cModel.title = (model as AnyObject).title
                    cModel.userName = (model as AnyObject).userName
                    cModel.content = (model as AnyObject).content
                    cModel.cover = (model as AnyObject).cover
//                    cModel.cid = (model as AnyObject).cid!!.longValue
                    collectList.add(cModel)
                    
                }
                
                let recipeList = NSMutableArray()
                for model in response.result!.recipeList! {
                    
                    let rModel = RecipeListModel()
                    rModel.title = (model as AnyObject).title
                    rModel.userName = (model as AnyObject).userName
                    rModel.cover = (model as AnyObject).cover
//                    rModel.rid = (model as AnyObject).rid!!.unsignedIntValue
                    recipeList.add(rModel)
                    
                }
                
                let wikiList = NSMutableArray()
                for model in response.result!.wikiList! {
                    
                    let wModel = WikiListModel()
                    wModel.title = (model as AnyObject).title
                    wModel.userName = (model as AnyObject).userName
                    wModel.cover = (model as AnyObject).cover
                    wModel.content = (model as AnyObject).content
                    wModel.url = (model as AnyObject).url
                    wikiList.add(wModel)
                    
                }
                
                let tagList = NSMutableArray()
                for model in response.result!.tagList! {
                    
                    let tModel = TagListModel()
//                    tModel.id = (model as AnyObject).id!!.longValue
                    tModel.name = (model as AnyObject).name
                    tagList.add(tModel)
                    
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
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HDHM01ResponseEntity")
        
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
    
    
    func isExistRecipeListEntity()->Bool {
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        let request:NSFetchRequest<NSFetchRequestResult>  = NSFetchRequest(entityName: "HM01RecipeListEntity")
        
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
}
