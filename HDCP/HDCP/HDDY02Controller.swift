//
//  HDDY02Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/4/1.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let shareViewHeight = CGFloat(255)
private let titleArray = ["详情","步骤","评论"]
private let lineWith:CGFloat = 40
private let lineSpace:CGFloat = Constants.HDSCREENWITH/6 - lineWith/2


class HDDY02Controller: UIViewController,HDVideoPlayerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,HDShareViewDelegate {
    
    var listModel:HDDY01ListModel?
    var dy02Info:HDDY02InfoModel?
    var vedioHeight:CGFloat?
    var commentList = Array<HDDY0202ListModel>()
    
    //视频播放视图
    var videoPlayerController:HDVideoPlayerController?
    //滚动条
    var menuView:UIView?
    var menuLineView:UIView?
    
    var scrollView:UIScrollView?
    
    //详情
    var detailView:UIScrollView?
    //步骤
    var stepsView:UIScrollView?
    //评论
    var commentView:UIScrollView?
    
    //个人信息视图
    var infoView:UIView?
    var titleLb:UILabel!
    var createTime:UILabel!
    var headIcon:UIImageView!
    var viewCount:UILabel!
    var commentCount:UILabel!
    var userName:UILabel!
    var tags:UILabel!
    
    //简介
    var introView:UILabel?
    //食材
    var stuffTableView:UITableView?
    //小贴士
    var tipsView:UIView?
    var tips:UILabel!
    
    //步骤
    var stepsTableView:UITableView?
    
    //评论
    var commentTableView:UITableView?
    var activityIndicatorView:UIActivityIndicatorView?
    var isCommentLoadIng = false
    var noComment:UILabel?
    
    //分享
    var shareView:UIView!
    var shareSubView:HDShareView!
    
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
     
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 30, 30)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.setBackgroundImage(UIImage(named: "shareIcon"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(share), forControlEvents: UIControlEvents.TouchUpInside)
        button.contentMode = UIViewContentMode.ScaleToFill
        let rightItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightItem

    }
    
    deinit{
        
        videoPlayerController = nil
        HDLog.LogClassDestory("HDDY02Controller")
    }
    
    // MARK: - 创建UI视图
    func setupUI(){
    
        createHDVedioPlayerView()
        createMenuView()
        createScrollView()
        createInfoView()
        createIntroView()
        createActivityIndicatorView()
        createShareView()
        
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
    
    /**
     *  底部滚动视图
     */
    func createScrollView() {
        
        
        if scrollView == nil {
            
            scrollView = UIScrollView()
            scrollView?.delegate = self
            scrollView?.contentSize = CGSizeMake(3*Constants.HDSCREENWITH, Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)
            scrollView?.pagingEnabled = true
            scrollView?.showsHorizontalScrollIndicator = false
            self.view.addSubview(scrollView!)
            unowned let WS = self
            scrollView?.snp_makeConstraints(closure: { (make) in
                
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)
                make.top.equalTo(WS.menuView!.snp_bottom).offset(0)
                make.left.equalTo(0)
                
            })
            
            
            detailView = UIScrollView()
            scrollView?.addSubview(detailView!)
            detailView!.snp_makeConstraints(closure: { (make) in
                
                make.width.equalTo(Constants.HDSCREENWITH)
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.height.equalTo(Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)
                
            })
            
            
            stepsView = UIScrollView()
            stepsView?.contentSize = CGSizeMake(Constants.HDSCREENWITH, Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)
            scrollView?.addSubview(stepsView!)
            stepsView!.snp_makeConstraints(closure: { (make) in
                
                make.width.equalTo(Constants.HDSCREENWITH)
                make.top.equalTo(0)
                make.left.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)
                
            })
            
            commentView = UIScrollView()
            commentView?.contentSize = CGSizeMake(Constants.HDSCREENWITH, Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)
            scrollView?.addSubview(commentView!)
            commentView!.snp_makeConstraints(closure: { (make) in
                
                make.width.equalTo(Constants.HDSCREENWITH)
                make.top.equalTo(0)
                make.left.equalTo(CGFloat(2)*Constants.HDSCREENWITH)
                make.height.equalTo(Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)
                
            })
            
        }
        
    }
    
    /**
     *  个人信息
     */
    func createInfoView(){
        
        unowned let WS = self
        
        if infoView == nil {
            
            infoView = UIView()
            detailView?.addSubview(infoView!)
            
            
            infoView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(Constants.HDSpace)
                make.left.equalTo(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(110)
                
            })
            
            
            titleLb = UILabel()
            titleLb.textColor = Constants.HDMainTextColor
            titleLb.font = UIFont.systemFontOfSize(20)
            infoView?.addSubview(titleLb)
            
            
            titleLb.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.infoView!).offset(5)
                make.left.equalTo(WS.infoView!).offset(15)
                make.height.equalTo(25)
                make.width.equalTo(Constants.HDSCREENWITH-30)
                
            })
            
            createTime = UILabel()
            createTime.textColor = UIColor.lightGrayColor()
            createTime.font = UIFont.systemFontOfSize(12)
            infoView?.addSubview(createTime)
            
            
            createTime.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.titleLb.snp_bottom).offset(5)
                make.left.equalTo(WS.infoView!).offset(15)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH/2-30)
                
            })
            
            headIcon = UIImageView()
            headIcon.layer.cornerRadius = 25
            headIcon.layer.masksToBounds = true
            infoView?.addSubview(headIcon)
            
            headIcon.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.createTime.snp_bottom).offset(5)
                make.left.equalTo(WS.infoView!).offset(15)
                make.width.equalTo(50)
                make.height.equalTo(50)
            })
            
            
            viewCount = UILabel()
            viewCount.textColor = UIColor.lightGrayColor()
            viewCount.font = UIFont.systemFontOfSize(12)
            infoView?.addSubview(viewCount)
            
            
            viewCount.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.titleLb.snp_bottom).offset(5)
                make.left.equalTo(WS.infoView!).offset(Constants.HDSCREENWITH/2+20)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH/4-10)
                
            })
            
            commentCount = UILabel()
            commentCount.textColor = UIColor.lightGrayColor()
            commentCount.font = UIFont.systemFontOfSize(12)
            commentCount.userInteractionEnabled = true
            infoView?.addSubview(commentCount)
            
            commentCount.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.titleLb.snp_bottom).offset(5)
                make.left.equalTo(WS.viewCount.snp_right).offset(10)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH/4-20)
                
            })
            
            
            userName = UILabel()
            userName.textColor = Constants.HDMainTextColor
            userName.font = UIFont.systemFontOfSize(16)
            infoView?.addSubview(userName)
            
            userName.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.createTime.snp_bottom).offset(10)
                make.left.equalTo(WS.headIcon.snp_right).offset(10)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH-30)
                
            })
            
            tags = UILabel()
            tags.textColor = UIColor.lightGrayColor()
            tags.font = UIFont.systemFontOfSize(12)
            infoView?.addSubview(tags)
            
            tags.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.userName.snp_bottom).offset(5)
                make.left.equalTo(WS.headIcon.snp_right).offset(10)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH-100)
                
            })
            
            
        }
        
    }
    
    /**
     *  菜谱介绍
     */
    func createIntroView(){
        
        unowned let WS = self
        
        if introView == nil {
            
            introView = UILabel()
            introView?.textColor = Constants.HDMainTextColor
            introView?.font = UIFont.systemFontOfSize(15)
            introView?.numberOfLines = 0
            detailView?.addSubview(introView!)
            
            
            
            introView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.infoView!.snp_bottom).offset(5)
                make.left.equalTo(WS.detailView!).offset(15)
                make.width.equalTo(Constants.HDSCREENWITH-30)
                make.height.equalTo(0)
                
            })
            
            
        }
        
    }
    
    /**
     *  食材列表
     */
    func createStuffTableView(){
        
        if stuffTableView == nil {
            
            stuffTableView = UITableView()
            stuffTableView?.delegate = self
            stuffTableView?.dataSource = self
            stuffTableView?.scrollEnabled = false
            detailView?.addSubview(stuffTableView!)
            
            stuffTableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
            
            unowned let WS = self
            stuffTableView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.introView!.snp_bottom).offset(10)
                make.left.equalTo(WS.detailView!).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(0)
            })

        }
        
    }
    
    /**
     *  小贴士
     */
    
    func createTipsView(){
        
        unowned let WS = self
        if tipsView == nil {
            
            
            
            tipsView = UIView()
            detailView?.addSubview(tipsView!)
            
            tipsView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.stuffTableView!.snp_bottom).offset(0)
                make.left.equalTo(WS.detailView!).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                
            })
            
            let title = UILabel()
            title.font = UIFont.systemFontOfSize(18)
            title.text = "小贴士"
            title.textColor = UIColor.lightGrayColor()
            tipsView?.addSubview(title)
            
            title.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.tipsView!).offset(20)
                make.left.equalTo(WS.tipsView!).offset(15)
                make.width.equalTo(150)
                make.height.equalTo(20)
            })
            
            tips = UILabel()
            tips.font = UIFont.systemFontOfSize(14)
            tips.textColor = Constants.HDMainTextColor
            tips.numberOfLines = 0
            tipsView?.addSubview(tips)
            
            
            tips.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(title.snp_bottom).offset(20)
                make.left.equalTo(WS.tipsView!).offset(15)
                make.width.equalTo(Constants.HDSCREENWITH-30)
                
            })
            
            
        }
        
    }
    
    /**
     *  步骤列表
     */
    func createStepsTableView(){
        
        if stepsTableView == nil {
            
            stepsTableView = UITableView()
            stepsTableView?.delegate = self
            stepsTableView?.dataSource = self
            stepsTableView?.tableFooterView = UIView()
            stepsView?.addSubview(stepsTableView!)
            
            stepsTableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "stepsCell")
            
            stepsTableView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)
            })
            
        }
        
    }
    
    /**
     *  转菊花
     */
    func createActivityIndicatorView() {
        
        if activityIndicatorView == nil {
            
            activityIndicatorView = UIActivityIndicatorView()
            activityIndicatorView?.startAnimating()
            activityIndicatorView?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            activityIndicatorView?.center = CGPointMake(Constants.HDSCREENWITH/2, CGFloat(Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)/2)
            commentView?.addSubview(activityIndicatorView!)
            
        }
        
    }
    
    /**
     *  评论列表
     */
    func createCommentTableView(){
        
        if commentTableView == nil {
            
            commentTableView = UITableView()
            commentTableView?.delegate = self
            commentTableView?.dataSource = self
            commentTableView?.tableFooterView = UIView()
            commentView?.addSubview(commentTableView!)
            commentTableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "commentCell")
            
            commentTableView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)
            })
            
        }
        
    }
    
    /**
     *  暂无评论
     */
    
    func createNoComment() {
        
        if noComment == nil {
        
            noComment = UILabel()
            noComment?.textColor = Constants.HDMainTextColor
            noComment?.font = UIFont.systemFontOfSize(15)
            noComment?.textAlignment = NSTextAlignment.Center
            noComment?.text = "暂无评论"
            commentView?.addSubview(noComment!)
            noComment?.snp_makeConstraints(closure: { (make) in
                
                make.top.equalTo(20)
                make.left.equalTo(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(30)
            })
            
        }
        
    }
    

    /**
     *  分享视图
     */
    func createShareView(){
        
        
        if shareView == nil {
            
            shareView = UIView()
            shareView.hidden = true
            shareView.backgroundColor = CoreUtils.HDColor(0, g: 0, b: 0, a: 0.2)
            shareView.alpha = 0.0
            self.view.addSubview(shareView!)
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideShareView))
            shareView.addGestureRecognizer(tapGes)
            
            unowned let WS = self
            shareView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.view).offset(0)
                make.left.equalTo(WS.view).offset(0)
                make.bottom.equalTo(WS.view).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                
                
            })
            
            shareSubView = HDShareView()
            shareSubView.delegate = self
            shareView.addSubview(shareSubView)
            shareSubView .snp_makeConstraints(closure: { (make) in
                
                make.left.equalTo(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(shareViewHeight)
                make.top.equalTo(WS.view.bounds.size.height)
            })
            
        }
        
    }
    
    // MARK: - 分享视图显示和隐藏
    func hideShareView(){
        
        unowned let WS = self
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            WS.shareSubView.snp_updateConstraints(closure: { (make) in
                
                make.top.equalTo(WS.view.bounds.size.height)
            })
            
            WS.shareView.alpha = 0.0
            WS.view.layoutIfNeeded()
            
            }, completion: { (ret) -> Void in
                WS.shareView?.hidden = true
        })
        
    }
    
    func showShareView(){
        
        shareView?.hidden = false
        unowned let WS = self
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            WS.shareView.alpha = 1
            WS.shareSubView.snp_updateConstraints(closure: { (make) in
                
                make.top.equalTo(WS.view.bounds.size.height - shareViewHeight)
            })
            WS.view.layoutIfNeeded()
        })
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
    
    // MARK: - 计算cell的高度
    func getRowHeight(){
    
        if commentList.count > 0 {
            
            for i in 0..<commentList.count {
                
                let model = commentList[i]
                
                let contentRect = CoreUtils.getTextRectSize(model.content!, font: UIFont.systemFontOfSize(14), size: CGSizeMake(Constants.HDSCREENWITH-80, 9999))
                model.contentHeight = contentRect.size.height + 3.0;
                
                
                if model.atUserId > 0 {
                    
                    let atContentRect = CoreUtils.getTextRectSize(model.atContent!, font: UIFont.systemFontOfSize(13), size: CGSizeMake(Constants.HDSCREENWITH-110, 9999))
                    model.atContentHeight = atContentRect.size.height + 3.0
                    
                    model.rowHeight = 95.0 + model.contentHeight! + model.atContentHeight!
                    
                }else{
                
                    model.rowHeight = 55.0 + model.contentHeight!
                }

                
            }
            
            
        }
        
    }
    /**
     *  菜谱分享
     */
    func shareAction(tag:Int){
        
        hideShareView()
        
        let url = String(format: "http://m.haodou.com/recipe/%d?device=iphone&hash=7408f5dd81db1165cd1896e8175a75e4&siteid=1004&appinstall=0", (listModel?.data?.id!)!)
        
        switch tag {
            
        case 0:
            /**
             *  微信好友
             */
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: (videoPlayerController?.movieBackgroundView.image)!, type: SSDKPlatformType.SubTypeWechatSession, url: url, shareSuccess: { () -> Void in
                
                CoreUtils.showSuccessHUD(self.view, title: "分享成功")
                HDLog.LogOut("成功")
                }, shareFail: { () -> Void in
                    HDLog.LogOut("失败")
                    CoreUtils.showWarningHUD(self.view, title: "分享失败")
                }, shareCancel: { () -> Void in
                    HDLog.LogOut("取消")
            })
            
            break
        case 1:
            /**
             *  微信朋友圈
             */
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: (videoPlayerController?.movieBackgroundView.image)!, type: SSDKPlatformType.SubTypeWechatTimeline, url: url, shareSuccess: { () -> Void in
                
                CoreUtils.showSuccessHUD(self.view, title: "分享成功")
                HDLog.LogOut("成功")
                }, shareFail: { () -> Void in
                    HDLog.LogOut("失败")
                    CoreUtils.showWarningHUD(self.view, title: "分享失败")
                }, shareCancel: { () -> Void in
                    HDLog.LogOut("取消")
            })
            
            
            break
        case 2:
            /**
             *  QQ
             */
            
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: UIImage(data: UIImageJPEGRepresentation((videoPlayerController?.movieBackgroundView.image)!, 0.3)!)!, type: SSDKPlatformType.SubTypeQQFriend, url: url, shareSuccess: { () -> Void in
                
                CoreUtils.showSuccessHUD(self.view, title: "分享成功")
                HDLog.LogOut("成功")
                }, shareFail: { () -> Void in
                    HDLog.LogOut("失败")
                    CoreUtils.showWarningHUD(self.view, title: "分享失败")
                }, shareCancel: { () -> Void in
                    HDLog.LogOut("取消")
            })
            
            
            break
        case 3:
            /**
             *  QQ空间
             */
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: UIImage(data: UIImageJPEGRepresentation((videoPlayerController?.movieBackgroundView.image)!, 0.3)!)!, type: SSDKPlatformType.SubTypeQZone, url: url, shareSuccess: { () -> Void in
                
                CoreUtils.showSuccessHUD(self.view, title: "分享成功")
                HDLog.LogOut("成功")
                }, shareFail: { () -> Void in
                    HDLog.LogOut("失败")
                    CoreUtils.showWarningHUD(self.view, title: "分享失败")
                }, shareCancel: { () -> Void in
                    HDLog.LogOut("取消")
            })
            
            break
        case 4:
            /**
             *   取消
             */
            break
        default:
            ""
            
        }
        
    }
    
    // MARK: - 滚动下滑条
    func scrollLine(index:Int)  {
        
        
        for view in (menuView?.subviews)! {
            
            if view.isMemberOfClass(UIButton.classForCoder()) {
                
                let btn = view as! UIButton
                btn.setTitleColor(Constants.HDMainTextColor, forState: UIControlState.Normal)
                
            }
            
        }
        
        var btn:UIButton?
        
        if index == 0 {
            
            btn = menuView?.viewWithTag(2016) as? UIButton
            
        }else if index == 1{
        
            btn = menuView?.viewWithTag(2017) as? UIButton
        }else if index == 2 {
        
            btn = menuView?.viewWithTag(2018) as? UIButton
        }
        
        btn!.setTitleColor(Constants.HDMainColor, forState: UIControlState.Normal)
        
        unowned let WS = self
        UIView.animateWithDuration(0.3) { 
            WS.menuLineView?.frame = CGRectMake(CGFloat(index)*(40+2*lineSpace)+lineSpace,40-3,lineWith,3)
        }
        
    }
    
    // MARK: - 滚动视图
    func scrollViewToScroll(index:Int) {
        
        //滚动时有动画
        scrollView?.setContentOffset(CGPointMake(CGFloat(index) * Constants.HDSCREENWITH, 0), animated: true)
        
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
    
    /**
     *  查看评论
     */
    func commentAction(){
        
        let hd10VC = HDHM10Controller()
        hd10VC.rid =  listModel!.data?.id
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hd10VC, animated: true)
    }
    
    //显示/隐藏分享视图
    func share(){
        
        if (shareView.hidden) {
            
            showShareView()
            
        }else{
            
            hideShareView()
            
        }
        
    }
    
    func menuAction(btn:UIButton) {
        
        
        switch btn.tag {
        case 2016:
            /**
             *  详情
             */
            scrollLine(0)
            scrollViewToScroll(0)
            break
        case 2017:
            /**
             *  步骤
             */
            scrollLine(1)
            scrollViewToScroll(1)
            break
        case 2018:
            /**
             *  评论
             */
            scrollLine(2)
            scrollViewToScroll(2)
            if !isCommentLoadIng {
                isCommentLoadIng = true
                doGetCommentList()
            }
            break
        default:
            ""
        }
        
    }
    
    // MARK: - 加载数据 刷新UI
    func refreshUI() {
        
        tags.text = "美食明星、生活联盟"
        userName.text = dy02Info?.userInfo?.userName
        commentCount.text = String(format: "评论:%d", (listModel?.data?.commentCnt)!)
        viewCount.text = String(format: "浏览:%ld", (dy02Info?.viewCount)!)
        headIcon.sd_setImageWithURL(NSURL(string: (dy02Info?.userInfo?.avatar)!), placeholderImage: UIImage(named: "defaultIcon"))
        titleLb.text = dy02Info?.title
        createTime.text = String(format: "创建日期:%@", (dy02Info?.reviewTime)!)
        
        let size = CoreUtils.getTextRectSize((dy02Info?.intro!)!, font: UIFont.systemFontOfSize(15), size: CGSizeMake(Constants.HDSCREENWITH-30, 99999))
        introView?.text = dy02Info?.intro!
        introView?.snp_updateConstraints(closure: { (make) in
            
            make.height.equalTo(size.size.height + 10)
        })
        
        let stuffHeight = (dy02Info?.stuff?.count)!*44+30+44
        stuffTableView?.snp_updateConstraints(closure: { (make) in
            
            make.height.equalTo(stuffHeight)
        })
        
        let tipsSize = CoreUtils.getTextRectSize((dy02Info?.tips!)!, font: UIFont.systemFontOfSize(15), size: CGSizeMake(Constants.HDSCREENWITH-30, 99999))
        tips.text = dy02Info?.tips!
        
        tipsView?.snp_updateConstraints(closure: { (make) in
            make.height.equalTo(60+tipsSize.size.height+5)
        })
        tips.snp_updateConstraints { (make) in
            make.height.equalTo(tipsSize.size.height+5)
        }
        
        detailView!.contentSize = CGSizeMake(Constants.HDSCREENWITH, 110 + size.size.height + 40 + CGFloat(stuffHeight)+60.0+tipsSize.size.height+5)
    }
    
    // MARK: - 数据加载
    func doGetRequestData(){
        
        unowned let WS = self
        HDDY02Service().doGetRequest_HDDY0201_URL((listModel?.data?.id)!, successBlock: { (hdResponse) -> Void in
            
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
            
            
            WS.createStuffTableView()
            WS.createTipsView()
            WS.createStepsTableView()
            WS.refreshUI()
            
            
        }) { (error) -> Void in
            
            WS.hidenHud()
            CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }
    
    func doGetCommentList() {
        
        unowned let WS = self
        HDDY02Service().doGetRequest_HDDY0202_URL(30, offset: 0, rid: (listModel?.data?.id)!, successBlock: { (hdResponse) in
            
            
            if hdResponse.result?.list?.count > 0{
                
                WS.commentList = (hdResponse.result?.list)!
                WS.getRowHeight()
                WS.activityIndicatorView?.stopAnimating()
                WS.createCommentTableView()
                
            }else{
            
                WS.activityIndicatorView?.stopAnimating()
                WS.createNoComment()
            }
            
            }) { (error) in
                WS.activityIndicatorView?.stopAnimating()
                CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }
    
    // MARK: - HDShareViewDelegate delegate
    func didShareWithType(type:Int){
    
        hideShareView()
        
        let url = String(format: "http://m.haodou.com/recipe/%d?device=iphone&hash=7408f5dd81db1165cd1896e8175a75e4&siteid=1004&appinstall=0", (listModel?.data?.id!)!)
        
        switch type {
            
        case 0:
            /**
             *  微信好友
             */
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: (videoPlayerController?.movieBackgroundView.image)!, type: SSDKPlatformType.SubTypeWechatSession, url: url, shareSuccess: { () -> Void in
                
                CoreUtils.showSuccessHUD(self.view, title: "分享成功")
                HDLog.LogOut("成功")
                }, shareFail: { () -> Void in
                    HDLog.LogOut("失败")
                    CoreUtils.showWarningHUD(self.view, title: "分享失败")
                }, shareCancel: { () -> Void in
                    HDLog.LogOut("取消")
            })
            
            break
        case 1:
            /**
             *  微信朋友圈
             */
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: (videoPlayerController?.movieBackgroundView.image)!, type: SSDKPlatformType.SubTypeWechatTimeline, url: url, shareSuccess: { () -> Void in
                
                CoreUtils.showSuccessHUD(self.view, title: "分享成功")
                HDLog.LogOut("成功")
                }, shareFail: { () -> Void in
                    HDLog.LogOut("失败")
                    CoreUtils.showWarningHUD(self.view, title: "分享失败")
                }, shareCancel: { () -> Void in
                    HDLog.LogOut("取消")
            })
            
            
            break
        case 2:
            /**
             *  QQ
             */
            
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: UIImage(data: UIImageJPEGRepresentation((videoPlayerController?.movieBackgroundView.image)!, 0.3)!)!, type: SSDKPlatformType.SubTypeQQFriend, url: url, shareSuccess: { () -> Void in
                
                CoreUtils.showSuccessHUD(self.view, title: "分享成功")
                HDLog.LogOut("成功")
                }, shareFail: { () -> Void in
                    HDLog.LogOut("失败")
                    CoreUtils.showWarningHUD(self.view, title: "分享失败")
                }, shareCancel: { () -> Void in
                    HDLog.LogOut("取消")
            })
            
            
            break
        case 3:
            /**
             *  QQ空间
             */
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: UIImage(data: UIImageJPEGRepresentation((videoPlayerController?.movieBackgroundView.image)!, 0.3)!)!, type: SSDKPlatformType.SubTypeQZone, url: url, shareSuccess: { () -> Void in
                
                CoreUtils.showSuccessHUD(self.view, title: "分享成功")
                HDLog.LogOut("成功")
                }, shareFail: { () -> Void in
                    HDLog.LogOut("失败")
                    CoreUtils.showWarningHUD(self.view, title: "分享失败")
                }, shareCancel: { () -> Void in
                    HDLog.LogOut("取消")
            })
            
            break
        case 4:
            /**
             *   取消
             */
            break
        default:
            ""
            
        }
        
    }
    
    // MARK: - HDVideoPlayerController delegate
    func didFullScreen() {
        
        scrollView?.hidden = true
        menuView?.hidden = true
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    func didshrinkScreen() {
        
        scrollView?.hidden = false
        menuView?.hidden = false
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - UIScrollView delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    
        if scrollView == self.scrollView {
            let index = Int(scrollView.contentOffset.x/Constants.HDSCREENWITH)
            scrollLine(index)
            if index == 2 {
                if !isCommentLoadIng {
                    isCommentLoadIng = true
                    doGetCommentList()
                }
            }
        }
        
        
    }
    
    // MARK: - UITableView delegate/datasource
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        if stuffTableView == tableView {
            
            return (dy02Info?.stuff?.count)!+1
        }else if stepsTableView == tableView {
            
            return (dy02Info?.steps?.count)!
        }else{
        
            return commentList.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        
        
        
        if stuffTableView == tableView {
            
            let cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
            
            /**
             *   食材
             */
            
            
            if indexPath.row == (dy02Info?.stuff?.count)! {
                let title = UILabel()
                title.font = UIFont.systemFontOfSize(15)
                cell.contentView.addSubview(title)
                
                title.snp_makeConstraints(closure: { (make) -> Void in
                    make.top.equalTo(cell.contentView).offset(0)
                    make.left.equalTo(cell.contentView).offset(15)
                    make.height.equalTo(44)
                    make.width.equalTo(Constants.HDSCREENWITH-30)
                })
                
                title.textColor = Constants.HDMainTextColor
                title.text = String(format: "制作时间:%@ ", (dy02Info?.readyTime)!)
            }else{
                
                
                let title = UILabel()
                title.font = UIFont.systemFontOfSize(15)
                cell.contentView.addSubview(title)
                
                title.snp_makeConstraints(closure: { (make) -> Void in
                    make.top.equalTo(cell.contentView).offset(0)
                    make.left.equalTo(cell.contentView).offset(15)
                    make.height.equalTo(44)
                    make.width.equalTo(Constants.HDSCREENWITH/2-15)
                })
                
                let weight = UILabel()
                weight.textColor = UIColor.lightGrayColor()
                weight.font = UIFont.systemFontOfSize(15)
                cell.contentView.addSubview(weight)
                
                weight.snp_makeConstraints(closure: { (make) -> Void in
                    make.top.equalTo(cell.contentView).offset(0)
                    make.left.equalTo(title.snp_right).offset(30)
                    make.height.equalTo(44)
                    make.width.equalTo(Constants.HDSCREENWITH/2-30)
                })
                
                
                title.textColor = UIColor.lightGrayColor()
                let model = dy02Info!.stuff![indexPath.row]
                title.text = model.name
                weight.text = model.weight
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
            
        }else if  stepsTableView == tableView {
            /**
             *   步骤
             */
            
            let cell = tableView.dequeueReusableCellWithIdentifier("stepsCell", forIndexPath: indexPath)
            
            let model = dy02Info?.steps![indexPath.row]
            
            var index = cell.contentView.viewWithTag(1000) as? UILabel
            if index == nil {
                
                index = UILabel()
                index?.tag = 1000
                index?.textColor = Constants.HDYellowColor
                index?.textAlignment = NSTextAlignment.Center
                index?.font = UIFont.systemFontOfSize(15)
                cell.contentView.addSubview(index!)
                
                index?.snp_makeConstraints(closure: { (make) in
                    
                    make.left.equalTo(15)
                    make.top.equalTo(15)
                    make.width.equalTo(20)
                    make.height.equalTo(30)
                    
                })
                
            }
            
            var stuff = cell.contentView.viewWithTag(2000) as? UILabel
            
            if stuff == nil {
                
                stuff = UILabel()
                stuff?.tag = 2000
                stuff?.numberOfLines = 2
                stuff?.textColor = Constants.HDMainTextColor
                stuff?.font = UIFont.systemFontOfSize(14)
                cell.contentView.addSubview(stuff!)
                
                stuff?.snp_makeConstraints(closure: { (make) in
                    
                    make.left.equalTo(index!.snp_right).offset(5)
                    make.top.equalTo(10)
                    make.width.equalTo(Constants.HDSCREENWITH - 60)
                    make.height.equalTo(40)
                    
                })
                
            }
            
            
            stuff?.text = model!.intro
            index?.text = String(format: "%d", indexPath.row+1)
            
//            let introSize = CoreUtils.getTextRectSize(String(format: "%d.%@",indexPath.row+1, model!.intro!), font: UIFont.systemFontOfSize(16), size:CGSizeMake(Constants.HDSCREENWITH-120, 99999))
            
          
            
            return cell
        }else{
            
            /**
             *   评论
             */
            let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
        
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            let model = commentList[indexPath.row]
            
            /**
             *   头像
             */
            
            var icon = cell.contentView.viewWithTag(1000) as? UIImageView
            
            if icon == nil {
                
                icon = UIImageView()
                icon?.tag = 1000
                icon?.layer.cornerRadius = 12.5
                icon?.layer.masksToBounds = true
                cell.contentView.addSubview(icon!)
                
                icon?.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.top.equalTo(cell.contentView).offset(10)
                    make.left.equalTo(cell.contentView).offset(15)
                    make.width.equalTo(25)
                    make.height.equalTo(25)
                    
                    
                })
                
            }
            
            /**
             *   昵称
             */
            
            var username = cell.contentView.viewWithTag(2000) as? UILabel
            
            if username == nil {
                
                username = UILabel()
                username?.tag = 2000
                username?.font = UIFont.systemFontOfSize(13)
                username?.textColor = Constants.HDMainTextColor
                cell.contentView.addSubview(username!)
                
                username?.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.top.equalTo(cell.contentView).offset(10)
                    make.left.equalTo(icon!.snp_right).offset(5)
                    make.width.equalTo(200)
                    make.height.equalTo(15)
                })
                
            }
            
            
            /**
             *   发表时间
             */
            
            var createTime = cell.contentView.viewWithTag(3000) as? UILabel
            
            if createTime == nil {
                
                createTime = UILabel()
                createTime?.tag = 3000
                createTime?.font = UIFont.systemFontOfSize(10)
                createTime?.textColor = UIColor.lightGrayColor()
                cell.contentView.addSubview(createTime!)
                
                createTime?.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.top.equalTo(username!.snp_bottom).offset(0)
                    make.left.equalTo(icon!.snp_right).offset(5)
                    make.width.equalTo(200)
                    make.height.equalTo(15)
                })
                
            }
            
            /**
             *   内容
             */
            
            var content = cell.contentView.viewWithTag(4000) as? UILabel
            
            if content == nil {
                
                content = UILabel()
                content?.tag = 4000
                content?.font = UIFont.systemFontOfSize(14)
                content?.textColor = CoreUtils.HDColor(130, g: 130, b: 130, a: 1)
                content?.numberOfLines = 0
                cell.contentView.addSubview(content!)
                
                content?.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.top.equalTo(icon!.snp_bottom).offset(5)
                    make.left.equalTo(icon!.snp_right).offset(5)
                    make.width.equalTo(Constants.HDSCREENWITH-80)
                    make.height.equalTo(0)
                })
                
            }

            //评论视图
            var commentView = cell.contentView.viewWithTag(5000)
            
            if commentView == nil {
                
                commentView = UIView()
                commentView?.tag = 5000
                commentView?.layer.cornerRadius = 5
                commentView?.layer.masksToBounds = true
                commentView?.backgroundColor = CoreUtils.HDColor(249, g: 249, b: 249, a: 1)
                cell.contentView.addSubview(commentView!)
                
                commentView?.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.top.equalTo(content!.snp_bottom).offset(5)
                    make.left.equalTo(icon!.snp_right).offset(5)
                    make.width.equalTo(Constants.HDSCREENWITH - 60)
                    make.height.equalTo(0);
                    
                })
                
            }
            
            //回复对象
            var atUsername = commentView!.viewWithTag(6000) as? UILabel
            
            if atUsername == nil {
                
                atUsername = UILabel()
                atUsername?.tag = 6000
                atUsername?.font = UIFont.systemFontOfSize(13)
                atUsername?.textColor = Constants.HDMainTextColor
                commentView!.addSubview(atUsername!)
                
                atUsername?.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.top.equalTo(10)
                    make.left.equalTo(10)
                    make.width.equalTo(Constants.HDSCREENWITH - 100.0)
                    make.height.equalTo(15)
                })

            }
            
            //回复内容
            var atContent = commentView!.viewWithTag(7000) as? UILabel

            if atContent == nil {
                
                atContent = UILabel()
                atContent?.tag = 7000
                atContent?.font = UIFont.systemFontOfSize(13)
                atContent?.textColor = CoreUtils.HDColor(130, g: 130, b: 130, a: 1)
                atContent?.numberOfLines = 0
                commentView!.addSubview(atContent!)
                
                atContent?.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.top.equalTo(atUsername!.snp_bottom).offset(0)
                    make.left.equalTo(10)
                    make.width.equalTo(Constants.HDSCREENWITH-110)
                    make.height.equalTo(0)
                })
                
            }

            
            content?.snp_updateConstraints(closure: { (make) in
                make.height.equalTo(model.contentHeight!)
            })
            
            if model.atUserId > 0 {
                
                atUsername?.text = String(format: "回复：%@",model.atUserName!)
                atContent?.text = model.atContent
                
                commentView?.hidden = false
                
                commentView?.snp_updateConstraints(closure: { (make) in
                    make.height.equalTo(35.0 + model.atContentHeight!);
                })
                atContent?.snp_updateConstraints(closure: { (make) in
                    
                    make.height.equalTo(model.atContentHeight!)
                })
                
            }else{
            
                commentView?.hidden = true
            }
            
            icon?.sd_setImageWithURL(NSURL(string: (model.avatar)!), placeholderImage: UIImage(imageLiteral: "defaultIcon"))
            username?.text = model.userName
            createTime?.text = model.createTime
            content?.text = model.content
            
            return cell
        }
        
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRectMake(0,0,Constants.HDSCREENWITH,30))
        
        if stuffTableView == tableView {
            
            let title = UILabel(frame: CGRectMake(15,0,Constants.HDSCREENWITH-15,30))
            title.textColor = UIColor.lightGrayColor()
            title.font = UIFont.systemFontOfSize(15)
            view.addSubview(title)
            
            title.text = "食材"
        }
        
        return view
    }
   
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == stuffTableView {
            return CGFloat(Constants.HDSpace*3)
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if stuffTableView == tableView {
            
            return 44
        }else if stepsTableView == tableView {
            
            return 60
        }else{
        
            let model = commentList[indexPath.row]
            return model.rowHeight!
        }
        
    }

}
