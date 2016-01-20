//
//  HDExtension.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/20.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

// MARK: -  UIViewController Category
extension UIViewController{
    
    /**
     *   显示Tabar
     */
    func showTabBar(){
        
        if (self.tabBarController != nil) {
            
            self.tabBarController?.tabBar.hidden = false
            
        }
        
    }
    
    /**
     *   隐藏Tabar
     */
    func hideTabBar(){
        
        if (self.tabBarController != nil) {
            
            self.tabBarController?.tabBar.hidden = true
            
        }
        
    }
    
}