//
//  HDShareView.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/20.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let HDShareButtonHeight = 60

private let resourceArray = [["title":"微信好友","image":"share_wxhy_icon"],
    ["title":"朋友圈","image":"share_wxc_icon"],
    ["title":"QQ","image":"share_qq_icon"],
    ["title":"QQ空间","image":"share_qqzone_icon"]]

public protocol HDShareViewDelegate:NSObjectProtocol {
    func didShareWithType(type:Int);
}

public class HDShareView: UIView {

    weak public var delegate:HDShareViewDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        createSubviews()
        
    }
    
    func createSubviews() {
        
        for i in 0 ..< resourceArray.count {
            
            if i == 3 {
            
                let btn = HDShareButton()
                btn.backgroundColor = UIColor.whiteColor()
                btn.setTitleColor(Constants.HDMainTextColor, forState: UIControlState.Normal)
                btn.tag = i + 1000;
                btn.titleLabel?.textAlignment = NSTextAlignment.Center
                btn.titleLabel?.font = UIFont.systemFontOfSize(14)
                btn.setTitle(resourceArray[i]["title"], forState: UIControlState.Normal)
                btn.setImage(UIImage(named:resourceArray[i]["image"]!), forState: UIControlState.Normal)
                btn.addTarget(self, action: #selector(tagBtnOnclick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(btn)
                
                let space = (Constants.HDSCREENWITH-180)/6
                
                btn.snp_makeConstraints(closure: { (make) -> Void in
                    
                    
                    make.top.equalTo(self).offset(HDShareButtonHeight+20+20+15)
                    make.width.equalTo(HDShareButtonHeight)
                    make.height.equalTo(HDShareButtonHeight+20)
                    make.left.equalTo(space)
                    
                })
                
                /**
                *  判断QQ是否安装
                */
                if !QQApiInterface.isQQInstalled() {
                    
                    btn.enabled = false
                }

                
            }else{
            
                let btn = HDShareButton()
                btn.backgroundColor = UIColor.whiteColor()
                btn.setTitleColor(Constants.HDMainTextColor, forState: UIControlState.Normal)
                btn.tag = i + 1000;
                btn.titleLabel?.textAlignment = NSTextAlignment.Center
                btn.titleLabel?.font = UIFont.systemFontOfSize(14)
                btn.setTitle(resourceArray[i]["title"], forState: UIControlState.Normal)
                btn.setImage(UIImage(named:resourceArray[i]["image"]!), forState: UIControlState.Normal)
                btn.addTarget(self, action: #selector(tagBtnOnclick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(btn)
                
                let space = (Constants.HDSCREENWITH-CGFloat(3*HDShareButtonHeight))/6
                
                btn.snp_makeConstraints(closure: { (make) -> Void in
                    
                    
                    make.top.equalTo(self).offset(20)
                    make.width.equalTo(HDShareButtonHeight)
                    make.height.equalTo(HDShareButtonHeight+20)
                    make.left.equalTo(space+CGFloat(i*HDShareButtonHeight)+CGFloat(i*2)*space)
                    
                })
                
               
                if i == 0 || i == 1 {
                    /**
                    *  判断微信是否安装
                    */
                    if !WXApi.isWXAppInstalled() {
                    
                        btn.enabled = false
                        
                    }
                    
                }else{
                
                    /**
                    *  判断QQ是否安装
                    */
                    if !QQApiInterface.isQQInstalled() {
                    
                        btn.enabled = false
                    }
                    
                }

            }
        }
        
        let line = UILabel()
        line.backgroundColor = CoreUtils.HDColor(227, g: 227, b: 229, a: 1.0)
        self.addSubview(line)
        line.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(self).offset(0)
            make.bottom.equalTo(self.snp_bottom).offset(-44)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(1)
        }
        
        
        let cancelBtn = UIButton()
        cancelBtn.backgroundColor = UIColor.whiteColor()
        cancelBtn.setTitleColor(Constants.HDMainTextColor, forState: UIControlState.Normal)
        cancelBtn.setTitle("取消", forState: UIControlState.Normal)
        cancelBtn.tag = 4 + 1000;
        cancelBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        cancelBtn.addTarget(self, action: #selector(tagBtnOnclick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(cancelBtn)
        
        cancelBtn.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(self).offset(0)
            make.bottom.equalTo(self.snp_bottom).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(44)
            
        }

        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tagBtnOnclick(btn:UIButton){
        
        if (self.delegate != nil) {
            
            self.delegate?.didShareWithType(btn.tag - 1000)
            
        }
        
    }


}



class HDShareButton: UIButton {
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        
        return CGRectMake(0, contentRect.size.height*0.75, contentRect.size.width, contentRect.size.height*0.25);
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        
        return CGRectMake(0, 0,contentRect.size.width,contentRect.size.height*0.75);
    }
    
    
}