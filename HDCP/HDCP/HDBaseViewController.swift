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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     提供给子类调用 子类也可以重写
     
     - parameter btn:
     */
    func doThing(btn:UIButton){
        
        
        print("so some thing ha ha")
        
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
