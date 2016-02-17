//
//  AppDelegate.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //设置导航栏和标签栏样式
        setUpBarStyle()
        
        //ShareSDK 初始化
        HDShareSDKManager.initializeShareSDK()
        
        //欢迎导航页面
        showWelcome()
        
        //监听网络变化
        networkMonitoring()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        HDCoreDataManager.sharedInstance.saveContext()
    
    }
    
    //  MARK: - 欢迎界面
    
    func showWelcome(){
    
        /**
         *  判断欢迎界面是否已经执行
         */
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        let appVersion:String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        
        
        if (userDefault.stringForKey(Constants.HDAppVersion)) == nil {
            
            //第一次进入
            userDefault.setValue(appVersion, forKey: Constants.HDAppVersion)
            userDefault.synchronize()
            self.window?.rootViewController = WelcomeController()
            
        }else{
            
            //版本升级后，根据版本号来判断是否进入
            let version:String =  (userDefault.stringForKey(Constants.HDAppVersion))!
            if ( appVersion == version) {
                
                UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
                self.window?.rootViewController = MainViewController()
                
            }else{
                
                
                userDefault.setValue(appVersion, forKey: Constants.HDAppVersion)
                userDefault.synchronize()
                self.window?.rootViewController = WelcomeController()
                
            }
            
        }
        
    }
    
    //  MARK: - UINavigationBar/UITabBar Style
    
    func setUpBarStyle(){
        
        /**
        *  导航栏样式
        */
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName: UIFont(name: "Heiti SC", size: 18.0)!]
        UINavigationBar.appearance().barTintColor = Constants.HDMainColor
        
        /**
        *  状态栏字体设置白色
        */
//        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        /**
        *  底部TabBar的颜色
        */
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().tintColor = Constants.HDHEXRGBA(0xFFFFFF)
        UITabBar.appearance().backgroundColor = Constants.HDHEXRGBA(0xFFFFFF)
        UITabBar.appearance().barTintColor = Constants.HDHEXRGBA(0xFFFFFF)
//        UITabBar.appearance().selectedImageTintColor = UIColor.clearColor()
        
        /**
        *  底部TabBar字体正常状态颜色
        */
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Constants.HDMainTextColor,NSFontAttributeName:UIFont.systemFontOfSize(13)], forState:UIControlState.Normal)
        /**
        *  底部TabBar字体选择状态颜色
        */
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Constants.HDMainColor,NSFontAttributeName:UIFont.systemFontOfSize(13)], forState:UIControlState.Selected)

    }
    
    /**
    *  网络监听
    */
    
    func networkMonitoring(){
        
        var reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "reachabilityChanged:",
                name: ReachabilityChangedNotification,
                object: reachability)
            
            try reachability.startNotifier()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Not reachable")
        }
    }

}

