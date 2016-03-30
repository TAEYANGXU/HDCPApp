//
//  WelcomeController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/19.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController {

    var welcomeView:UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().statusBarHidden = true
     
        setupUI()
    }
    
    deinit{
    
        HDLog.LogClassDestory("WelcomeController")
    }

    // MARK: - 创建UI视图
    func setupUI(){
        
        welcomeView = UIScrollView()
        welcomeView?.contentSize = CGSizeMake(Constants.HDSCREENWITH*5, Constants.HDSCREENHEIGHT)
        welcomeView?.pagingEnabled = true
        welcomeView?.bounces = false
        welcomeView?.showsHorizontalScrollIndicator = false
        welcomeView?.showsVerticalScrollIndicator = false
        self.view.addSubview(welcomeView!)
        
        unowned let WS = self;
        welcomeView?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.top.equalTo(WS.view).offset(0)
            make.left.equalTo(WS.view).offset(0)
            make.bottom.equalTo(WS.view).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            
        })
        
        
        for i in 1...5 {
        
            let imageView = UIImageView()
            imageView.image = UIImage(named: String(format: "guide_step0%d",i))
            welcomeView?.addSubview(imageView)
            imageView.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(welcomeView!).offset(0)
                make.left.equalTo(welcomeView!).offset(CGFloat(i-1)*Constants.HDSCREENWITH)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(Constants.HDSCREENHEIGHT)
            })

            if i == 5 {
            
                let btn = UIButton(type: UIButtonType.Custom)
                btn.backgroundColor = UIColor.clearColor()
                btn.setTitle("立即体验", forState: UIControlState.Normal)
                btn.layer.cornerRadius = 5;
                btn.layer.masksToBounds = true
                btn.setTitleColor(CoreUtils.HDColor(245, g: 161, b: 0, a: 1), forState: UIControlState.Normal)
                btn.layer.borderColor = Constants.HDMainColor.CGColor
                btn.layer.borderWidth = 1
                welcomeView?.addSubview(btn)
                
                btn.addTarget(self, action: #selector(toMain), forControlEvents: UIControlEvents.TouchUpInside)
                
                btn.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.bottom.equalTo(welcomeView!).offset(Constants.HDSCREENHEIGHT-100)
                    make.left.equalTo(welcomeView!).offset(CGFloat(i-1)*Constants.HDSCREENWITH+Constants.HDSCREENWITH/2-50)
                    make.width.equalTo(100)
                    make.height.equalTo(30)
                    
                })
                
                
            }
            
        }
        
    }
    
    // MARK: - events
    
    func toMain(){
    
        /**
         *  欢迎界面只展示一次
         */
//        let userDefault = NSUserDefaults.standardUserDefaults()
//        userDefault.setValue(Constants.HDShowWelcome, forKey: Constants.HDShowWelcome)
//        userDefault.synchronize()
        
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        UIApplication.sharedApplication().delegate?.window!!.rootViewController = MainViewController()
        
    }
    
}
