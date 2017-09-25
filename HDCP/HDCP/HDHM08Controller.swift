//
//  HDHM08Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/18.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let shareViewHeight = CGFloat(255)

class HDHM08Controller: BaseViewController, UITableViewDelegate, UITableViewDataSource, HDShareViewDelegate {

    var rid: Int?
    var name: String?
    var hm08Response: HDHM08Response!

    var baseView: UIScrollView?
    var headImageView: UIImageView?
    var infoView: UIView?
    var introView: UILabel?
    var tableView: UITableView!
    var tipsView: UIView?
    var shareView: UIView!
    var shareSubView: HDShareView!
    var titleLb: UILabel!
    var createTime: UILabel!
    var headIcon: UIImageView!
    var viewCount: UILabel!
    var commentCount: UILabel!
    var userName: UILabel!

    override func viewDidLoad() {

        super.viewDidLoad()
        self.title = name
        showHud()
        doGetRequestData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)

        let button = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setBackgroundImage(UIImage(named: "shareIcon"), for: UIControlState())
        button.addTarget(self, action: #selector(share), for: UIControlEvents.touchUpInside)
        button.contentMode = UIViewContentMode.scaleToFill
        let rightItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightItem
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }


    deinit {


        HDLog.LogClassDestory("HDHM08Controller")
    }

    // MARK: - 创建UI视图

    func setupUI() {

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

    /**
     *  滚动视图
     */
    func createBaseView() {


        if baseView == nil {

            baseView = UIScrollView()
            baseView?.backgroundColor = UIColor.white
            self.view.addSubview(baseView!)

            unowned let WS = self
            baseView?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.view).offset(0)
                make.left.equalTo(WS.view).offset(0)
                make.bottom.equalTo(WS.view).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)

            })

            
            //计算容器的大小
            let size = CoreUtils.getTextRectSize((hm08Response.result?.info?.intro!)! as NSString, font: UIFont.systemFont(ofSize: 15), size: CGSize(width: Constants.HDSCREENWITH - 30, height: 99999))
            let stepHeight = (hm08Response.result?.info?.steps?.count)! * 80 + 30
            let stuffHeight = ((hm08Response.result?.info?.stuff?.count)! + 1) * 44 + 40
            let tipsSize = CoreUtils.getTextRectSize((hm08Response.result?.info?.tips!)! as NSString, font: UIFont.systemFont(ofSize: 15), size: CGSize(width: Constants.HDSCREENWITH - 30, height: 99999))

            baseView?.contentSize = CGSize(width: Constants.HDSCREENWITH, height: CGFloat(200 + 20 + 110 + 5 + stepHeight + stuffHeight + 40) + size.size.height + tipsSize.size.height + 60)

        }


    }

    /**
     *  顶部图片视图
     */
    func createHeaderView() {

        if headImageView == nil {

            headImageView = UIImageView()
            baseView?.addSubview(headImageView!)

            unowned let WS = self
            headImageView?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.baseView!).offset(0)
                make.left.equalTo(WS.baseView!).offset(0)
                make.height.equalTo(200)
                make.width.equalTo(Constants.HDSCREENWITH)

            })

            self.headImageView?.kf.setImage(with: URL(string: (hm08Response.result?.info?.cover)!), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)
        }


    }

    /**
     *  发布人信息
     */
    func createInfoView() {

        unowned let WS = self

        if infoView == nil {

            infoView = UIView()
            baseView?.addSubview(infoView!)


            infoView?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.headImageView!.snp.bottom).offset(Constants.HDSpace * 2)
                make.left.equalTo(WS.baseView!).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(110)

            })


            titleLb = UILabel()
            titleLb.textColor = Constants.HDMainTextColor
            titleLb.font = UIFont.systemFont(ofSize: 20)
            infoView?.addSubview(titleLb)

            titleLb.text = hm08Response.result?.info?.title

            titleLb.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.infoView!).offset(0)
                make.left.equalTo(WS.infoView!).offset(15)
                make.height.equalTo(25)
                make.width.equalTo(Constants.HDSCREENWITH - 30)

            })

            createTime = UILabel()
            createTime.textColor = UIColor.lightGray
            createTime.font = UIFont.systemFont(ofSize: 12)
            infoView?.addSubview(createTime)

            createTime.text = String(format: "创建日期:%@", (hm08Response.result?.info?.reviewTime)!)

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

            headIcon.kf.setImage(with: URL(string: (hm08Response.result?.info?.avatar)!), placeholder: UIImage(named: "defaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

            viewCount = UILabel()
            viewCount.textColor = UIColor.lightGray
            viewCount.font = UIFont.systemFont(ofSize: 12)
            infoView?.addSubview(viewCount)

            viewCount.text = String(format: "浏览:%d", (hm08Response.result?.info?.viewCount)!)

            viewCount.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.titleLb.snp.bottom).offset(5)
                make.left.equalTo(WS.infoView!).offset(Constants.HDSCREENWITH / 2 + 20)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH / 4 - 10)

            })


            commentCount = UILabel()
            commentCount.textColor = UIColor.blue
            commentCount.font = UIFont.systemFont(ofSize: 12)
            commentCount.isUserInteractionEnabled = true
            infoView?.addSubview(commentCount)

            commentCount.text = String(format: "评论:%d", (hm08Response.result?.info?.commentCount)!)

            let tapGes = UITapGestureRecognizer(target: self, action: #selector(commentAction))
            commentCount.addGestureRecognizer(tapGes)

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

            userName.text = hm08Response.result?.info?.userName

            userName.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.createTime.snp.bottom).offset(10)
                make.left.equalTo(WS.headIcon.snp.right).offset(10)
                make.height.equalTo(20)
                make.width.equalTo(Constants.HDSCREENWITH - 30)

            })

            let tags = UILabel()
            tags.textColor = UIColor.lightGray
            tags.font = UIFont.systemFont(ofSize: 12)
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

            let size = CoreUtils.getTextRectSize((hm08Response.result?.info?.intro!)! as NSString, font: UIFont.systemFont(ofSize: 15), size: CGSize(width: Constants.HDSCREENWITH - 30, height: 99999))

            introView = UILabel()
            introView?.textColor = Constants.HDMainTextColor
            introView?.font = UIFont.systemFont(ofSize: 15)
            introView?.numberOfLines = 0
            baseView?.addSubview(introView!)

            introView?.text = hm08Response.result?.info?.intro

            introView?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.infoView!.snp.bottom).offset(5)
                make.left.equalTo(WS.baseView!).offset(15)
                make.width.equalTo(Constants.HDSCREENWITH - 30)
                make.height.equalTo(size.size.height + 10)

            })


        }

    }

    /**
     *  食材/步骤
     */
    func createTableView() {

        tableView = UITableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.isScrollEnabled = false
        baseView?.addSubview(tableView!)

        tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")

        let stepHeight = (hm08Response.result?.info?.steps?.count)! * 80 + 30
        let stuffHeight = ((hm08Response.result?.info?.stuff?.count)! + 1) * 44 + 40

        unowned let WS = self
        tableView?.snp.makeConstraints( { (make) -> Void in

            make.top.equalTo(WS.introView!.snp.bottom).offset(10)
            make.left.equalTo(WS.baseView!).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(stepHeight + stuffHeight)
        })

    }

    /**
     *  小贴士
     */

    func createTipsView() {

        unowned let WS = self
        if tipsView == nil {

            let tipsSize = CoreUtils.getTextRectSize((hm08Response.result?.info?.tips!)! as NSString, font: UIFont.systemFont(ofSize: 15), size: CGSize(width: Constants.HDSCREENWITH - 30, height: 99999))

            tipsView = UIView()
            baseView?.addSubview(tipsView!)

            tipsView?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.tableView!.snp.bottom).offset(0)
                make.left.equalTo(WS.baseView!).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(60 + tipsSize.size.height + 5)
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

            let tips = UILabel()
            tips.font = UIFont.systemFont(ofSize: 14)
            tips.textColor = Constants.HDMainTextColor
            tips.numberOfLines = 0
            tipsView?.addSubview(tips)

            tips.text = hm08Response.result?.info?.tips!
            tips.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(title.snp.bottom).offset(20)
                make.left.equalTo(WS.tipsView!).offset(15)
                make.width.equalTo(Constants.HDSCREENWITH - 30)
                make.height.equalTo(tipsSize.size.height + 5)
            })


        }


    }

    // MARK: - 提示动画显示和隐藏
    func showHud() {

        CoreUtils.showProgressHUD(self.view)

    }

    func hidenHud() {

        CoreUtils.hidProgressHUD(self.view)
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

    // MARK: - events

    @objc func backAction() {

        navigationController!.popViewController(animated: true)

    }

    /**
     *  查看评论
     */
    @objc func commentAction() {

        let hd10VC = HDHM10Controller()
        hd10VC.rid = self.rid
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hd10VC, animated: true)
    }

    @objc func share() {

        if (shareView.isHidden) {

            showShareView()

        } else {

            hideShareView()

        }

    }


    /**
     *  选中cell 进入烹饪步骤页面
     */
    @objc func selectRowAction(_ ges: UITapGestureRecognizer) {

        let touchView = ges.view
        let indexPath = IndexPath(row: (touchView?.tag)!, section: 1)
        tableView?.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)

        let hdHM09VC = HDHM09Controller()
        hdHM09VC.index = touchView?.tag
        hdHM09VC.steps = hm08Response.result?.info?.steps
        self.hidesBottomBarWhenPushed = true;

        unowned let WS = self
        self.present(hdHM09VC, animated: true, completion: { () -> Void in
            /**
            *  取消cell选择状态
            */
            WS.tableView?.deselectRow(at: WS.tableView!.indexPathForSelectedRow!, animated: true)
        })

    }

    // MARK: - 数据加载
    func doGetRequestData() {

        unowned let WS = self
        HDHM08Service().doGetRequest_HDHM08_URL(rid!, successBlock: { (hm08Response) -> Void in

            WS.hidenHud()
            WS.hm08Response = hm08Response
            WS.setupUI()

        }) { (error) -> Void in

            WS.hidenHud()
            CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }

    }

    // MARK: - HDShareViewDelegate delegate
    func didShareWithType(_ type: Int) {

        hideShareView()

        let url = String(format: "http://m.haodou.com/recipe/%d?device=iphone&hash=7408f5dd81db1165cd1896e8175a75e4&siteid=1004&appinstall=0", rid!)

        switch type {

        case 0:
            /**
             *  微信好友
             */
            HDShareSDKManager.doShareSDK((hm08Response.result?.info?.title)!, context: (hm08Response.result?.info?.intro)!, image: (headImageView?.image)!, type: SSDKPlatformType.subTypeWechatSession, url: url, shareSuccess: { () -> Void in

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
            HDShareSDKManager.doShareSDK((hm08Response.result?.info?.title)!, context: (hm08Response.result?.info?.intro)!, image: (headImageView?.image)!, type: SSDKPlatformType.subTypeWechatTimeline, url: url, shareSuccess: { () -> Void in

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

            HDShareSDKManager.doShareSDK((hm08Response.result?.info?.title)!, context: (hm08Response.result?.info?.intro)!, image: UIImage(data: UIImageJPEGRepresentation((headImageView?.image)!, 0.3)!)!, type: SSDKPlatformType.subTypeQQFriend, url: url, shareSuccess: { () -> Void in

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
            HDShareSDKManager.doShareSDK((hm08Response.result?.info?.title)!, context: (hm08Response.result?.info?.intro)!, image: UIImage(data: UIImageJPEGRepresentation((headImageView?.image)!, 0.3)!)!, type: SSDKPlatformType.subTypeQZone, url: url, shareSuccess: { () -> Void in

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

    // MARK: - UITableView delegate/datasource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {

            return (hm08Response.result?.info?.stuff?.count)! + 1
        } else {

            return (hm08Response.result?.info?.steps?.count)!
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath)


        if (indexPath as NSIndexPath).section == 0 {

            /**
            *   食材
            */


            if (indexPath as NSIndexPath).row == (hm08Response.result?.info?.stuff?.count)! {
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
                title.text = String(format: "制作时间:%@   用餐人数:%@", (hm08Response.result?.info?.readyTime)!, (hm08Response.result?.info?.userCount)!)
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
                let model = hm08Response.result?.info?.stuff![(indexPath as NSIndexPath).row]
                title.text = model?.name
                weight.text = model?.weight
            }

            cell.selectionStyle = UITableViewCellSelectionStyle.none

        } else {
            /**
            *   步骤
            */
            let model = hm08Response.result?.info?.steps![(indexPath as NSIndexPath).row]

            let imageView = UIImageView()
            cell.contentView.addSubview(imageView)
            imageView.kf.setImage(with: URL(string: model!.stepPhoto!), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)
            imageView.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(cell.contentView).offset(10)
                make.left.equalTo(cell.contentView).offset(15)
                make.width.equalTo(80)
                make.height.equalTo(60)
            })

            let intro = UILabel()
            intro.text = String(format: "%d.%@", (indexPath as NSIndexPath).row + 1, model!.intro!)
            intro.font = UIFont.systemFont(ofSize: 16)
            intro.textColor = UIColor.lightGray
            intro.numberOfLines = 3
            cell.contentView.addSubview(intro)

            let introSize = CoreUtils.getTextRectSize(String(format: "%d.%@", indexPath.row + 1, model!.intro!) as NSString, font: UIFont.systemFont(ofSize: 16), size: CGSize(width: Constants.HDSCREENWITH - 120, height: 99999))

            intro.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(cell.contentView).offset(5)
                make.left.equalTo(imageView.snp.right).offset(10)
                make.width.equalTo(Constants.HDSCREENWITH - 120)
                make.height.equalTo(introSize.size.height + 5)

            })

            /// 添加点击事件 由于scrollview滚动后会拦截cell默认的点击事件
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(selectRowAction(_:)))
            cell.contentView.tag = (indexPath as NSIndexPath).row
            cell.contentView.addGestureRecognizer(tapGes)

        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constants.HDSCREENWITH, height: 30))


        if section == 0 {
            let title = UILabel(frame: CGRect(x: 15, y: 0, width: Constants.HDSCREENWITH - 15, height: 30))
            title.textColor = UIColor.lightGray
            title.font = UIFont.systemFont(ofSize: 15)
            view.addSubview(title)

            title.text = "食材"
        } else {

            let line = UILabel(frame: CGRect(x: 15, y: 0, width: Constants.HDSCREENWITH, height: 1))
            line.backgroundColor = CoreUtils.HDColor(227, g: 227, b: 229, a: 1.0)
            view.addSubview(line)

            let title = UILabel(frame: CGRect(x: 15, y: 15, width: Constants.HDSCREENWITH - 15, height: 20))
            title.textColor = UIColor.lightGray
            title.font = UIFont.systemFont(ofSize: 15)
            view.addSubview(title)

            title.text = "步骤"
        }

        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.HDSpace * 3)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath as NSIndexPath).section == 0 {

            return 44
        } else {

            return 80
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if (indexPath as NSIndexPath).section == 1 {



        }

    }

}
