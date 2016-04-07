//
//  HDDY01Service.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/30.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

class HDDY01Service {
    
    /**
     *  动态
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDDY01_URL(limit:Int,offset:Int,successBlock:(hdResponse:HDDY01Response)->Void,failBlock:(error:NSError)->Void){
        
        HDRequestManager.doPostRequest(["sign":"4864f65f7e5827e7ea50a48bb70f7a2a","limit":20,"offset":0,"uid":"8752979","timestamp":Int(NSDate().timeIntervalSince1970)], URL: Constants.HDDY01_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDDY01Response>().map(response.result.value)
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    
                    //更新本地数据
                    self.deleteEntity()
                    self.addEntity(response!)
                    
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        
                        /// 回调
                        successBlock(hdResponse:response!)
                        
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
    func addEntity(hddy01Response:HDDY01Response){
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        
        let response = NSEntityDescription.insertNewObjectForEntityForName("HDDY01ResponseEntity", inManagedObjectContext: context) as? HDDY01ResponseEntity
        
        let result = NSEntityDescription.insertNewObjectForEntityForName("HDDY01ResultEntity", inManagedObjectContext: context) as? HDDY01ResultEntity
        
        for (i,_) in (hddy01Response.result?.list?.enumerate())! {
            
            let model = hddy01Response.result?.list![i]
            
            let listEntity = NSEntityDescription.insertNewObjectForEntityForName("HDDY01ListEntity", inManagedObjectContext: context) as? HDDY01ListEntity
     
            let dataModel = NSEntityDescription.insertNewObjectForEntityForName("HDDY01DataEntity", inManagedObjectContext: context) as? HDDY01DataEntity
            
            dataModel!.actionType = model?.data!.actionType
            dataModel!.address = model?.data!.address
            dataModel!.commentCnt = model?.data!.commentCnt
            dataModel!.commentCount = model?.data!.commentCount
            dataModel!.commentUrl = model?.data!.commentUrl
            dataModel!.diggCnt = model?.data!.diggCnt
            dataModel!.diggCount = model?.data!.diggCount
            dataModel!.diggId = model?.data!.diggId
            dataModel!.diggType = model?.data!.diggType
            dataModel!.entityType = model?.data!.entityType
            dataModel!.feedId = model?.data!.feedId
            dataModel!.formatTime = model?.data!.formatTime
            dataModel!.id = model?.data!.id
            dataModel!.intro = model?.data!.intro
            dataModel!.isDigg = model?.data!.isDigg
            dataModel!.url = model?.data!.url
            dataModel!.hasVideo = model?.data!.hasVideo
            if  model?.data!.hasVideo == nil {
                dataModel!.hasVideo = 0
            }
            dataModel!.title = model?.data!.title
            dataModel!.tagId = model?.data!.tagId
            dataModel!.tagName = model?.data!.tagName
            dataModel!.tagUrl = model?.data!.tagUrl
            dataModel!.img = model?.data!.img
            dataModel!.content = model?.data!.content
            
            
            listEntity?.data = dataModel
            
            let userInfoModel = NSEntityDescription.insertNewObjectForEntityForName("HDDY01UserInfoEntity", inManagedObjectContext: context) as? HDDY01UserInfoEntity
            
            userInfoModel!.avatar = model?.userInfo!.avatar
            userInfoModel!.gender = model?.userInfo!.gender
            userInfoModel!.intro = model?.userInfo!.intro
            userInfoModel!.openUrl = model?.userInfo!.openUrl
            userInfoModel!.relation = model?.userInfo!.relation
            userInfoModel!.userId = model?.userInfo!.userId
            userInfoModel!.userName = model?.userInfo!.userName
            userInfoModel!.vip = model?.userInfo!.vip
            
            listEntity?.userInfo = userInfoModel
            
            if model?.data!.commentList?.count > 0 {
            
                for (i,_) in (model?.data!.commentList?.enumerate())!{
                 
                    let cmodel = model?.data!.commentList![i]
                    
                    let commentModel = NSEntityDescription.insertNewObjectForEntityForName("HDDY01CommentListEntity", inManagedObjectContext: context) as? HDDY01CommentListEntity
                    
                    commentModel!.cid = cmodel?.cid
                    commentModel!.userId = cmodel?.userId
                    commentModel!.userName = cmodel?.userName
                    commentModel!.content = cmodel?.content
                    commentModel!.isAuthor = cmodel?.isAuthor
                    commentModel!.isVip = cmodel?.isVip
                    
                    commentModel?.data = dataModel
                    
                }
                
            }
            
            /**
             *   设置关联
             */
            listEntity?.result = result
            
        }
        
        response?.result = result
        
        /**
         *  保存
         */
        HDCoreDataManager.sharedInstance.saveContext()
    }
    
    /**
     *  查询本地数据
     */
    func getAllResponseEntity() -> HDDY01Response{
    
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        let request = NSFetchRequest(entityName: "HDDY01ResponseEntity")
        
        request.relationshipKeyPathsForPrefetching = ["HDDY01ResultEntity","HDDY01ListEntity","HDDY01DataEntity","HDDY01UserInfoEntity","HDDY01CommentListEntity"]
        
        let hmResponse = HDDY01Response()
        
        do {
            
            let list =  try context.executeFetchRequest(request) as Array
            
            if list.count>0 {
                
                 //组装Response
                let response = list[0] as! HDDY01ResponseEntity
                hmResponse.request_id = response.request_id
                
                let list = NSMutableArray()
                
                let result = HDDY01Result()
                
                for model in (response.result?.list)! {
                    
                    let listModel = model as! HDDY01ListEntity
                    
                    let vListModel = HDDY01ListModel()
                    
                    
                    let vDataModel = HDDY01DataModel()
                    vDataModel.actionType = listModel.data!.actionType?.longValue
                    vDataModel.address = listModel.data!.address
                    vDataModel.commentCnt = listModel.data!.commentCnt!.longValue
                    vDataModel.commentUrl = listModel.data!.commentUrl
                    vDataModel.diggCnt = listModel.data!.diggCnt!.longValue
                    vDataModel.diggId = listModel.data!.diggId!.longValue
                    vDataModel.diggType = listModel.data!.diggType!.longValue
                    vDataModel.entityType = listModel.data!.entityType!.longValue
                    vDataModel.feedId = listModel.data!.feedId!.longValue
                    vDataModel.formatTime = listModel.data!.formatTime
                    vDataModel.id = listModel.data!.id!.longValue
                    vDataModel.intro = listModel.data!.intro
                    vDataModel.isDigg = listModel.data!.isDigg!.longValue
                    vDataModel.url = listModel.data!.url
                    vDataModel.hasVideo = listModel.data!.hasVideo!.longValue
                    vDataModel.title = listModel.data!.title
                    vDataModel.tagName = listModel.data!.tagName
                    vDataModel.tagUrl = listModel.data!.tagUrl
                    vDataModel.img = listModel.data!.img
                    vDataModel.content = listModel.data!.content
                    
                    vListModel.data = vDataModel
                    
                    let vUserInfoModel = HDDY01UserInfoModel()
                    vUserInfoModel.avatar = listModel.userInfo!.avatar
                    vUserInfoModel.gender = listModel.userInfo!.gender!.longValue
                    vUserInfoModel.intro = listModel.userInfo!.intro
                    vUserInfoModel.openUrl = listModel.userInfo!.openUrl
                    vUserInfoModel.relation = listModel.userInfo!.relation!.longValue
                    vUserInfoModel.userId = listModel.userInfo!.userId!.longValue
                    vUserInfoModel.userName = listModel.userInfo!.userName
                    vUserInfoModel.vip = listModel.userInfo!.vip!.longValue
                    vListModel.userInfo = vUserInfoModel
                    
                    if listModel.data?.commentList?.count > 0 {
                        
                        let commentlist = NSMutableArray()
                        for cmodel in (listModel.data?.commentList)! {
                            
                            let comModel = cmodel as! HDDY01CommentListEntity
                            let rModel = HDDY01CommentListModel()
                            
                            
                            rModel.cid = comModel.cid!.longValue
                            rModel.userId = comModel.userId!.longValue
                            rModel.userName = comModel.userName
                            rModel.content = comModel.content
                            rModel.isAuthor = comModel.isAuthor!.longValue
                            rModel.isVip = comModel.isVip!.longValue
                            
                            commentlist.addObject(rModel)
                        }
                        
                        vDataModel.commentList =   NSArray(array: commentlist) as? Array<HDDY01CommentListModel>
                    }
                    
                    list.addObject(vListModel)
                    
                }
                
                result.list = NSArray(array: list) as? Array<HDDY01ListModel>
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
     *  删除本地数据 因为设置了Cascade级联关系  当我们删除HDDY01ResponseEntity会把所有的数据删除
     */
    func deleteEntity(){
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        
        let request = NSFetchRequest(entityName: "HDDY01ResponseEntity")
        
        do {
            
            let list =  try context.executeFetchRequest(request) as Array
            
            if list.count>0 {
                
                for model in list {
                    
                    context.deleteObject(model as! NSManagedObject)
                    
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
     *  本地缓存是否存在
     */
    func isExistEntity()->Bool {
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        let request = NSFetchRequest(entityName: "HDDY01ResponseEntity")
        
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