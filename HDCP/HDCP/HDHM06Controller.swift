//
//  HDHM06Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/15.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM06Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        "http://api.hoto.cn/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&format=json&sessionid=1404992779&vc=25&vn=v3.5.2&loguid=&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CFFDD5AB8-D715-4007-9E15-DF103EB9DD01%7C825300FA-E7F0-4E82-9181-E914E3EBEEA0&channel=appstore&uuid=8332A3FB-D4DF-416D-AA3D-443277ECAD26&method=Collect.getRecomList"
//        "limit=20&offset=0"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
    }

    func showHud(){
        
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.view)
    }
 
    // MARK: - events
    
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
