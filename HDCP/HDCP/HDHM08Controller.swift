//
//  HDHM08Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/18.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let shareViewHeight = CGFloat(255)

class HDHM08Controller: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var rid:Int?
    var name:String?
    var hm08Response:HDHM08Response!
    
    var baseView:UIScrollView?
    var headImageView:UIImageView?
    var infoView:UIView?
    var introView:UILabel?
    var tableView:UITableView?
    var tipsView:UIView?
    var shareView:UIView!
    var shareSubView:HDShareView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = name
        showHud()
        doGetRequestData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
        
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 40, 30)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.setTitle("分享", forState: UIControlState.Normal)
        button.addTarget(self, action: "share", forControlEvents: UIControlEvents.TouchUpInside)
        button.contentMode = UIViewContentMode.ScaleToFill
        let rightItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }


    // MARK: - 创建UI视图
    
    func setupUI(){
    
        createBaseView()
        createHeaderView()
        createInfoView()
        createIntroView()
        createTableView()
        createTipsView()
        createShareView()
    }
    
    /**
     *  分享视图
     */
    func createShareView(){
        
        
        if shareView == nil {
            
            shareView = UIView()
            shareView.hidden = true
            shareView.backgroundColor = Constants.HDColor(0, g: 0, b: 0, a: 0.2)
            shareView.alpha = 0.0
            self.view.addSubview(shareView!)
            let tapGes = UITapGestureRecognizer(target: self, action: "hideShareView")
            shareView.addGestureRecognizer(tapGes)
            
            shareView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(self.view).offset(0)
                make.left.equalTo(self.view).offset(0)
                make.bottom.equalTo(self.view).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                
                
            })
            
            shareSubView = HDShareView(frame: CGRectMake(0,self.view.bounds.size.height,Constants.HDSCREENWITH,shareViewHeight))
            shareSubView.completeClosuse(shareAction)
            shareView.addSubview(shareSubView)
            
            
        }
        
    }
    
    /**
     *  滚动视图
     */
    func createBaseView(){
    
        
        if baseView == nil {
            
            baseView = UIScrollView()
            baseView?.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(baseView!)
            
            baseView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(self.view).offset(0)
                make.left.equalTo(self.view).offset(0)
                make.bottom.equalTo(self.view).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                
            })
            
            //计算容器的大小
            let size = CoreUtils.getTextRectSize((hm08Response.result?.info?.intro!)!, font: UIFont.systemFontOfSize(15), size: CGSizeMake(Constants.HDSCREENWITH-30, 99999))
            let stepHeight = (hm08Response.result?.info?.steps?.count)!*80+30
            let stuffHeight = ((hm08Response.result?.info?.stuff?.count)!+1)*44+40
            let tipsSize = CoreUtils.getTextRectSize((hm08Response.result?.info?.tips!)!, font: UIFont.systemFontOfSize(15), size: CGSizeMake(Constants.HDSCREENWITH-30, 99999))

            baseView?.contentSize = CGSizeMake(Constants.HDSCREENWITH, CGFloat(200+20+110+5+stepHeight+stuffHeight+40)+size.size.height+tipsSize.size.height+60)
            
        }

        
    }
    
    /**
     *  顶部图片视图
     */
    func createHeaderView(){
    
        if headImageView == nil {
            
            headImageView = UIImageView()
            baseView?.addSubview(headImageView!)
            
            headImageView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(baseView!).offset(0)
                make.left.equalTo(baseView!).offset(0)
                make.height.equalTo(200)
                make.width.equalTo(Constants.HDSCREENWITH)
                
            })
            
            self.headImageView?.sd_setImageWithURL(NSURL(string: (hm08Response.result?.info?.cover)!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        }

        
    }
    
    /**
     *  发布人信息
     */
    func createInfoView(){
    
        if infoView == nil {
        
            
            infoView = UIView()
            baseView?.addSubview(infoView!)
            
            infoView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(self.headImageView!.snp_bottom).offset(Constants.HDSpace*2)
                make.left.equalTo(baseView!).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(110)
                
            })
            
            
            let title = UILabel()
            title.textColor = Constants.HDMainTextColor
            title.font = UIFont.systemFontOfSize(20)
            infoView?.addSubview(title)
            
            title.text = hm08Response.result?.info?.title
            
            title.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(infoView!).offset(0)
                make.left.equalTo(infoView!).offset(15)
                make.height.equalTo(25)
                make.width.equalTo(Constants.HDSCREENWITH-30)
                
            })
            
            let createTime = UILabel()
            createTime.textColor = UIColor.lightGrayColor()
            createTime.font = UIFont.systemFontOfSize(12)
            infoView?.addSubview(createTime)
            
            createTime.text = String(format: "创建日期:%@", (hm08Response.result?.info?.reviewTime)!)
            
            createTime.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(title.snp_bottom).offset(5)
                make.left.equalTo(infoView!).offset(15)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH/2-30)
                
            })
            
            let headIcon = UIImageView()
            headIcon.layer.cornerRadius = 25
            headIcon.layer.masksToBounds = true
            infoView?.addSubview(headIcon)
            
            headIcon.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(createTime.snp_bottom).offset(5)
                make.left.equalTo(infoView!).offset(15)
                make.width.equalTo(50)
                make.height.equalTo(50)
            })
            
            headIcon.sd_setImageWithURL(NSURL(string: (hm08Response.result?.info?.avatar)!), placeholderImage: UIImage(named: "defaultIcon"))
            
            
            
            let viewCount = UILabel()
            viewCount.textColor = UIColor.lightGrayColor()
            viewCount.font = UIFont.systemFontOfSize(12)
            infoView?.addSubview(viewCount)
            
            viewCount.text = String(format: "浏览:%d", (hm08Response.result?.info?.viewCount)!)
            
            viewCount.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(title.snp_bottom).offset(5)
                make.left.equalTo(infoView!).offset(Constants.HDSCREENWITH/2+20)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH/4-10)
                
            })
            
            
            let commentCount = UILabel()
            commentCount.textColor = UIColor.blueColor()
            commentCount.font = UIFont.systemFontOfSize(12)
            commentCount.userInteractionEnabled = true
            infoView?.addSubview(commentCount)
            
            commentCount.text = String(format: "评论:%d", (hm08Response.result?.info?.commentCount)!)
            
            let tapGes = UITapGestureRecognizer(target: self, action: "commentAction")
            commentCount.addGestureRecognizer(tapGes)
            
            commentCount.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(title.snp_bottom).offset(5)
                make.left.equalTo(viewCount.snp_right).offset(10)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH/4-20)
                
            })

            
            
            let userName = UILabel()
            userName.textColor = UIColor.lightGrayColor()
            userName.font = UIFont.systemFontOfSize(16)
            infoView?.addSubview(userName)
            
            userName.text = hm08Response.result?.info?.userName
            
            userName.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(createTime.snp_bottom).offset(5)
                make.left.equalTo(headIcon.snp_right).offset(10)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH-30)
                
            })

            let tags = UILabel()
            tags.textColor = UIColor.lightGrayColor()
            tags.font = UIFont.systemFontOfSize(12)
            infoView?.addSubview(tags)
            
            
//            var stuffStr = String()
//            for var i=0;i<hm08Response.result?.info?.tags!.count;i++ {
//                
//                let tag = hm08Response.result?.info?.tags![i]
//                
//                if i == (hm08Response.result?.info?.tags!.count)!-1 {
//                    stuffStr.appendContentsOf((tag?.name)!)
//                    
//                }else{
//                    stuffStr.appendContentsOf(String(format: "%@、", (tag?.name)!))
//                }
//                
//            }
            
            tags.text = "美食明星、生活联盟"
            
            tags.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(userName.snp_bottom).offset(5)
                make.left.equalTo(headIcon.snp_right).offset(10)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH-100)
                
            })

            
        }
        
        
    }
    
    /**
     *  菜谱介绍
     */
    func createIntroView(){
    
        if introView == nil {
            
            let size = CoreUtils.getTextRectSize((hm08Response.result?.info?.intro!)!, font: UIFont.systemFontOfSize(15), size: CGSizeMake(Constants.HDSCREENWITH-30, 99999))
            
            introView = UILabel()
            introView?.textColor = Constants.HDMainTextColor
            introView?.font = UIFont.systemFontOfSize(15)
            introView?.numberOfLines = 0
            baseView?.addSubview(introView!)
            
            introView?.text = hm08Response.result?.info?.intro
            
            introView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(infoView!.snp_bottom).offset(5)
                make.left.equalTo(baseView!).offset(15)
                make.width.equalTo(Constants.HDSCREENWITH-30)
                make.height.equalTo(size.size.height+10)
                
            })
            
            
        }
        
    }
    
    /**
     *  食材/步骤
     */
    func createTableView(){
    
        tableView = UITableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.scrollEnabled = false
        baseView?.addSubview(tableView!)
        
        tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        
        let stepHeight = (hm08Response.result?.info?.steps?.count)!*80+30
        let stuffHeight = ((hm08Response.result?.info?.stuff?.count)!+1)*44+40
        
        tableView?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.top.equalTo(introView!.snp_bottom).offset(10)
            make.left.equalTo(baseView!).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(stepHeight+stuffHeight)
        })
        
    }
    
    /**
     *  小贴士
     */

    func createTipsView(){
    
        if tipsView == nil {
            
            let tipsSize = CoreUtils.getTextRectSize((hm08Response.result?.info?.tips!)!, font: UIFont.systemFontOfSize(15), size: CGSizeMake(Constants.HDSCREENWITH-30, 99999))
        
            tipsView = UIView()
            baseView?.addSubview(tipsView!)
            tipsView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(tableView!.snp_bottom).offset(0)
                make.left.equalTo(baseView!).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(60+tipsSize.size.height+5)
            })
            
            let title = UILabel()
            title.font = UIFont.systemFontOfSize(18)
            title.text = "小贴士"
            title.textColor = UIColor.lightGrayColor()
            tipsView?.addSubview(title)
            
            title.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(tipsView!).offset(20)
                make.left.equalTo(tipsView!).offset(15)
                make.width.equalTo(150)
                make.height.equalTo(20)
            })
            
            let tips = UILabel()
            tips.font = UIFont.systemFontOfSize(14)
            tips.textColor = Constants.HDMainTextColor
            tips.numberOfLines = 0
            tipsView?.addSubview(tips)
            
            tips.text = hm08Response.result?.info?.tips!
            tips.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(title.snp_bottom).offset(20)
                make.left.equalTo(tipsView!).offset(15)
                make.width.equalTo(Constants.HDSCREENWITH-30)
                make.height.equalTo(tipsSize.size.height+5)
            })
            
            
        }
        
        
    }
    
    // MARK: - 提示动画显示和隐藏
    func showHud(){
        
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.view)
    }
    
    // MARK: - 分享视图显示和隐藏
    func hideShareView(){
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.shareSubView.frame = CGRectMake(0,self.view.bounds.size.height,Constants.HDSCREENWITH,shareViewHeight)
            self.shareView.alpha = 0.0
            }, completion: { (ret) -> Void in
                self.shareView?.hidden = true
        })
        
    }
    func showShareView(){
        
        shareView?.hidden = false
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.shareView.alpha = 1
            self.shareSubView.frame = CGRectMake(0,self.view.bounds.size.height-shareViewHeight,Constants.HDSCREENWITH,shareViewHeight)
        })
    }
    
    // MARK: - events
    
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    /**
     *  查看评论
     */
    func commentAction(){
    
        let hd10VC = HDHM10Controller()
        hd10VC.commentArray = (self.hm08Response.result?.comment)!
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hd10VC, animated: true)
    }
    
    func share(){
        
        if (shareView.hidden) {
            
            showShareView()
            
        }else{
            
            hideShareView()
            
        }
        
    }
    
    /**
     *  菜谱分享
     */
    func shareAction(tag:Int){
    
        hideShareView()
        
        let url = String(format: "http://m.haodou.com/recipe/%d?device=iphone&hash=7408f5dd81db1165cd1896e8175a75e4&siteid=1004&appinstall=0", rid!)
        
        switch tag {
        
        case 0:
            /**
            *  微信好友
            */
            HDShareSDKManager.doShareSDK((hm08Response.result?.info?.title)!, context: (hm08Response.result?.info?.intro)!, image: (headImageView?.image)!, type: SSDKPlatformType.SubTypeWechatSession, url: url, shareSuccess: { () -> Void in
                
                CoreUtils.showSuccessHUD(self.view, title: "分享成功")
                print("成功")
                }, shareFail: { () -> Void in
                    print("失败")
                    CoreUtils.showWarningHUD(self.view, title: "分享失败")
                }, shareCancel: { () -> Void in
                    print("取消")
            })

            break
        case 1:
            /**
            *  微信朋友圈
            */
            HDShareSDKManager.doShareSDK((hm08Response.result?.info?.title)!, context: (hm08Response.result?.info?.intro)!, image: (headImageView?.image)!, type: SSDKPlatformType.SubTypeWechatTimeline, url: url, shareSuccess: { () -> Void in
                
                CoreUtils.showSuccessHUD(self.view, title: "分享成功")
                print("成功")
                }, shareFail: { () -> Void in
                    print("失败")
                    CoreUtils.showWarningHUD(self.view, title: "分享失败")
                }, shareCancel: { () -> Void in
                    print("取消")
            })


            break
        case 2:
            /**
            *  QQ
            */
            
            HDShareSDKManager.doShareSDK((hm08Response.result?.info?.title)!, context: (hm08Response.result?.info?.intro)!, image: UIImage(data: UIImageJPEGRepresentation((headImageView?.image)!, 0.3)!)!, type: SSDKPlatformType.SubTypeQQFriend, url: url, shareSuccess: { () -> Void in
                
                CoreUtils.showSuccessHUD(self.view, title: "分享成功")
                print("成功")
                }, shareFail: { () -> Void in
                    print("失败")
                    CoreUtils.showWarningHUD(self.view, title: "分享失败")
                }, shareCancel: { () -> Void in
                    print("取消")
            })


            break
        case 3:
            /**
            *  QQ空间
            */
            HDShareSDKManager.doShareSDK((hm08Response.result?.info?.title)!, context: (hm08Response.result?.info?.intro)!, image: UIImage(data: UIImageJPEGRepresentation((headImageView?.image)!, 0.3)!)!, type: SSDKPlatformType.SubTypeQZone, url: url, shareSuccess: { () -> Void in
                
                CoreUtils.showSuccessHUD(self.view, title: "分享成功")
                print("成功")
                }, shareFail: { () -> Void in
                    print("失败")
                    CoreUtils.showWarningHUD(self.view, title: "分享失败")
                }, shareCancel: { () -> Void in
                    print("取消")
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
        print("tag = \(tag)")
        
    }
    
    /**
     *  选中cell 进入烹饪步骤页面
     */
    func selectRowAction(ges:UITapGestureRecognizer){
        
        let touchView = ges.view
        let indexPath = NSIndexPath(forRow: (touchView?.tag)!, inSection: 1)
        tableView?.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        
        let hdHM09VC = HDHM09Controller()
        hdHM09VC.index = touchView?.tag
        hdHM09VC.steps = hm08Response.result?.info?.steps
        self.hidesBottomBarWhenPushed = true;
        self.presentViewController(hdHM09VC, animated: true, completion: { () -> Void in
            /**
            *  取消cell选择状态
            */
            self.tableView?.deselectRowAtIndexPath(self.tableView!.indexPathForSelectedRow!, animated: true)
        })
        
    }
    
    // MARK: - 数据加载
    func doGetRequestData(){
        
        HDHM08Service().doGetRequest_HDHM08_URL(rid!, successBlock: { (hm08Response) -> Void in
            
                self.hidenHud()
                self.hm08Response = hm08Response
                self.setupUI()
            
            }) { (error) -> Void in
                
                
                CoreUtils.showWarningHUD(self.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }
    
    
    // MARK: - UITableView delegate/datasource
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        if section == 0 {
        
            return (hm08Response.result?.info?.stuff?.count)!+1
        }else{
        
            return (hm08Response.result?.info?.steps?.count)!
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        let cell = tableView .dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        
        if indexPath.section == 0 {
            
            /**
            *   食材
            */
            
            
            if indexPath.row == (hm08Response.result?.info?.stuff?.count)! {
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
                title.text = String(format: "制作时间:%@   用餐人数:%@", (hm08Response.result?.info?.readyTime)!,(hm08Response.result?.info?.userCount)!)
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
                let model = hm08Response.result?.info?.stuff![indexPath.row]
                title.text = model?.name
                weight.text = model?.weight
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
        }else{
            /**
            *   步骤
            */
            let model = hm08Response.result?.info?.steps![indexPath.row]
            
            let imageView = UIImageView()
            cell.contentView.addSubview(imageView)
            imageView.sd_setImageWithURL(NSURL(string: model!.stepPhoto!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
            
            imageView.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(cell.contentView).offset(10)
                make.left.equalTo(cell.contentView).offset(15)
                make.width.equalTo(80)
                make.height.equalTo(60)
            })
            
            let intro = UILabel()
            intro.text = String(format: "%d.%@",indexPath.row+1, model!.intro!)
            intro.font = UIFont.systemFontOfSize(16)
            intro.textColor = UIColor.lightGrayColor()
            intro.numberOfLines = 3
            cell.contentView.addSubview(intro)
            
            let introSize = CoreUtils.getTextRectSize(String(format: "%d.%@",indexPath.row+1, model!.intro!), font: UIFont.systemFontOfSize(16), size:CGSizeMake(Constants.HDSCREENWITH-120, 99999))
            
            intro.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(cell.contentView).offset(5)
                make.left.equalTo(imageView.snp_right).offset(10)
                make.width.equalTo(Constants.HDSCREENWITH-120)
                make.height.equalTo(introSize.size.height+5)
                
            })
            
            /// 添加点击事件 由于scrollview滚动后会拦截cell默认的点击事件
            let tapGes = UITapGestureRecognizer(target: self, action: "selectRowAction:")
            cell.contentView.tag = indexPath.row
            cell.contentView.addGestureRecognizer(tapGes)
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRectMake(0,0,Constants.HDSCREENWITH,30))
        
        
        if section == 0 {
            let title = UILabel(frame: CGRectMake(15,0,Constants.HDSCREENWITH-15,30))
            title.textColor = UIColor.lightGrayColor()
            title.font = UIFont.systemFontOfSize(15)
            view.addSubview(title)

            title.text = "食材"
        }else{
            
            let line = UILabel(frame: CGRectMake(15,0,Constants.HDSCREENWITH,1))
            line.backgroundColor = Constants.HDColor(227, g: 227, b: 229, a: 1.0)
            view.addSubview(line)
            
            let title = UILabel(frame: CGRectMake(15,15,Constants.HDSCREENWITH-15,20))
            title.textColor = UIColor.lightGrayColor()
            title.font = UIFont.systemFontOfSize(15)
            view.addSubview(title)

            title.text = "步骤"
        }
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.HDSpace*3)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 44
        }else{
            
            return 80
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
        
            
            
        }
        
    }
    
}
