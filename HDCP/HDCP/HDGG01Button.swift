//
//  HDGG01Button.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/8.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDGG01Button: UIButton {

    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        
        return CGRectMake(0, contentRect.size.height*0.6, contentRect.size.width, contentRect.size.height*0.2);
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        
        return CGRectMake(contentRect.size.width*0.2, contentRect.size.height*0.1,contentRect.size.width*0.5,contentRect.size.height*0.5);
    }
    
}
