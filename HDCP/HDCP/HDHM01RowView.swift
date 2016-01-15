//
//  HDHM01RowView.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/6.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM01RowView: UIView {

    var imageView:UIImageView!
    var title:UILabel!
    var userName:UILabel!
    var detail:UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        createSubviews()
        
    }
    
    func createSubviews() {
        
        if imageView == nil {
        
            imageView = UIImageView()
            imageView.layer.cornerRadius = 1
            imageView.layer.masksToBounds = true
            self.addSubview(imageView)
            
            imageView.snp_makeConstraints { (make) -> Void in
                
                make.top.equalTo(self).offset(0)
                make.left.equalTo(self).offset(0)
                make.width.equalTo(100)
                make.height.equalTo(100)
            }
            
        }
        
        if title == nil {
        
            title = UILabel()
            title.font = UIFont.boldSystemFontOfSize(17)
            self.addSubview(title)
            
            title.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(self).offset(0)
                make.left.equalTo(imageView.snp_right).offset(5)
                make.width.equalTo(Constants.HDSCREENWITH-36-100)
                make.height.equalTo(25)
                
            })
            
        }
        
        if userName == nil {
        
            userName = UILabel()
            userName.font = UIFont.systemFontOfSize(15)
            userName.textColor = Constants.HDMainTextColor
            self.addSubview(userName)
            
            userName.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(title.snp_bottom).offset(2)
                make.left.equalTo(imageView.snp_right).offset(5)
                make.width.equalTo(Constants.HDSCREENWITH-36-100)
                make.height.equalTo(25)
                
            })
            
        }
        
        
        if detail == nil {
        
            
            detail = UILabel()
            detail.font = UIFont.systemFontOfSize(15)
            detail.textColor = Constants.HDMainTextColor
            detail.numberOfLines = 0
            self.addSubview(detail)
            
            detail.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(userName.snp_bottom).offset(0)
                make.left.equalTo(imageView.snp_right).offset(5)
                make.width.equalTo(Constants.HDSCREENWITH-36-100)
                make.height.equalTo(50)
            })
        }
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
