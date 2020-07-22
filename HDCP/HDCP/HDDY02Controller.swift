//
//  HDDY02Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/4/1.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


private let shareViewHeight = CGFloat(255)
private let titleArray = ["详情", "步骤", "评论"]
private let lineWith: CGFloat = 40
private let lineSpace: CGFloat = Constants.HDSCREENWITH / 6 - lineWith / 2


class HDDY02Controller: UIViewController, HDVideoPlayerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, HDShareViewDelegate {

    var listModel: HDDY01ListModel?
    var dy02Info: HDDY02InfoModel?
    var vedioHeight: CGFloat?
    var commentList = Array<HDDY0202ListModel>()

    //视频播放视图
    var videoPlayerController: HDVideoPlayerController?
    //滚动条
    var menuView: UIView?
    var menuLineView: UIView?

    var scrollView: UIScrollView!

    //详情
    var detailView: UIScrollView?
    //步骤
    var stepsView: UIScrollView?
    //评论
    var commentView: UIScrollView?

    //个人信息视图
    var infoView: UIView?
    var titleLb: UILabel!
    var createTime: UILabel!
    var headIcon: UIImageView!
    var viewCount: UILabel!
    var commentCount: UILabel!
    var userName: UILabel!
    var tags: UILabel!

    //简介
    var introView: UILabel?
    //食材
    var stuffTableView: UITableView?
    //小贴士
    var tipsView: UIView?
    var tips: UILabel!

    //步骤
    var stepsTableView: UITableView?

    //评论
    var commentTableView: UITableView?
    var activityIndicatorView: UIActivityIndicatorView?
    var isCommentLoadIng = false
    var noComment: UILabel?

    //分享
    var shareView: UIView!
    var shareSubView: HDShareView!

    override func viewDidLoad() {
        super.viewDidLoad()

        showHud()
        setupUI()
        doGetRequestData()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.title = listModel?.data?.title
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)

        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setBackgroundImage(UIImage(named: "shareIcon"), for: UIControl.State())
        button.addTarget(self, action: #selector(share), for: UIControl.Event.touchUpInside)
        button.contentMode = UIView.ContentMode.scaleToFill
        let rightItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightItem

    }

    deinit {

        videoPlayerController = nil
        HDLog.LogClassDestory("HDDY02Controller")
    }

    // MARK: - 创建UI视图
    func setupUI() {

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
    func createHDVedioPlayerView() {

        if videoPlayerController == nil {

            if Constants.HDSCREENWITH > 375.0 {

                //适配6P
                vedioHeight = 220.0
                videoPlayerController = HDVideoPlayerController(frame: CGRect(x: 0, y: 0, width: Constants.HDSCREENWITH, height: vedioHeight!))

            } else if Constants.HDSCREENWITH == 375.0 {

                //适配6
                vedioHeight = 200.0
                videoPlayerController = HDVideoPlayerController(frame: CGRect(x: 0, y: 0, width: Constants.HDSCREENWITH, height: vedioHeight!))

            } else {

                //适配4,5
                vedioHeight = 180.0
                videoPlayerController = HDVideoPlayerController(frame: CGRect(x: 0, y: 0, width: Constants.HDSCREENWITH, height: vedioHeight!))
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
            menuView?.snp.makeConstraints( { (make) in

                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(40)
                make.top.equalTo(WS.vedioHeight!)
                make.left.equalTo(0)

            })

            let line = UILabel()
            line.backgroundColor = Constants.HDBGViewColor
            menuView?.addSubview(line)
            line.snp.makeConstraints( { (make) in

                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(1)
                make.bottom.equalTo(0)
                make.left.equalTo(0)
            })

            let btnWith: CGFloat = Constants.HDSCREENWITH / 3


            for i in 0..<titleArray.count {

                let btn = UIButton(type: UIButton.ButtonType.custom)
                btn .setTitle(titleArray[i], for: UIControl.State())
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                btn.tag = 2016 + i
                btn.addTarget(self, action: #selector(menuAction(_:)), for: UIControl.Event.touchUpInside)
                btn.setTitleColor(Constants.HDMainTextColor, for: UIControl.State.normal)
                menuView?.addSubview(btn)

                if i == 0 {
                    btn.setTitleColor(Constants.HDMainColor, for: UIControl.State.normal)
                }
                btn.snp.makeConstraints( { (make) in

                    make.top.equalTo(0)
                    make.left.equalTo(CGFloat(i) * btnWith)
                    make.width.equalTo(btnWith)
                    make.height.equalTo(40)

                })


            }

            menuLineView = UIView(frame: CGRect(x: lineSpace, y: 40 - 3, width: lineWith, height: 3))
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
            scrollView?.contentSize = CGSize(width: 3 * Constants.HDSCREENWITH, height: Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)
            scrollView?.isPagingEnabled = true
            scrollView?.showsHorizontalScrollIndicator = false
            self.view.addSubview(scrollView!)
            unowned let WS = self
            scrollView?.snp.makeConstraints( { (make) in

                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)
                make.top.equalTo(WS.menuView!.snp.bottom).offset(0)
                make.left.equalTo(0)

            })

            //兼容IOS11
            if #available(iOS 11.0, *) {
                scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
            }
            
            detailView = UIScrollView()
            scrollView?.addSubview(detailView!)
            detailView!.snp.makeConstraints( { (make) in

                make.width.equalTo(Constants.HDSCREENWITH)
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.height.equalTo(Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)

            })


            stepsView = UIScrollView()
            stepsView?.contentSize = CGSize(width: Constants.HDSCREENWITH, height: Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)
            scrollView?.addSubview(stepsView!)
            stepsView!.snp.makeConstraints( { (make) in

                make.width.equalTo(Constants.HDSCREENWITH)
                make.top.equalTo(0)
                make.left.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)

            })

            commentView = UIScrollView()
            commentView?.contentSize = CGSize(width: Constants.HDSCREENWITH, height: Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)
            scrollView?.addSubview(commentView!)
            commentView!.snp.makeConstraints( { (make) in

                make.width.equalTo(Constants.HDSCREENWITH)
                make.top.equalTo(0)
                make.left.equalTo(CGFloat(2) * Constants.HDSCREENWITH)
                make.height.equalTo(Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64)

            })

        }

    }

    /**
     *  个人信息
     */
    func createInfoView() {

        unowned let WS = self

        if infoView == nil {

            infoView = UIView()
            detailView?.addSubview(infoView!)


            infoView?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(Constants.HDSpace)
                make.left.equalTo(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(110)

            })


            titleLb = UILabel()
            titleLb.textColor = Constants.HDMainTextColor
            titleLb.font = UIFont.systemFont(ofSize: 20)
            infoView?.addSubview(titleLb)


            titleLb.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.infoView!).offset(5)
                make.left.equalTo(WS.infoView!).offset(15)
                make.height.equalTo(25)
                make.width.equalTo(Constants.HDSCREENWITH - 30)

            })

            createTime = UILabel()
            createTime.textColor = UIColor.lightGray
            createTime.font = UIFont.systemFont(ofSize: 12)
            infoView?.addSubview(createTime)


            createTime.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.titleLb.snp.bottom).offset(5)
                make.left.equalTo(WS.infoView!).offset(15)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH / 2 - 30)

            })

            headIcon = UIImageView()
            headIcon.layer.cornerRadius = 25
            headIcon.layer.masksToBounds = true
            infoView?.addSubview(headIcon)

            headIcon.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.createTime.snp.bottom).offset(5)
                make.left.equalTo(WS.infoView!).offset(15)
                make.width.equalTo(50)
                make.height.equalTo(50)
            })


            viewCount = UILabel()
            viewCount.textColor = UIColor.lightGray
            viewCount.font = UIFont.systemFont(ofSize: 12)
            infoView?.addSubview(viewCount)


            viewCount.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.titleLb.snp.bottom).offset(5)
                make.left.equalTo(WS.infoView!).offset(Constants.HDSCREENWITH / 2 + 20)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH / 4 - 10)

            })

            commentCount = UILabel()
            commentCount.textColor = UIColor.lightGray
            commentCount.font = UIFont.systemFont(ofSize: 12)
            commentCount.isUserInteractionEnabled = true
            infoView?.addSubview(commentCount)

            commentCount.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.titleLb.snp.bottom).offset(5)
                make.left.equalTo(WS.viewCount.snp.right).offset(10)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH / 4 - 20)

            })


            userName = UILabel()
            userName.textColor = Constants.HDMainTextColor
            userName.font = UIFont.systemFont(ofSize: 16)
            infoView?.addSubview(userName)

            userName.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.createTime.snp.bottom).offset(10)
                make.left.equalTo(WS.headIcon.snp.right).offset(10)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH - 30)

            })

            tags = UILabel()
            tags.textColor = UIColor.lightGray
            tags.font = UIFont.systemFont(ofSize: 12)
            infoView?.addSubview(tags)

            tags.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.userName.snp.bottom).offset(5)
                make.left.equalTo(WS.headIcon.snp.right).offset(10)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH - 100)

            })


        }

    }

    /**
     *  菜谱介绍
     */
    func createIntroView() {

        unowned let WS = self

        if introView == nil {

            introView = UILabel()
            introView?.textColor = Constants.HDMainTextColor
            introView?.font = UIFont.systemFont(ofSize: 15)
            introView?.numberOfLines = 0
            detailView?.addSubview(introView!)



            introView?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.infoView!.snp.bottom).offset(5)
                make.left.equalTo(WS.detailView!).offset(15)
                make.width.equalTo(Constants.HDSCREENWITH - 30)
                make.height.equalTo(0)

            })


        }

    }

    /**
     *  食材列表
     */
    func createStuffTableView() {

        if stuffTableView == nil {

            stuffTableView = UITableView()
            stuffTableView?.delegate = self
            stuffTableView?.dataSource = self
            stuffTableView?.isScrollEnabled = false
            detailView?.addSubview(stuffTableView!)

            stuffTableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")

            unowned let WS = self
            stuffTableView?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.introView!.snp.bottom).offset(10)
                make.left.equalTo(WS.detailView!).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(0)
            })

        }

    }

    /**
     *  小贴士
     */

    func createTipsView() {

        unowned let WS = self
        if tipsView == nil {



            tipsView = UIView()
            detailView?.addSubview(tipsView!)

            tipsView?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.stuffTableView!.snp.bottom).offset(0)
                make.left.equalTo(WS.detailView!).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)

            })

            let title = UILabel()
            title.font = UIFont.systemFont(ofSize: 18)
            title.text = "小贴士"
            title.textColor = UIColor.lightGray
            tipsView?.addSubview(title)

            title.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.tipsView!).offset(20)
                make.left.equalTo(WS.tipsView!).offset(15)
                make.width.equalTo(150)
                make.height.equalTo(20)
            })

            tips = UILabel()
            tips.font = UIFont.systemFont(ofSize: 14)
            tips.textColor = Constants.HDMainTextColor
            tips.numberOfLines = 0
            tipsView?.addSubview(tips)


            tips.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(title.snp.bottom).offset(20)
                make.left.equalTo(WS.tipsView!).offset(15)
                make.width.equalTo(Constants.HDSCREENWITH - 30)

            })


        }

    }

    /**
     *  步骤列表
     */
    func createStepsTableView() {

        if stepsTableView == nil {

            stepsTableView = UITableView()
            stepsTableView?.delegate = self
            stepsTableView?.dataSource = self
            stepsTableView?.tableFooterView = UIView()
            stepsView?.addSubview(stepsTableView!)

            stepsTableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "stepsCell")

            stepsTableView?.snp.makeConstraints( { (make) -> Void in

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
            activityIndicatorView?.style = UIActivityIndicatorView.Style.gray
            activityIndicatorView?.center = CGPoint(x: Constants.HDSCREENWITH / 2, y: CGFloat(Constants.HDSCREENHEIGHT - vedioHeight! - 40 - 64) / 2)
            commentView?.addSubview(activityIndicatorView!)

        }

    }

    /**
     *  评论列表
     */
    func createCommentTableView() {

        if commentTableView == nil {

            commentTableView = UITableView()
            commentTableView?.delegate = self
            commentTableView?.dataSource = self
            commentTableView?.tableFooterView = UIView()
            commentView?.addSubview(commentTableView!)
            commentTableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "commentCell")

            commentTableView?.snp.makeConstraints( { (make) -> Void in

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
            noComment?.font = UIFont.systemFont(ofSize: 15)
            noComment?.textAlignment = NSTextAlignment.center
            noComment?.text = "暂无评论"
            commentView?.addSubview(noComment!)
            noComment?.snp.makeConstraints( { (make) in

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
    func createShareView() {


        if shareView == nil {

            shareView = UIView()
            shareView.isHidden = true
            shareView.backgroundColor = CoreUtils.HDColor(0, g: 0, b: 0, a: 0.2)
            shareView.alpha = 0.0
            self.view.addSubview(shareView!)
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideShareView))
            shareView.addGestureRecognizer(tapGes)

            unowned let WS = self
            shareView?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.view).offset(0)
                make.left.equalTo(WS.view).offset(0)
                make.bottom.equalTo(WS.view).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)


            })

            shareSubView = HDShareView()
            shareSubView.delegate = self
            shareView.addSubview(shareSubView)
            shareSubView .snp.makeConstraints( { (make) in

                make.left.equalTo(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(shareViewHeight)
                make.top.equalTo(WS.view.bounds.size.height)
            })

        }

    }

    // MARK: - 分享视图显示和隐藏
    @objc func hideShareView() {

        unowned let WS = self
        UIView.animate(withDuration: 0.3, animations: { () -> Void in

            WS.shareSubView.snp.updateConstraints({ (make) in

                make.top.equalTo(WS.view.bounds.size.height)
            })

            WS.shareView.alpha = 0.0
            WS.view.layoutIfNeeded()

        }, completion: { (ret) -> Void in
            WS.shareView?.isHidden = true
        })

    }

    func showShareView() {

        shareView?.isHidden = false
        unowned let WS = self
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            WS.shareView.alpha = 1
            WS.shareSubView.snp.updateConstraints({ (make) in

                make.top.equalTo(WS.view.bounds.size.height - shareViewHeight)
            })
            WS.view.layoutIfNeeded()
        })
    }

    // MARK: - 获取视频地址
    func getVedioUrl(_ str: String) -> String {

        var vedioUrl = ""
        if str.count > 0 {

            let arrayStr = str.components(separatedBy: "/l/")[1]
            let str = arrayStr.components(separatedBy: "_")[0]
            vedioUrl = String(format: "http://v.hoto.cn/%@.mp4", str)

        }

        return vedioUrl
    }

    // MARK: - 计算cell的高度
    func getRowHeight() {

        if commentList.count > 0 {

            for i in 0..<commentList.count {

                let model = commentList[i]

                let contentRect = CoreUtils.getTextRectSize(model.content! as NSString, font: UIFont.systemFont(ofSize: 14), size: CGSize(width: Constants.HDSCREENWITH - 80, height: 9999))
                model.contentHeight = contentRect.size.height + 3.0;


                if model.atUserId > 0 {

                    let atContentRect = CoreUtils.getTextRectSize(model.atContent! as NSString, font: UIFont.systemFont(ofSize: 13), size: CGSize(width: Constants.HDSCREENWITH - 110, height: 9999))
                    model.atContentHeight = atContentRect.size.height + 3.0

                    model.rowHeight = 95.0 + model.contentHeight! + model.atContentHeight!

                } else {

                    model.rowHeight = 55.0 + model.contentHeight!
                }


            }


        }

    }
    /**
     *  菜谱分享
     */
    func shareAction(_ tag: Int) {

        hideShareView()

        let url = String(format: "http://m.haodou.com/recipe/%d?device=iphone&hash=7408f5dd81db1165cd1896e8175a75e4&siteid=1004&appinstall=0", (listModel?.data?.id!)!)
        let  sImage = videoPlayerController?.movieBackgroundView.image?.jpegData(compressionQuality: 0.3) as! UIImage
        switch tag {

        case 0:
            /**
             *  微信好友
             */
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: (videoPlayerController?.movieBackgroundView.image)!, type: SSDKPlatformType.subTypeWechatSession, url: url, shareSuccess: { () -> Void in

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
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: (videoPlayerController?.movieBackgroundView.image)!, type: SSDKPlatformType.subTypeWechatTimeline, url: url, shareSuccess: { () -> Void in

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

            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: sImage, type: SSDKPlatformType.subTypeQQFriend, url: url, shareSuccess: { () -> Void in

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
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: sImage, type: SSDKPlatformType.subTypeQZone, url: url, shareSuccess: { () -> Void in

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
            break

        }

    }

    // MARK: - 滚动下滑条
    func scrollLine(_ index: Int) {


        for view in (menuView?.subviews)! {

            if view.isMember(of: UIButton.classForCoder()) {

                let btn = view as! UIButton
                btn.setTitleColor(Constants.HDMainTextColor, for: UIControl.State.normal)

            }

        }

        var btn: UIButton?

        if index == 0 {

            btn = menuView?.viewWithTag(2016) as? UIButton

        } else if index == 1 {

            btn = menuView?.viewWithTag(2017) as? UIButton
        } else if index == 2 {

            btn = menuView?.viewWithTag(2018) as? UIButton
        }

        btn!.setTitleColor(Constants.HDMainColor, for: UIControl.State.normal)

        unowned let WS = self
        UIView.animate(withDuration: 0.3, animations: {
            WS.menuLineView?.frame = CGRect(x: CGFloat(index) * (40 + 2 * lineSpace) + lineSpace, y: 40 - 3, width: lineWith, height: 3)
        })

    }

    // MARK: - 滚动视图
    private func scrollViewToScroll(_ index: Int) {

        //滚动时有动画
        scrollView?.setContentOffset(CGPoint(x: CGFloat(index) * Constants.HDSCREENWITH, y: 0), animated: true)

    }

    // MARK: - 提示动画显示和隐藏
    func showHud() {

        CoreUtils.showProgressHUD(self.view)

    }

    func hidenHud() {

        CoreUtils.hidProgressHUD(self.view)
    }

    // MARK: - events
    @objc func backAction() {

        videoPlayerController?.close()
        navigationController!.popViewController(animated: true)

    }

    /**
     *  查看评论
     */
    func commentAction() {

        let hd10VC = HDHM10Controller()
        hd10VC.rid = listModel!.data?.id
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hd10VC, animated: true)
    }

    //显示/隐藏分享视图
    @objc func share() {

        if (shareView.isHidden) {

            showShareView()

        } else {

            hideShareView()

        }

    }

    @objc func menuAction(_ btn: UIButton) {


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
            break
        }

    }

    // MARK: - 加载数据 刷新UI
    func refreshUI() {

        tags.text = "美食明星、生活联盟"
        userName.text = dy02Info?.userInfo?.userName
        commentCount.text = String(format: "评论:%d", (listModel?.data?.commentCnt)!)
        viewCount.text = String(format: "浏览:%ld", (dy02Info?.viewCount)!)
        headIcon.kf.setImage(with: URL(string: (dy02Info?.userInfo?.avatar)!), placeholder: UIImage(named: "defaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)
        titleLb.text = dy02Info?.title
        createTime.text = String(format: "创建日期:%@", (dy02Info?.reviewTime)!)

        let size = CoreUtils.getTextRectSize((dy02Info?.intro!)! as NSString, font: UIFont.systemFont(ofSize: 15), size: CGSize(width: Constants.HDSCREENWITH - 30, height: 99999))
        introView?.text = dy02Info?.intro!
        introView?.snp.updateConstraints({ (make) in

            make.height.equalTo(size.size.height + 10)
        })

        let stuffHeight = (dy02Info?.stuff?.count)! * 44 + 30 + 44
        stuffTableView?.snp.updateConstraints({ (make) in

            make.height.equalTo(stuffHeight)
        })

        let tipsSize = CoreUtils.getTextRectSize((dy02Info?.tips!)! as NSString, font: UIFont.systemFont(ofSize: 15), size: CGSize(width: Constants.HDSCREENWITH - 30, height: 99999))
        tips.text = dy02Info?.tips!

//        tipsView?.snp.updateConstraints({ (make) in
//            make.height.equalTo(60+tipsSize.size.height+5)
//        })
//        tips.snp.updateConstraints { (make) in
//            make.height.equalTo(tipsSize.size.height+5)
//        }

        detailView!.contentSize = CGSize(width: Constants.HDSCREENWITH, height: 110 + size.size.height + 40 + CGFloat(stuffHeight) + 60.0 + tipsSize.size.height + 5)
    }

    // MARK: - 数据加载
    func doGetRequestData() {

        unowned let WS = self
        HDDY02Service().doGetRequest_HDDY0201_URL((listModel?.data?.id)!, successBlock: { (hdResponse) -> Void in

            WS.hidenHud()
            WS.dy02Info = hdResponse.result?.info
            WS.videoPlayerController?.movieBackgroundView.kf.setImage(with: URL(string: (WS.dy02Info?.cover)!), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

            if WS.dy02Info?.hasVideo == 1 {

                /**
                 *  视频参数设置
                 */
                WS.dy02Info?.vedioUrl = WS.getVedioUrl((WS.dy02Info?.cover)!)
                HDLog.LogOut("vedioUrl", obj: (WS.dy02Info?.vedioUrl)!)
                WS.videoPlayerController?.contentURL = URL(string: (WS.dy02Info?.vedioUrl)!)

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


            if hdResponse.result?.list?.count > 0 {

                WS.commentList = (hdResponse.result?.list)!
                WS.getRowHeight()
                WS.activityIndicatorView?.stopAnimating()
                WS.createCommentTableView()

            } else {

                WS.activityIndicatorView?.stopAnimating()
                WS.createNoComment()
            }

        }) { (error) in
            WS.activityIndicatorView?.stopAnimating()
            CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }

    }

    // MARK: - HDShareViewDelegate delegate
    func didShareWithType(_ type: Int) {

        hideShareView()

        let url = String(format: "http://m.haodou.com/recipe/%d?device=iphone&hash=7408f5dd81db1165cd1896e8175a75e4&siteid=1004&appinstall=0", (listModel?.data?.id!)!)
        let  sImage = videoPlayerController?.movieBackgroundView.image?.jpegData(compressionQuality: 0.3) as! UIImage
        switch type {

        case 0:
            /**
             *  微信好友
             */
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: (videoPlayerController?.movieBackgroundView.image)!, type: SSDKPlatformType.subTypeWechatSession, url: url, shareSuccess: { () -> Void in

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
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: (videoPlayerController?.movieBackgroundView.image)!, type: SSDKPlatformType.subTypeWechatTimeline, url: url, shareSuccess: { () -> Void in

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

            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: sImage, type: SSDKPlatformType.subTypeQQFriend, url: url, shareSuccess: { () -> Void in

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
            HDShareSDKManager.doShareSDK((dy02Info!.title)!, context: (dy02Info?.intro)!, image: sImage, type: SSDKPlatformType.subTypeQZone, url: url, shareSuccess: { () -> Void in

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
            break

        }

    }

    // MARK: - HDVideoPlayerController delegate
    func didFullScreen() {

        scrollView?.isHidden = true
        menuView?.isHidden = true
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.fade)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }

    func didshrinkScreen() {

        scrollView?.isHidden = false
        menuView?.isHidden = false
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - UIScrollView delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if scrollView == self.scrollView {
            let index = Int(scrollView.contentOffset.x / Constants.HDSCREENWITH)
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if stuffTableView == tableView {

            return (dy02Info?.stuff?.count)! + 1
        } else if stepsTableView == tableView {

            return (dy02Info?.steps?.count)!
        } else {

            return commentList.count
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {



        if stuffTableView == tableView {

            let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)

            /**
             *   食材
             */


            if (indexPath as NSIndexPath).row == (dy02Info?.stuff?.count)! {
                let title = UILabel()
                title.font = UIFont.systemFont(ofSize: 15)
                cell.contentView.addSubview(title)

                title.snp.makeConstraints( { (make) -> Void in
                    make.top.equalTo(cell.contentView).offset(0)
                    make.left.equalTo(cell.contentView).offset(15)
                    make.height.equalTo(44)
                    make.width.equalTo(Constants.HDSCREENWITH - 30)
                })

                title.textColor = Constants.HDMainTextColor
                title.text = String(format: "制作时间:%@ ", (dy02Info?.readyTime)!)
            } else {


                let title = UILabel()
                title.font = UIFont.systemFont(ofSize: 15)
                cell.contentView.addSubview(title)

                title.snp.makeConstraints( { (make) -> Void in
                    make.top.equalTo(cell.contentView).offset(0)
                    make.left.equalTo(cell.contentView).offset(15)
                    make.height.equalTo(44)
                    make.width.equalTo(Constants.HDSCREENWITH / 2 - 15)
                })

                let weight = UILabel()
                weight.textColor = UIColor.lightGray
                weight.font = UIFont.systemFont(ofSize: 15)
                cell.contentView.addSubview(weight)

                weight.snp.makeConstraints( { (make) -> Void in
                    make.top.equalTo(cell.contentView).offset(0)
                    make.left.equalTo(title.snp.right).offset(30)
                    make.height.equalTo(44)
                    make.width.equalTo(Constants.HDSCREENWITH / 2 - 30)
                })


                title.textColor = UIColor.lightGray
                let model = dy02Info!.stuff![(indexPath as NSIndexPath).row]
                title.text = model.name
                weight.text = model.weight
            }

            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell

        } else if stepsTableView == tableView {
            /**
             *   步骤
             */

            let cell = tableView.dequeueReusableCell(withIdentifier: "stepsCell", for: indexPath)

            let model = dy02Info?.steps![(indexPath as NSIndexPath).row]

            var index = cell.contentView.viewWithTag(1000) as? UILabel
            if index == nil {

                index = UILabel()
                index?.tag = 1000
                index?.textColor = Constants.HDYellowColor
                index?.textAlignment = NSTextAlignment.center
                index?.font = UIFont.systemFont(ofSize: 15)
                cell.contentView.addSubview(index!)

                index?.snp.makeConstraints( { (make) in

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
                stuff?.font = UIFont.systemFont(ofSize: 14)
                cell.contentView.addSubview(stuff!)

                stuff?.snp.makeConstraints( { (make) in

                    make.left.equalTo(index!.snp.right).offset(5)
                    make.top.equalTo(10)
                    make.width.equalTo(Constants.HDSCREENWITH - 60)
                    make.height.equalTo(40)

                })

            }


            stuff?.text = model!.intro
            index?.text = String(format: "%d", (indexPath as NSIndexPath).row + 1)

//            let introSize = CoreUtils.getTextRectSize(String(format: "%d.%@",indexPath.row+1, model!.intro!), font: UIFont.systemFont(16), size:CGSizeMake(Constants.HDSCREENWITH-120, 99999))



            return cell
        } else {

            /**
             *   评论
             */
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)

            cell.selectionStyle = UITableViewCell.SelectionStyle.none

            let model = commentList[(indexPath as NSIndexPath).row]

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

                icon?.snp.makeConstraints( { (make) -> Void in

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
                username?.font = UIFont.systemFont(ofSize: 13)
                username?.textColor = Constants.HDMainTextColor
                cell.contentView.addSubview(username!)

                username?.snp.makeConstraints( { (make) -> Void in

                    make.top.equalTo(cell.contentView).offset(10)
                    make.left.equalTo(icon!.snp.right).offset(5)
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
                createTime?.font = UIFont.systemFont(ofSize: 10)
                createTime?.textColor = UIColor.lightGray
                cell.contentView.addSubview(createTime!)

                createTime?.snp.makeConstraints( { (make) -> Void in

                    make.top.equalTo(username!.snp.bottom).offset(0)
                    make.left.equalTo(icon!.snp.right).offset(5)
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
                content?.font = UIFont.systemFont(ofSize: 14)
                content?.textColor = CoreUtils.HDColor(130, g: 130, b: 130, a: 1)
                content?.numberOfLines = 0
                cell.contentView.addSubview(content!)

                content?.snp.makeConstraints( { (make) -> Void in

                    make.top.equalTo(icon!.snp.bottom).offset(5)
                    make.left.equalTo(icon!.snp.right).offset(5)
                    make.width.equalTo(Constants.HDSCREENWITH - 80)
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

                commentView?.snp.makeConstraints( { (make) -> Void in

                    make.top.equalTo(content!.snp.bottom).offset(5)
                    make.left.equalTo(icon!.snp.right).offset(5)
                    make.width.equalTo(Constants.HDSCREENWITH - 60)
                    make.height.equalTo(0);

                })

            }

            //回复对象
            var atUsername = commentView!.viewWithTag(6000) as? UILabel

            if atUsername == nil {

                atUsername = UILabel()
                atUsername?.tag = 6000
                atUsername?.font = UIFont.systemFont(ofSize: 13)
                atUsername?.textColor = Constants.HDMainTextColor
                commentView!.addSubview(atUsername!)

                atUsername?.snp.makeConstraints( { (make) -> Void in

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
                atContent?.font = UIFont.systemFont(ofSize: 13)
                atContent?.textColor = CoreUtils.HDColor(130, g: 130, b: 130, a: 1)
                atContent?.numberOfLines = 0
                commentView!.addSubview(atContent!)

                atContent?.snp.makeConstraints( { (make) -> Void in

                    make.top.equalTo(atUsername!.snp.bottom).offset(0)
                    make.left.equalTo(10)
                    make.width.equalTo(Constants.HDSCREENWITH - 110)
                    make.height.equalTo(0)
                })

            }


            content?.snp.updateConstraints({ (make) in
                make.height.equalTo(model.contentHeight!)
            })

            if model.atUserId > 0 {

                atUsername?.text = String(format: "回复：%@", model.atUserName!)
                atContent?.text = model.atContent

                commentView?.isHidden = false

                commentView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(35.0 + model.atContentHeight!);
                })
                atContent?.snp.updateConstraints({ (make) in

                    make.height.equalTo(model.atContentHeight!)
                })

            } else {

                commentView?.isHidden = true
            }

            icon?.kf.setImage(with: URL(string: (model.avatar)!), placeholder: UIImage(named: "defaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

            username?.text = model.userName
            createTime?.text = model.createTime
            content?.text = model.content

            return cell
        }


    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constants.HDSCREENWITH, height: 30))

        if stuffTableView == tableView {

            let title = UILabel(frame: CGRect(x: 15, y: 0, width: Constants.HDSCREENWITH - 15, height: 30))
            title.textColor = UIColor.lightGray
            title.font = UIFont.systemFont(ofSize: 15)
            view.addSubview(title)

            title.text = "食材"
        }

        return view
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if tableView == stuffTableView {
            return CGFloat(Constants.HDSpace * 3)
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if stuffTableView == tableView {

            return 44
        } else if stepsTableView == tableView {

            return 60
        } else {

            let model = commentList[(indexPath as NSIndexPath).row]
            return model.rowHeight!
        }

    }

}
