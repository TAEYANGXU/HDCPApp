//
//  HDDY02Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/4/1.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let titleArray = ["详情","步骤","评论"]

private let lineWith:CGFloat = 40
private let lineSpace:CGFloat = Constants.HDSCREENWITH/6 - lineWith/2


class HDDY02Controller: UIViewController,HDVideoPlayerDelegate {
    
    var listModel:HDDY01ListModel?
    var dy02Info:HDDY02InfoModel?
    var vedioHeight:CGFloat?
    
    var videoPlayerController:HDVideoPlayerController?
    var menuView:UIView?
    var menuLineView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showHud()
        setupUI()
        doGetRequestData()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = listModel?.data?.title
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
        
    }
    
    deinit{
        
        videoPlayerController = nil
        HDLog.LogClassDestory("HDDY02Controller")
    }
    
    // MARK: - 创建UI视图
    func setupUI(){
    
        createHDVedioPlayerView()
        createMenuView()
    }
    
    /**
     *  视频播放器
     */
    func createHDVedioPlayerView(){
        
        if videoPlayerController == nil {
            
            if Constants.HDSCREENWITH > 375.0 {
                
                //适配6P
                vedioHeight = 220.0
                videoPlayerController = HDVideoPlayerController(frame: CGRectMake(0,0,Constants.HDSCREENWITH,vedioHeight!))
                
            }else if Constants.HDSCREENWITH == 375.0{
                
                //适配6
                vedioHeight = 200.0
                videoPlayerController = HDVideoPlayerController(frame: CGRectMake(0,0,Constants.HDSCREENWITH,vedioHeight!))
                
            }else{
                
                //适配4,5
                vedioHeight = 180.0
                videoPlayerController = HDVideoPlayerController(frame: CGRectMake(0,0,Constants.HDSCREENWITH,vedioHeight!))
            }
            
            videoPlayerController?.delegate = self
            self.view.addSubview((videoPlayerController?.view)!)
        }
        
    }
    
    /**
     *  标签视图
     */
    func createMenuView() {
        
        if menuView == nil {
            
            menuView = UIView()
            self.view.addSubview(menuView!)
            unowned let WS = self
            menuView?.snp_makeConstraints(closure: { (make) in
                
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(40)
                make.top.equalTo(WS.vedioHeight!)
                make.left.equalTo(0)
                
            })
            
            let line = UILabel()
            line.backgroundColor = Constants.HDBGViewColor
            menuView?.addSubview(line)
            line.snp_makeConstraints(closure: { (make) in
                
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(1)
                make.bottom.equalTo(0)
                make.left.equalTo(0)
            })
            
            let btnWith:CGFloat = Constants.HDSCREENWITH/3
            
            
            for i in 0..<titleArray.count {
                
                let btn = UIButton(type: UIButtonType.Custom)
                btn .setTitle(titleArray[i], forState: UIControlState.Normal)
                btn.titleLabel?.font = UIFont.systemFontOfSize(15)
                btn.tag = 2016 + i
                btn.addTarget(self, action: #selector(menuAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                btn.setTitleColor(Constants.HDMainTextColor, forState: UIControlState.Normal)
                menuView?.addSubview(btn)

                if i == 0 {
                    btn.setTitleColor(Constants.HDMainColor, forState: UIControlState.Normal)
                }
                btn.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(0)
                    make.left.equalTo(CGFloat(i)*btnWith)
                    make.width.equalTo(btnWith)
                    make.height.equalTo(40)
                    
                })
                
                
            }
            
            menuLineView  = UIView(frame: CGRectMake(lineSpace,40-3,lineWith,3))
            menuLineView?.backgroundColor = Constants.HDMainColor
            menuView?.addSubview(menuLineView!)
       
            
        }
        
    }
    
    // MARK: - 获取视频地址
    func getVedioUrl(str:String) -> String {
        
        var vedioUrl = ""
        if  str.characters.count > 0 {
            
            let arrayStr = str.componentsSeparatedByString("/l/")[1]
            let str = arrayStr.componentsSeparatedByString("_")[0]
            vedioUrl = String(format: "http://v.hoto.cn/%@.mp4",str)
            
        }
        
        return vedioUrl
    }
    
    // MARK: - 滚动下滑条
    func scrollLine(index:Int)  {
        
        unowned let WS = self
        UIView.animateWithDuration(0.3) { 
            WS.menuLineView?.frame = CGRectMake(CGFloat(index)*(40+2*lineSpace)+lineSpace,40-3,lineWith,3)
        }
        
        
    }
    
    // MARK: - 提示动画显示和隐藏
    func showHud(){
        
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.view)
    }
    
    // MARK: - events
    func backAction(){
        
        videoPlayerController?.close()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func menuAction(btn:UIButton) {
        
        for view in (menuView?.subviews)! {
            
            if view.isMemberOfClass(UIButton.classForCoder()) {
                
                let btn = view as! UIButton
                btn.setTitleColor(Constants.HDMainTextColor, forState: UIControlState.Normal)
                
            }
            
        }
        
        btn.setTitleColor(Constants.HDMainColor, forState: UIControlState.Normal)
        switch btn.tag {
        case 2016:
            /**
             *  详情
             */
            scrollLine(0)
            break
        case 2017:
            /**
             *  步骤
             */
            scrollLine(1)
            break
        case 2018:
            /**
             *  评论
             */
            scrollLine(2)
            break
        default:
            ""
        }
        
    }
    
    // MARK: - 数据加载
    func doGetRequestData(){
        
        unowned let WS = self
        HDDY02Service().doGetRequest_HDDY02_URL((listModel?.data?.id)!, successBlock: { (hdResponse) -> Void in
            
            WS.hidenHud()
            WS.dy02Info = hdResponse.result?.info
            WS.videoPlayerController?.movieBackgroundView.sd_setImageWithURL(NSURL(string: (WS.dy02Info?.cover)!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
            
            if WS.dy02Info?.hasVideo == 1 {
            
                /**
                 *  视频参数设置
                 */
                WS.dy02Info?.vedioUrl = WS.getVedioUrl((WS.dy02Info?.cover)!)
                HDLog.LogOut("vedioUrl", obj: (WS.dy02Info?.vedioUrl)!)
                WS.videoPlayerController?.contentURL = NSURL(string: (WS.dy02Info?.vedioUrl)!)
                
            }
            
            
        }) { (error) -> Void in
            
            WS.hidenHud()
            CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }
    
    // MARK: - HDVideoPlayerController delegate
    func didFullScreen() {
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    func didshrinkScreen() {
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}
