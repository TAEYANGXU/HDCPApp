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
     设置控件frame
     
     *  @ parameter x:  x轴
     *  @ parameter y:  y轴
     
     *  @ returns: CGRect
     */
    
    static func HDFrame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)->CGRect{
        return CGRectMake(x, y, width, height)
    }
    
    
    /**
     *  颜色
     */
    
    static func HDColor(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->(UIColor){
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a);
    }
    
    /**
     返回按钮
     
     *  @ parameter sel: 事件
     
     *  @ returns: 按钮
     
     self.navigationItem.leftBarButtonItem = Constants.HDBackBarButtonItem("doThing:", taget: self)
     
     */
    static func HDBackBarButtonItem(sel:Selector,taget:AnyObject)->(UIBarButtonItem){
        
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
     
     *  @ parameter hex:   二进制
     *  @ parameter alpha: 透明度
     
     *  @ returns: UIColor
     */
    static func HDfromHexValue(hex:UInt,alpha:CGFloat)->UIColor{
    
        return UIColor(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
        
    }
    
    /**
     加载数据时显示的动画
     
     *  @ parameter view: hud的父视图
     */
    static func showProgressHUD(view:UIView){
    
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
     
     *  @ parameter view: hud的父视图
     */
    static func hidProgressHUD(view:UIView){
    
        MBProgressHUD.hideHUDForView(view, animated: true)
    }
    
    /**
     显示文本
     
     *  @ parameter view:  hud的父视图
     *  @ parameter title: 显示的文本内容
     */
    static func  showWarningHUD(view:UIView,title:String){
    
        hidProgressHUD(view)
        
        let hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.color = HDfromHexValue(0x000000, alpha: 0.6)
        hud.margin = 10
        hud.labelColor = HDColor(255, g: 255, b: 255, a: 1.0)
        hud.labelFont = UIFont.systemFontOfSize(15)
        
        hud.mode = MBProgressHUDMode.CustomView;
        hud.customView = UIImageView(image: UIImage(named: "37x-warning"))
        
        if title.characters.count>0 {
        
            hud.labelText = title;
            
        }
        
        hud.removeFromSuperViewOnHide = true;
        hud.hide(true, afterDelay: 1.5)
        
    }
    
    /**
     显示文本
     
     *  @ parameter view:  hud的父视图
     *  @ parameter title: 显示的文本内容
     */
    static func  showSuccessHUD(view:UIView,title:String){
        
        hidProgressHUD(view)
        
        let hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.color = HDfromHexValue(0x000000, alpha: 0.6)
        hud.margin = 10
        hud.labelColor = HDColor(255, g: 255, b: 255, a: 1.0)
        hud.labelFont = UIFont.systemFontOfSize(15)
        
        hud.mode = MBProgressHUDMode.CustomView;
        hud.customView = UIImageView(image: UIImage(named: "37x-success"))
        
        if title.characters.count>0 {
            
            hud.labelText = title;
            
        }
        
        hud.removeFromSuperViewOnHide = true;
        hud.hide(true, afterDelay: 1.5)
        
    }
    
    
    /**
     
     *  获取字符串的宽度和高度
     
     *
     
     *  @param text:NSString
     
     *  @param font:UIFont
     
     *
     
     *  @return CGRect
     
     */
    
    static func getTextRectSize(text:NSString,font:UIFont,size:CGSize) -> CGRect {
        
        let attributes = [NSFontAttributeName: font]
        
        let option = NSStringDrawingOptions.UsesLineFragmentOrigin
        
        let rect:CGRect = text.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
        
        return rect;
        
    }
    
    /**
     *  网络是否可用
     */
    static func networkIsReachable()->Bool{
        
        let reachability:Reachability
        var ret:Bool
        
        do{
            reachability = try Reachability(hostname: "www.apple.com")
            if reachability.isReachable() {
                ret = true
            }else{
                ret = false
            }
        }catch{
            ret = false
        }
        
        return ret
        
    }
    
    /**
    *  手机号码验证
    *
    *  @param mobileNum 手机号码
    *
    */
    static func isMobileNumber(number:String)->Bool{
    
        let regextestmobile:NSPredicate = NSPredicate(format: "SELF MATCHES %@", "^[1][1,2,3,4,5,6,7,8,9][0-9]{9}$")
        
        if regextestmobile.evaluateWithObject(number) == true {
        
            return true
        }else{
        
            return false
        }
        
    }
    
    /**
    *  对图片尺寸进行压缩
    *
    *  @param image   UIImage
    *  @param newSize CGSize
    *
    *  @return UIImage
    */
    static func imageScaledToSize(image:UIImage,newSize:CGSize)->UIImage{
    
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
        
    }
    
}
