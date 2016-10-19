//
//  CoreUtils.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import Foundation
import Alamofire

class CoreUtils: NSObject {

    
    /**
     设置控件frame
     
     *  @ parameter x:  x轴
     *  @ parameter y:  y轴
     
     *  @ returns: CGRect
     */
    
    static func HDFrame(_ x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)->CGRect{
        
       return  CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    /**
     *  颜色
     */
    
    static func HDColor(_ r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->(UIColor){
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a);
    }
    
    /**
     返回按钮
     
     *  @ parameter sel: 事件
     
     *  @ returns: 按钮
     
     self.navigationItem.leftBarButtonItem = Constants.HDBackBarButtonItem("doThing:", taget: self)
     
     */
    static func HDBackBarButtonItem(_ sel:Selector,taget:AnyObject)->(UIBarButtonItem){
        
        let button = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        button.setBackgroundImage(UIImage(named: "back_icon_white"), for: UIControlState.normal)
        button.addTarget(taget, action: sel, for: UIControlEvents.touchUpInside)
        button.contentMode = UIViewContentMode.scaleToFill
        let backItem = UIBarButtonItem(customView: button)
        
        return backItem;
    }
    

    /**
     16进制转RGB
     
     *  @ parameter hex:   16进制
     *  @ parameter alpha: 透明度
     
     *  @ returns: UIColor
     */
    static func HDfromHexValue(_ hex:UInt,alpha:CGFloat)->UIColor{
    
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
    static func showProgressHUD(_ view:UIView){
    
        hidProgressHUD(view)
        
        let hud:MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.customView
        hud.color = CoreUtils.HDfromHexValue(0x000000, alpha: 0.4)
        hud.margin = 10
        hud.dimBackground = false
        
        let waitView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        let animation:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        animation.image = UIImage(named: "hud_waiting_animation_white");
        waitView.addSubview(animation)
        
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        logo.image = UIImage(named: "hud_waiting_logo")
        waitView.addSubview(logo)
        
        hud.customView = waitView
        
        /**
        *  动画
        */
        
        let rotationAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat(M_PI*2.0)
        rotationAnimation.duration = 1;
        rotationAnimation.isCumulative = true;
        rotationAnimation.repeatCount = .infinity
        animation.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        hud.removeFromSuperViewOnHide = true
        
        hud.show(true)
        
    }
    
    /**
     隐藏动画
     
     *  @ parameter view: hud的父视图
     */
    static func hidProgressHUD(_ view:UIView){
    
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    /**
     显示文本
     
     *  @ parameter view:  hud的父视图
     *  @ parameter title: 显示的文本内容
     */
    static func  showWarningHUD(_ view:UIView,title:String){
    
        hidProgressHUD(view)
        
        let hud:MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        hud.color = HDfromHexValue(0x000000, alpha: 0.6)
        hud.margin = 10
        hud.labelColor = HDColor(255, g: 255, b: 255, a: 1.0)
        hud.labelFont = UIFont.systemFont(ofSize: 15)
        
        hud.mode = MBProgressHUDMode.customView;
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
    static func  showSuccessHUD(_ view:UIView,title:String){
        
        hidProgressHUD(view)
        
        let hud:MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        hud.color = HDfromHexValue(0x000000, alpha: 0.6)
        hud.margin = 10
        hud.labelColor = HDColor(255, g: 255, b: 255, a: 1.0)
        hud.labelFont = UIFont.systemFont(ofSize: 15)
        
        hud.mode = MBProgressHUDMode.customView;
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
    
    static func getTextRectSize(_ text:NSString,font:UIFont,size:CGSize) -> CGRect {
        
        let attributes = [NSFontAttributeName: font]
        
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        
        return rect;
        
    }
    
    /**
     *  网络是否可用
     */
    static func networkIsReachable()->Bool{
        
        var ret:Bool!
        let manager = NetworkReachabilityManager()
        
        if  manager?.isReachable ?? false {
            
//            if ((manager?.isReachableOnEthernetOrWiFi) != nil) {
//                //do some stuff
//            }else if(manager?.isReachableOnWWAN)! {
//                //do some stuff
//            }
//            
            ret = true
        }
        else {
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
    static func isMobileNumber(_ number:String)->Bool{
    
        let regextestmobile:NSPredicate = NSPredicate(format: "SELF MATCHES %@", "^[1][1,2,3,4,5,6,7,8,9][0-9]{9}$")
        
        if regextestmobile.evaluate(with: number) == true {
        
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
    static func imageScaledToSize(_ image:UIImage,newSize:CGSize)->UIImage{
    
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
}
