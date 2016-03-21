//
//  HDCT09Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDCT09Controller: BaseViewController {

    var videoPlayerController:HDVideoPlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if Constants.HDSCREENWITH > 375.0 {
        
            //适配6P
            videoPlayerController = HDVideoPlayerController(frame: CGRectMake(0,64,Constants.HDSCREENWITH,220))

        }else if Constants.HDSCREENWITH == 375.0{
        
            //适配6
            videoPlayerController = HDVideoPlayerController(frame: CGRectMake(0,64,Constants.HDSCREENWITH,200))

        }else{
        
            //适配4,5
            videoPlayerController = HDVideoPlayerController(frame: CGRectMake(0,64,Constants.HDSCREENWITH,180))
        }
        
        videoPlayerController?.contentURL = NSURL(string: "http://v.hoto.cn/01/f7/1046273.mp4")
        self.view.addSubview((videoPlayerController?.view)!)
        videoPlayerController?.movieBackgroundView.sd_setImageWithURL(NSURL(string: "http://img1.hoto.cn/pic/recipe/g_230/01/f7/1046273_5d6aa3.jpg"), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        videoPlayerController?.fullScreenBlock = fullScreenBlock
        videoPlayerController?.shrinkScreenBlock = shrinkScreenBlock
        doGetRequestData(0, offset: 0)
        
    }
    
    func fullScreenBlock(){
    
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        HDLog.LogOut("----fullScreenBlock----")
        
    }
    
    func shrinkScreenBlock(){
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        HDLog.LogOut("----shrinkScreenBlock----")
        
    }
    
    deinit{
        
        videoPlayerController = nil
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "动态"
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
        
    }
    
    // MARK: - events
    func backAction(){
        
        videoPlayerController?.close()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    // MARK: - 数据加载
    func doGetRequestData(limit:Int,offset:Int){
        
        
        HDCT09Service().doGetRequest_HDCT09_URL(0, offset: 0, successBlock: { (hdResponse) -> Void in
            
            }) { (error) -> Void in
                
                
        }
        
    }


}

/***

详情
http://api.haodou.com/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&appsign=1ed196fa15f1b896a26de72f61fb2735&channel=appstore&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7C65E9FB11-64B3-4B5C-A62C-4B53FD796AC4%7C97F90A81-F659-474D-B27E-BE58CDFF30C0&format=json&loguid=8752979&method=Info.getInfo&nonce=1458377486&sessionid=1458376760&signmethod=md5&timestamp=1458377486&uuid=7408f5dd81db1165cd1896e8175a75e4&v=2&vc=46&vn=v6.0.3

rid=1046273&sign=4864f65f7e5827e7ea50a48bb70f7a2a&uid=8752979&uuid=7408f5dd81db1165cd1896e8175a75e4


评论
http://api.haodou.com/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&appsign=eba7c612222dde2f1c8c1f98fe48ff78&channel=appstore&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7C65E9FB11-64B3-4B5C-A62C-4B53FD796AC4%7C97F90A81-F659-474D-B27E-BE58CDFF30C0&format=json&loguid=8752979&method=Comment.getList&nonce=1458377630&sessionid=1458376760&signmethod=md5&timestamp=1458377630&uuid=7408f5dd81db1165cd1896e8175a75e4&v=2&vc=46&vn=v6.0.3

limit=10&offset=0&rid=1046273&sign=4864f65f7e5827e7ea50a48bb70f7a2a&type=0&uid=8752979&uuid=7408f5dd81db1165cd1896e8175a75e4


视频地址分析

1.
http://recipe1.hoto.cn/pic/recipe/l/01/f7/1046273_5d6aa3.jpg
http://v.hoto.cn/01/f7/1046273.mp4
2.
http://recipe0.hoto.cn/pic/recipe/l/aa/e6/1042090_ce3b8f.jpg
http://v.hoto.cn/aa/e6/1042090.mp4

3.
http://recipe1.hoto.cn/pic/recipe/l/8f/d8/1038479_e5266c.jpg
http://v.hoto.cn/8f/d8/1038479.mp4

HasVideo = 1 为视频

**/
