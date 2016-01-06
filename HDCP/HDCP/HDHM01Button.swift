//
//  HDHM01Button.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/5.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM01Button: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        
        return CGRectMake(0, contentRect.size.height*0.75, contentRect.size.width, contentRect.size.height*0.2);
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        
        return CGRectMake(contentRect.size.width*0.2, contentRect.size.height*0.1,contentRect.size.width*0.6,contentRect.size.height*0.6);
    }

    
}
