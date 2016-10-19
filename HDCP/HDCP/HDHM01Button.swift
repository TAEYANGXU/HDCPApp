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
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect(x: 0, y: contentRect.size.height*0.75, width: contentRect.size.width, height: contentRect.size.height*0.2);
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect(x: contentRect.size.width*0.2, y: contentRect.size.height*0.1,width: contentRect.size.width*0.6,height: contentRect.size.height*0.6);
    }

    
}
