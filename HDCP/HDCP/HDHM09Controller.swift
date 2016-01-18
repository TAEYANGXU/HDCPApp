//
//  HDHM09Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/18.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM09Controller: UIViewController {
    
    var stepModel:HDHM08StepModel?
    var cancelBtn:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        setupUI()
    }

    // MARK: - 创建UI视图
    
    func setupUI(){
    
        cancelBtn = UIButton(type: UIButtonType.Custom) as UIButton
        cancelBtn?.setTitle("x", forState: UIControlState.Normal)
        cancelBtn?.layer.cornerRadius = 15
        cancelBtn?.titleLabel?.textAlignment = NSTextAlignment.Center
        cancelBtn?.layer.masksToBounds = true
        cancelBtn?.setTitleColor(Constants.HDMainColor, forState: UIControlState.Normal)
        cancelBtn?.layer.borderWidth = 0.5
        
        cancelBtn?.layer.borderColor = Constants.HDMainColor.CGColor
        self.view.addSubview(cancelBtn!)
        
        cancelBtn?.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        cancelBtn?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.top.equalTo(self.view).offset(50)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.width.equalTo(30)
            make.height.equalTo(30)
            
        })
        
        
    }
    
    // MARK: - events
    
    func backAction(){
    
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        self.dismissViewControllerAnimated(true) { () -> Void in }
        
    }
}
