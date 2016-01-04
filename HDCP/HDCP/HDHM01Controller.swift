//
//  HDHM01ViewController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SnapKit

class HDHM01Controller: BaseViewController {
    
    var label:UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Alamofire.request(.GET, Constants.HDHM01_URL)
            .responseJSON { response in
        
                print("\(response.result.value)")
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
        }
        
        label = UILabel()
        label.backgroundColor = Constants.HDMainColor
        self.view.addSubview(label)
        
        label.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.view).offset(100)
            make.height.equalTo(140)
        }

        


    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


