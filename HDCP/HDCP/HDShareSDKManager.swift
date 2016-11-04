//
//  HDShareSDKManager.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/20.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

open class HDShareSDKManager {
    
    /**
     *  ShareSDK 初始化
     */
    open class func initializeShareSDK(){
        
        /**
        *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
        *  在将生成的AppKey传入到此方法中。
        *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
        *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
        *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
        */
        
        ShareSDK.registerApp("ef272badd3ca", activePlatforms: [
            SSDKPlatformType.typeWechat.rawValue,SSDKPlatformType.typeQQ.rawValue,SSDKPlatformType.subTypeQQFriend.rawValue,SSDKPlatformType.subTypeQZone.rawValue,], onImport: { (platform : SSDKPlatformType) in
                switch platform{
                case .typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case .typeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
        }) { (platform:SSDKPlatformType, appInfo:NSMutableDictionary?) in
                switch platform {
                    
                case .typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: "wxa31fc3ddf49a3a53", appSecret: "36d04f1ddf538e8efeab2791f0caf016")
                    break
                case .typeQQ:
                    //设置腾讯应用信息，其中authType设置为只用Web形式授权
                    appInfo?.ssdkSetupQQ(byAppId: "1105128294", appKey: "c46wxXfFpd9VDcn3", authType: SSDKAuthTypeBoth)
                    break
                default:
                    break
                    
                }
        }
        
    }
    
    /**
     
     我自己自定义了分享视图(HDShareView.swift)，没有使用自带的分享视图(PS:自带的分享视图真不咋地)。
     
     **/
    
    /**
     * 自定义分享
     *
     * parameter title:        标题
     * parameter context:      文本
     * parameter image:        图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage。如: @"http://www.mob.com/images/logo_black.png" 或 @[@"http://www.mob.com/images/logo_black.png"]
     * parameter type:         分享类型
     * parameter url:          网页路径/应用路径
     * parameter shareSuccess: 分享成功
     * parameter shareFail:    分享失败
     * parameter shareCancel:  取消分享
     */
    
    open class func doShareSDK(_ title:String,context:String,image:UIImage,type:SSDKPlatformType,url:String,shareSuccess:@escaping ()->Void,shareFail:@escaping ()->Void,shareCancel:@escaping ()->Void){
        
         // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        
        shareParames.ssdkSetupShareParams(byText: context,
            images : image,
            url : URL(string:url),
            title : title,
            type : SSDKContentType.webPage)
        
        //2.进行分享
        
        switch type {
            
        case SSDKPlatformType.subTypeWechatSession:
            /**
            *  微信好友
            */
            
            ShareSDK.share(SSDKPlatformType.subTypeWechatSession, parameters: shareParames, onStateChanged: { (state:SSDKResponseState,nil, contentEntity:SSDKContentEntity?, error:Error?) in
                
                switch state{
                    
                case .success:
                    HDLog.LogOut("分享成功")
                    shareSuccess()
                    break
                case .fail:
                    HDLog.LogOut("分享失败,错误描述:", obj: error as Any)
                    shareFail()
                    break
                case .cancel:
                    HDLog.LogOut("分享取消")
                    shareCancel()
                    break
                default:
                    break
                }
                
            })
            break
        case SSDKPlatformType.subTypeWechatTimeline:
            /**
            *  微信朋友圈
            */
            ShareSDK.share(SSDKPlatformType.subTypeWechatTimeline, parameters: shareParames, onStateChanged: { (state:SSDKResponseState,nil, contentEntity:SSDKContentEntity?, error:Error?) in
                switch state{
                    
                case .success:
                    HDLog.LogOut("分享成功")
                    shareSuccess()
                    break
                case .fail:
                    HDLog.LogOut("分享失败,错误描述:", obj: error as Any)
                    shareFail()
                    break
                case .cancel:
                    HDLog.LogOut("分享取消")
                    shareCancel()
                    break
                default:
                    break
                }
            })
            break
        case SSDKPlatformType.subTypeQQFriend:
            /**
            *  QQ好友
            */
            ShareSDK.share(SSDKPlatformType.subTypeQQFriend, parameters: shareParames, onStateChanged: { (state:SSDKResponseState,nil, contentEntity:SSDKContentEntity?, error:Error?) in
                
                switch state{
                    
                case .success:
                    HDLog.LogOut("分享成功")
                    shareSuccess()
                    break
                case .fail:
                    HDLog.LogOut("分享失败,错误描述:", obj: error as Any)
                    shareFail()
                    break
                case .cancel:
                    HDLog.LogOut("分享取消")
                    shareCancel()
                    break
                default:
                    break
                }
            })
            break
        case SSDKPlatformType.subTypeQZone:
            /**
            *  QQ空间
            */
            ShareSDK.share(SSDKPlatformType.subTypeQZone, parameters: shareParames, onStateChanged: { (state:SSDKResponseState,nil, contentEntity:SSDKContentEntity?, error:Error?) in
                
                switch state{
                    
                case .success:
                    HDLog.LogOut("分享成功")
                    shareSuccess()
                    break
                case .fail:
                    HDLog.LogOut("分享失败,错误描述:", obj: error as Any)
                    shareFail()
                    break
                case .cancel:
                    HDLog.LogOut("分享取消")
                    shareCancel()
                    break
                default:
                    break
                }
            })
            break

        default:
            break
            
        }
        
    }
    
}
