//
//  HDShareSDKManager.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/20.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

class HDShareSDKManager {
    
    class func initializeShareSDK(){
        
        /**
        *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
        *  在将生成的AppKey传入到此方法中。
        *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
        *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
        *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
        */
        
        ShareSDK.registerApp("ef272badd3ca",
            
            activePlatforms: [
                SSDKPlatformType.TypeWechat.rawValue,SSDKPlatformType.TypeQQ.rawValue,SSDKPlatformType.SubTypeQQFriend.rawValue,SSDKPlatformType.SubTypeQZone.rawValue,],
            onImport: {(platform : SSDKPlatformType) -> Void in
                
                switch platform{
                    
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.TypeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
            },
            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                switch platform {
                
                case SSDKPlatformType.TypeWechat:
                    //设置微信应用信息
                    appInfo.SSDKSetupWeChatByAppId("wxce10f2342e459f4b", appSecret: "329a87ed1f9bf414aee03a0aa5d98e71")
                    break
                case SSDKPlatformType.TypeQQ:
                    //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
                    appInfo.SSDKSetupQQByAppId("1105128294", appKey: "c46wxXfFpd9VDcn3", authType: SSDKAuthTypeBoth)
                    break
                    default:
                    break
                    
                }
        })
        
    }
    
    
    class func doShareSDK(title:String,context:String,image:UIImage,type:SSDKPlatformType,url:String,shareSuccess:()->Void,shareFail:()->Void,shareCancel:()->Void){
        
         // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        
        shareParames.SSDKSetupShareParamsByText(context,
            images : image,
            url : NSURL(string:url),
            title : title,
            type : SSDKContentType.WebPage)
        
        //2.进行分享
        
        switch type {
            
        case SSDKPlatformType.SubTypeWechatSession:
            /**
            *  微信好友
            */
            ShareSDK.share(SSDKPlatformType.SubTypeWechatSession, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
                
                switch state{
                    
                case SSDKResponseState.Success:
                    print("分享成功")
                    shareSuccess()
                    break
                case SSDKResponseState.Fail:
                    print("分享失败,错误描述:\(error)")
                    shareFail()
                    break
                case SSDKResponseState.Cancel:
                    print("分享取消")
                    shareCancel()
                    break
                default:
                    break
                }
            }
            break
        case SSDKPlatformType.SubTypeWechatTimeline:
            /**
            *  微信朋友圈
            */
            ShareSDK.share(SSDKPlatformType.SubTypeWechatTimeline, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
                
                switch state{
                    
                case SSDKResponseState.Success:
                    print("分享成功")
                    shareSuccess()
                    break
                case SSDKResponseState.Fail:
                    print("分享失败,错误描述:\(error)")
                    shareFail()
                    break
                case SSDKResponseState.Cancel:
                    print("分享取消")
                    shareCancel()
                    break
                default:
                    break
                }
            }
            break
        case SSDKPlatformType.SubTypeQQFriend:
            /**
            *  QQ好友
            */
            ShareSDK.share(SSDKPlatformType.SubTypeQQFriend, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
                
                switch state{
                    
                case SSDKResponseState.Success:
                    print("分享成功")
                    shareSuccess()
                    break
                case SSDKResponseState.Fail:
                    print("分享失败,错误描述:\(error)")
                    shareFail()
                    break
                case SSDKResponseState.Cancel:
                    print("分享取消")
                    shareCancel()
                    break
                default:
                    break
                }
            }
            break
        case SSDKPlatformType.SubTypeQZone:
            /**
            *  QQ空间
            */
            ShareSDK.share(SSDKPlatformType.SubTypeQZone, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
                
                switch state{
                    
                case SSDKResponseState.Success:
                    print("分享成功")
                    shareSuccess()
                    break
                case SSDKResponseState.Fail:
                    print("分享失败,错误描述:\(error)")
                    shareFail()
                    break
                case SSDKResponseState.Cancel:
                    print("分享取消")
                    shareCancel()
                    break
                default:
                    break
                }
            }
            break

        default:
            ""
            
        }
        
    }
    
}