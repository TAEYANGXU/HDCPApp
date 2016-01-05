//
//  CoreUtils.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class CoreUtils: NSObject {

    
    /**
     返回按钮
     
     - parameter sel: 事件
     
     - returns: 按钮
     
     self.navigationItem.leftBarButtonItem = Constants.HDBackBarButtonItem("doThing:", taget: self)
     
     */
    class func HDBackBarButtonItem(sel:Selector,taget:AnyObject)->(UIBarButtonItem){
        
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 10, 20)
        button.setBackgroundImage(UIImage(named: "back_icon_white"), forState: UIControlState.Normal)
        button.addTarget(taget, action: sel, forControlEvents: UIControlEvents.TouchUpInside)
        button.contentMode = UIViewContentMode.ScaleToFill
        let backItem = UIBarButtonItem(customView: button)
        
        return backItem;
    }
    
}
