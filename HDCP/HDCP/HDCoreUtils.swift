//
//  CoreUtils.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation

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
    

    /**
     二进制转RGB
     
     - parameter hex:   二进制
     - parameter alpha: 透明度
     
     - returns: UIColor
     */
    class func HDfromHexValue(hex:UInt,alpha:CGFloat)->UIColor{
    
        return UIColor(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
        
    }
    
    /**
     加载数据时显示的动画
     
     - parameter view: hud的父视图
     */
    class func showProgressHUD(view:UIView){
    
        hidProgressHUD(view)
        
        let hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = MBProgressHUDMode.CustomView
        hud.color = CoreUtils.HDfromHexValue(0x000000, alpha: 0.4)
        hud.margin = 10
        hud.dimBackground = false
        
        let waitView:UIView = UIView(frame: CGRectMake(0,0,50,50))
        
        let animation:UIImageView = UIImageView(frame: CGRectMake(0,0,50,50))
        animation.image = UIImage(named: "hud_waiting_animation_white");
        waitView.addSubview(animation)
        
        let logo = UIImageView(frame: CGRectMake(0,0,50,50))
        logo.image = UIImage(named: "hud_waiting_logo")
        waitView.addSubview(logo)
        
        hud.customView = waitView
        
        /**
        *  动画
        */
        
        let rotationAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat(M_PI*2.0)
        rotationAnimation.duration = 1;
        rotationAnimation.cumulative = true;
        rotationAnimation.repeatCount = .infinity
        animation.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
        
        hud.removeFromSuperViewOnHide = true
        
        hud.show(true)
        
    }
    
    /**
     隐藏动画
     
     - parameter view: hud的父视图
     */
    class func hidProgressHUD(view:UIView){
    
        MBProgressHUD.hideHUDForView(view, animated: true)
    }
    
    /**
     显示文本
     
     - parameter view:  hud的父视图
     - parameter title: 显示的文本内容
     */
    class func showProgressHUD(view:UIView,title:String){
    
        hidProgressHUD(view)
        
        let hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = title;
        hud.hide(true, afterDelay: 1.5)
    }
    
}
