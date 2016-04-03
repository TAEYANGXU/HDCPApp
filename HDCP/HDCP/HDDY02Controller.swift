//
//  HDDY02Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/4/1.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDDY02Controller: UIViewController {
    
    var listModel:HDDY01ListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doGetRequestData()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = listModel?.data?.title
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
        
    }
    
    deinit{
    
        HDLog.LogClassDestory("HDDY02Controller")
    }
    
    // MARK: - events
    func backAction(){
        
//        videoPlayerController?.close()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    // MARK: - 数据加载
    func doGetRequestData(){
        
        unowned let WS = self
        HDDY02Service().doGetRequest_HDDY02_URL((listModel?.data?.id)!, successBlock: { (hdResponse) -> Void in
            
            
            
            
        }) { (error) -> Void in
            
            
            CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }
}
