//
//  GG01RowView.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/8.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDGG01RowView: UIView {

    var imageView:UIImageView!
    var title:UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        layoutSubviews()
        
    }
    
    override func layoutSubviews() {
        
        if imageView == nil {
            
            imageView = UIImageView()
            imageView.layer.cornerRadius = 1
            imageView.layer.masksToBounds = true
            self.addSubview(imageView)
            
            imageView.snp_makeConstraints { (make) -> Void in
                
                make.top.equalTo(self).offset(0)
                make.left.equalTo(self).offset(0)
                make.bottom.equalTo(self).offset(0)
                make.right.equalTo(self).offset(0)
            }
            
        }
        
        if title == nil {
            
            title = UILabel()
            title.font = UIFont.boldSystemFontOfSize(15)
            title.textColor = UIColor.whiteColor()
            title.backgroundColor = Constants.HDColor(105, g: 149, b: 0, a: 0.5)
            title.textAlignment = NSTextAlignment.Center
            self.addSubview(title)
            
            title.snp_makeConstraints(closure: { (make) -> Void in
                
                make.bottom.equalTo(self).offset(0)
                make.left.equalTo(self).offset(0)
                make.right.equalTo(self).offset(0)
                make.height.equalTo(20)
                
            })
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
