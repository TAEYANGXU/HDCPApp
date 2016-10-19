//
//  BaseViewController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = Constants.HDBGViewColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }


}
