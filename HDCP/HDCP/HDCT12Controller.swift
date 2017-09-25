//
//  HDCT12Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 2017/2/15.
//  Copyright © 2017年 batonsoft. All rights reserved.
//

import UIKit

class HDCT12Controller: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        doGetRequestData();

        //http://api.haodou.com/index.php?uuid=d0a290da740161c32d3642526c821ae3&signmethod=md5&vc=109&isBreak=0&appid=4&channel=appstore&idfa=0c040fd8521082b577891f58da53ebd7&vn=v6.1.19&format=json&sessionid=1487137650&appkey=573bbd2fbd1a6bac082ff4727d952ba3&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7CCB9F92DA-AE9B-46D6-8C57-0D355D62103E%7C1E2D7D52-34DF-4E62-BA34-1E64AFD5E434&limit=20&offset=0&v=2&method=Topic.getTopicList&
        //cateid=33&digest=0&loguid=&nonce=1487139543&sign=&timestamp=1487139543&uid=&uuid=d0a290da740161c32d3642526c821ae3
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)

    }

    deinit {

        HDLog.LogClassDestory("HDCT12Controller")
    }

    // MARK: - events
    @objc func backAction() {

        navigationController!.popViewController(animated: true)

    }

    /**
     *  加载数据
     */
    func doGetRequestData() {

        unowned let WS = self
        HDCT12Service().doGetRequest_HDCT12_URL({ (hdResponse) -> Void in



        }) { (error) -> Void in

            CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)

        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
