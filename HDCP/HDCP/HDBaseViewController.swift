//
//  BaseViewController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

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

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = Constants.HDBGViewColor
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }


}
