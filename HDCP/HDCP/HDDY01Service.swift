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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class HDDY01Service {
    
    /**
     *  动态
     *
     * parameter successBlock: 成功
     * parameter failBlock:    失败
     */
    func doGetRequest_HDDY01_URL(_ successBlock:@escaping (_ hdResponse:HDDY01Response)->Void,failBlock:@escaping (_ error:NSError)->Void){
        
        HDRequestManager.doPostRequest(["sign":"4864f65f7e5827e7ea50a48bb70f7a2a" as AnyObject,"limit":20 as AnyObject,"offset":0 as AnyObject,"uid":"8752979" as AnyObject,"timestamp":Int(Date().timeIntervalSince1970) as AnyObject], URL: Constants.HDDY01_URL) { (response) -> Void in
            
            if response.result.error == nil {
                
                /// JSON 转换成对象
                let response = Mapper<HDDY01Response>().map(JSONObject: response.result.value)
                DispatchQueue.global().async {
                
                    //更新本地数据
//                    self.deleteEntity()
//                    self.addEntity(response!)
                    DispatchQueue.main.async {
                        // 主线程中
                        successBlock(response!)
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
    func addEntity(_ hddy01Response:HDDY01Response){
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        
        let response = NSEntityDescription.insertNewObject(forEntityName: "HDDY01ResponseEntity", into: context) as? HDDY01ResponseEntity
        
        let result = NSEntityDescription.insertNewObject(forEntityName: "HDDY01ResultEntity", into: context) as? HDDY01ResultEntity
        
        for (i,_) in (hddy01Response.result?.list?.enumerated())! {
            
            let model = hddy01Response.result?.list![i]
            
            let listEntity = NSEntityDescription.insertNewObject(forEntityName: "HDDY01ListEntity", into: context) as? HDDY01ListEntity
     
            let dataModel = NSEntityDescription.insertNewObject(forEntityName: "HDDY01DataEntity", into: context) as? HDDY01DataEntity
            
            dataModel!.actionType = model?.data!.actionType as NSNumber?
            dataModel!.address = model?.data!.address
            dataModel!.commentCnt = model?.data!.commentCnt as NSNumber?
            dataModel!.commentCount = model?.data!.commentCount as NSNumber?
            dataModel!.commentUrl = model?.data!.commentUrl
            dataModel!.diggCnt = model?.data!.diggCnt as NSNumber?
            dataModel!.diggCount = model?.data!.diggCount as NSNumber?
            dataModel!.diggId = model?.data!.diggId as NSNumber?
            dataModel!.diggType = model?.data!.diggType as NSNumber?
            dataModel!.entityType = model?.data!.entityType as NSNumber?
            dataModel!.feedId = model?.data!.feedId as NSNumber?
            dataModel!.formatTime = model?.data!.formatTime
            dataModel!.id = model?.data!.id as NSNumber?
            dataModel!.intro = model?.data!.intro
            dataModel!.isDigg = model?.data!.isDigg as NSNumber?
            dataModel!.url = model?.data!.url
            dataModel!.hasVideo = model?.data!.hasVideo as NSNumber?
            if  model?.data!.hasVideo == nil {
                dataModel!.hasVideo = 0
            }
            dataModel!.title = model?.data!.title
            dataModel!.tagId = model?.data!.tagId as NSNumber?
            dataModel!.tagName = model?.data!.tagName
            dataModel!.tagUrl = model?.data!.tagUrl
            dataModel!.img = model?.data!.img
            dataModel!.content = model?.data!.content
            
            
            listEntity?.data = dataModel
            
            let userInfoModel = NSEntityDescription.insertNewObject(forEntityName: "HDDY01UserInfoEntity", into: context) as? HDDY01UserInfoEntity
            
            userInfoModel!.avatar = model?.userInfo!.avatar
            userInfoModel!.gender = model?.userInfo!.gender as NSNumber?
            userInfoModel!.intro = model?.userInfo!.intro
            userInfoModel!.openUrl = model?.userInfo!.openUrl
            userInfoModel!.relation = model?.userInfo!.relation as NSNumber?
            userInfoModel!.userId = model?.userInfo!.userId as NSNumber?
            userInfoModel!.userName = model?.userInfo!.userName
            userInfoModel!.vip = model?.userInfo!.vip as NSNumber?
            
            listEntity?.userInfo = userInfoModel
            
            if model?.data!.commentList?.count > 0 {
            
                for (i,_) in (model?.data!.commentList?.enumerated())!{
                 
                    let cmodel = model?.data!.commentList![i]
                    
                    let commentModel = NSEntityDescription.insertNewObject(forEntityName: "HDDY01CommentListEntity", into: context) as? HDDY01CommentListEntity
                    
                    commentModel!.cid = cmodel?.cid as NSNumber?
                    commentModel!.userId = cmodel?.userId as NSNumber?
                    commentModel!.userName = cmodel?.userName
                    commentModel!.content = cmodel?.content
                    commentModel!.isAuthor = cmodel?.isAuthor as NSNumber?
                    commentModel!.isVip = cmodel?.isVip as NSNumber?
                    
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
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HDDY01ResponseEntity")
        
        request.relationshipKeyPathsForPrefetching = ["HDDY01ResultEntity","HDDY01ListEntity","HDDY01DataEntity","HDDY01UserInfoEntity","HDDY01CommentListEntity"]
        
        let hmResponse = HDDY01Response()
        
        do {
            
            let list =  try context.fetch(request) as Array
            
            if list.count>0 {
                
                 //组装Response
                let response = list[0] as! HDDY01ResponseEntity
                hmResponse.request_id = response.request_id
                
                let list = NSMutableArray()
                
                let result = HDDY01Result()
                
                for model in (response.result?.list)! {
//                    
//                    let listModel = model as! HDDY01ListEntity
//                    
//                    let vListModel = HDDY01ListModel()
                    
//                    let vDataModel = HDDY01DataModel()
//                    vDataModel.actionType = listModel.data!.actionType?.int8Value
//                    vDataModel.address = listModel.data!.address
//                    vDataModel.commentCnt = listModel.data!.commentCnt!.int8Value
//                    vDataModel.commentUrl = listModel.data!.commentUrl
//                    vDataModel.diggCnt = listModel.data!.diggCnt!.int8Value
//                    vDataModel.diggId = listModel.data!.diggId!.int8Value
//                    vDataModel.diggType = listModel.data!.diggType!.int8Value
//                    vDataModel.entityType = listModel.data!.entityType!.int8Value
//                    vDataModel.feedId = listModel.data!.feedId!.int8Value
//                    vDataModel.formatTime = listModel.data!.formatTime
//                    vDataModel.id = listModel.data!.id!.int8Value
//                    vDataModel.intro = listModel.data!.intro
//                    vDataModel.isDigg = listModel.data!.isDigg!.int8Value
//                    vDataModel.url = listModel.data!.url
//                    vDataModel.hasVideo = listModel.data!.hasVideo!.int8Value
//                    vDataModel.title = listModel.data!.title
//                    vDataModel.tagName = listModel.data!.tagName
//                    vDataModel.tagUrl = listModel.data!.tagUrl
//                    vDataModel.img = listModel.data!.img
//                    vDataModel.content = listModel.data!.content
//                    
//                    vListModel.data = vDataModel
//                    
//                    let vUserInfoModel = HDDY01UserInfoModel()
//                    vUserInfoModel.avatar = listModel.userInfo!.avatar
//                    vUserInfoModel.gender = listModel.userInfo!.gender!.longValue
//                    vUserInfoModel.intro = listModel.userInfo!.intro
//                    vUserInfoModel.openUrl = listModel.userInfo!.openUrl
//                    vUserInfoModel.relation = listModel.userInfo!.relation!.longValue
//                    vUserInfoModel.userId = listModel.userInfo!.userId!.longValue
//                    vUserInfoModel.userName = listModel.userInfo!.userName
//                    vUserInfoModel.vip = listModel.userInfo!.vip!.longValue
//                    vListModel.userInfo = vUserInfoModel
//                    
//                    if listModel.data?.commentList?.count > 0 {
//                        
//                        let commentlist = NSMutableArray()
//                        for cmodel in (listModel.data?.commentList)! {
//                            
//                            let comModel = cmodel as! HDDY01CommentListEntity
//                            let rModel = HDDY01CommentListModel()
//                            
//                            
//                            rModel.cid = comModel.cid!.longValue
//                            rModel.userId = comModel.userId!.longValue
//                            rModel.userName = comModel.userName
//                            rModel.content = comModel.content
//                            rModel.isAuthor = comModel.isAuthor!.longValue
//                            rModel.isVip = comModel.isVip!.longValue
//                            
//                            commentlist.add(rModel)
//                        }
//                        
//                        vDataModel.commentList =   NSArray(array: commentlist) as? Array<HDDY01CommentListModel>
//                    }
//                    
//                    list.add(vListModel)
                    
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
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HDDY01ResponseEntity")
        
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
     *  本地缓存是否存在
     */
    func isExistEntity()->Bool {
        
        let context = HDCoreDataManager.sharedInstance.managedObjectContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HDDY01ResponseEntity")
        
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
