//
//  HDGG01Button.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/8.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDGG01Button: UIButton {

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect(x: 0, y: contentRect.size.height*0.6, width: contentRect.size.width, height: contentRect.size.height*0.2);
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect(x: contentRect.size.width*0.25, y: contentRect.size.height*0.1,width: contentRect.size.width*0.5,height: contentRect.size.height*0.5);
    }
    
}
