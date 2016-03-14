//
//  HDCT11Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDCT11Controller: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "消息"
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
        
    }
    
    // MARK: - events
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

}
