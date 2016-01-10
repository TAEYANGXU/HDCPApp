//
//  HDRefreshGifHeader.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/8.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDRefreshGifHeader: MJRefreshGifHeader {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override func prepare(){
    
        super.prepare()
        
        let idleImages = NSMutableArray()
        for var i=1;i<3;i++ {
        
            let name:String = String(format: "Refresh%ld",i )
            let image = UIImage(named: name)
            idleImages.addObject(image!)
            
        }
        
        /**
        *   设置普通状态的动画图片
        */
        self.setImages(idleImages as [AnyObject], forState: MJRefreshState.Idle)
        
        let refreshingImages = NSMutableArray()
        for var i=1;i<10;i++ {
            
            let name:String = String(format: "Refresh%ld",i )
            let image = UIImage(named: name)
            refreshingImages.addObject(image!)
            
        }
        
        /**
        *   设置即将刷新状态的动画图片（一松开就会刷新的状态）
        */
        self.setImages(refreshingImages as [AnyObject], forState: MJRefreshState.Pulling)
        
        /**
        *   设置正在刷新状态的动画图片
        */
        self.setImages(refreshingImages as [AnyObject], forState: MJRefreshState.Refreshing)
    }

}
