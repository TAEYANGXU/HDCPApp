//
//  HDCT08Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDCT08Controller: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        doGetRequestData(0, offset: 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "豆友"
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
        
    }
    
    // MARK: - events
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    // MARK: - 数据加载
    func doGetRequestData(limit:Int,offset:Int){
    
        
        HDCT08Service().doGetRequest_HDCT08_URL(0, offset: 0, successBlock: { (hdResponse) -> Void in
            
            }) { (error) -> Void in
                
                
        }
        
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
    
        
    }
}
