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
    func didShareWithType(_ type:Int);
}

open class HDShareView: UIView {

    weak open var delegate:HDShareViewDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        createSubviews()
        
    }
    
    func createSubviews() {
        
        for i in 0 ..< resourceArray.count {
            
            if i == 3 {
            
                let btn = HDShareButton()
                btn.backgroundColor = UIColor.white
                btn.setTitleColor(Constants.HDMainTextColor, for: UIControlState.normal)
                btn.tag = i + 1000;
                btn.titleLabel?.textAlignment = NSTextAlignment.center
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                btn.setTitle(resourceArray[i]["title"], for: UIControlState())
                btn.setImage(UIImage(named:resourceArray[i]["image"]!), for: UIControlState())
                btn.addTarget(self, action: #selector(tagBtnOnclick(_:)), for: UIControlEvents.touchUpInside)
                self.addSubview(btn)
                
                let space = (Constants.HDSCREENWITH-180)/6
                
                btn.snp.makeConstraints( { (make) -> Void in
                    
                    
                    make.top.equalTo(self).offset(HDShareButtonHeight+20+20+15)
                    make.width.equalTo(HDShareButtonHeight)
                    make.height.equalTo(HDShareButtonHeight+20)
                    make.left.equalTo(space)
                    
                })
                
                /**
                *  判断QQ是否安装
                */
                if !QQApiInterface.isQQInstalled() {
                    
                    btn.isEnabled = false
                }

                
            }else{
            
                let btn = HDShareButton()
                btn.backgroundColor = UIColor.white
                btn.setTitleColor(Constants.HDMainTextColor, for: UIControlState.normal)
                btn.tag = i + 1000;
                btn.titleLabel?.textAlignment = NSTextAlignment.center
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                btn.setTitle(resourceArray[i]["title"], for: UIControlState())
                btn.setImage(UIImage(named:resourceArray[i]["image"]!), for: UIControlState())
                btn.addTarget(self, action: #selector(tagBtnOnclick(_:)), for: UIControlEvents.touchUpInside)
                self.addSubview(btn)
                
                let space = (Constants.HDSCREENWITH-CGFloat(3*HDShareButtonHeight))/6
                
                btn.snp.makeConstraints( { (make) -> Void in
                    
                    
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
                    
                        btn.isEnabled = false
                        
                    }
                    
                }else{
                
                    /**
                    *  判断QQ是否安装
                    */
                    if !QQApiInterface.isQQInstalled() {
                    
                        btn.isEnabled = false
                    }
                    
                }

            }
        }
        
        let line = UILabel()
        line.backgroundColor = CoreUtils.HDColor(227, g: 227, b: 229, a: 1.0)
        self.addSubview(line)
        line.snp.makeConstraints { (make) -> Void in
            
            make.left.equalTo(self).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(-44)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(1)
        }
        
        
        let cancelBtn = UIButton()
        cancelBtn.backgroundColor = UIColor.white
        cancelBtn.setTitleColor(Constants.HDMainTextColor, for: UIControlState.normal)
        cancelBtn.setTitle("取消", for: UIControlState())
        cancelBtn.tag = 4 + 1000;
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelBtn.addTarget(self, action: #selector(tagBtnOnclick(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(cancelBtn)
        
        cancelBtn.snp.makeConstraints { (make) -> Void in
            
            make.left.equalTo(self).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(44)
            
        }

        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tagBtnOnclick(_ btn:UIButton){
        
        if (self.delegate != nil) {
            
            self.delegate?.didShareWithType(btn.tag - 1000)
            
        }
        
    }


}



class HDShareButton: UIButton {
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect(x: 0, y: contentRect.size.height*0.75, width: contentRect.size.width, height: contentRect.size.height*0.25);
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect(x: 0, y: 0,width: contentRect.size.width,height: contentRect.size.height*0.75);
    }
    
    
}
