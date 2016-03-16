//
//  HDCT09Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDCT09Controller: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        doGetRequestData(0, offset: 0)
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "动态"
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
        
    }
    
    // MARK: - events
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    // MARK: - 数据加载
    func doGetRequestData(limit:Int,offset:Int){
        
        
        HDCT09Service().doGetRequest_HDCT09_URL(0, offset: 0, successBlock: { (hdResponse) -> Void in
            
            }) { (error) -> Void in
                
                
        }
        
    }


}
