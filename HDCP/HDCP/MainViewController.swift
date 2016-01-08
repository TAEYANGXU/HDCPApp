//
//  MainViewController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    var hdhm01vc:HDHM01Controller!
    var hdsc01vc:HDSC01Controller!
    var hdcg01vc:HDCG01Controller!
    var hdgg01vc:HDGG01Controller!
    var hdct01vc:HDCT01Controller!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTabBarView()
    }
    
    /**
     *  初始化Tabar
     */
    func setupTabBarView(){
    
        
        var navc:UINavigationController!
        
        /**
        *  首页
        */
        if hdhm01vc == nil {
        
            hdhm01vc = HDHM01Controller()
            hdhm01vc.tabBarItem = UITabBarItem(title: "菜谱", image: UIImage(named: "tab_icon_off_01")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "tab_icon_on_01")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
            hdhm01vc.title = "菜谱"
            navc = UINavigationController(rootViewController: hdhm01vc)
            self.addChildViewController(navc)
            
        }
        
        
        /**
        *  逛逛
        */
        if hdgg01vc == nil {
            
            hdgg01vc = HDGG01Controller()
            hdgg01vc.tabBarItem = UITabBarItem(title: "逛逛", image: UIImage(named: "tab_icon_off_04")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "tab_icon_on_04")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
            hdgg01vc.title = "逛逛"
            navc = UINavigationController(rootViewController: hdgg01vc)
            self.addChildViewController(navc)
            
        }
        
//        /**
//        *  分类
//        */
//        if hdcg01vc == nil {
//            
//            hdcg01vc = HDCG01Controller()
//            hdcg01vc.tabBarItem = UITabBarItem(title: "分类", image: UIImage(named: "tab_icon_off_03")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "tab_icon_on_03")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
//            hdcg01vc.title = "分类"
//            navc = UINavigationController(rootViewController: hdcg01vc)
//            self.addChildViewController(navc)
//            
//        }
        
        
        /**
        *  搜索
        */
        if hdsc01vc == nil {
        
            hdsc01vc = HDSC01Controller()
            hdsc01vc.tabBarItem = UITabBarItem(title: "搜索", image: UIImage(named: "tab_icon_off_02")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "tab_icon_on_02")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
            hdsc01vc.title = "搜索"
            navc = UINavigationController(rootViewController: hdsc01vc)
            self.addChildViewController(navc)
            
        }
        
        /**
        *  我的
        */
        if hdct01vc == nil {
        
            hdct01vc = HDCT01Controller()
            hdct01vc.tabBarItem = UITabBarItem(title: "我的", image: UIImage(named: "tab_icon_off_05")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "tab_icon_on_05")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
            hdct01vc.title = "我的"
            navc = UINavigationController(rootViewController: hdct01vc)
            navc.navigationBar.barTintColor = Constants.HDMainColor
            self.addChildViewController(navc)
            
        }
        
    }

    /**
     *  mark - TabBar 代理实现
     */
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
