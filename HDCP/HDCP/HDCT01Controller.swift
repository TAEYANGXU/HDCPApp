//
//  HDCT01ViewController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit
import Kingfisher

private let ct01Array = [[["title": "豆友", "image": "DYIcon"],
    ["title": "动态", "image": "DTIcon"], ["title": "话题", "image": "HTIcon"],
    ["title": "消息", "image": "msgIcon"], ["title": "设置", "image": "SZIcon"]]]

private let cntArray = ["关注", "粉丝", "好友"]

private let kHeadViewHeight: CGFloat = 280

class HDCT01Controller: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    enum BTNTag: Int {
        case gz = 1000, fs, hy
    }

    var tableView: UITableView!
    var headerBg: UIImageView?
    var headerIcon: UIImageView?
    var userName: UILabel?
    var sLine: UILabel?
    var cntView: UIView?

    var navView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge();
        self.extendedLayoutIncludesOpaqueBars = false;
        self.modalPresentationCapturesStatusBarAppearance = false;
        self.automaticallyAdjustsScrollViewInsets = true;

        NotificationCenter.default.addObserver(self, selector: #selector(ct01Notification(_:)), name: NSNotification.Name(rawValue: Constants.HDREFRESHHDCT01), object: nil)

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    deinit {

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.HDREFRESHHDCT01), object: nil)
        HDLog.LogClassDestory("HDCT01Controller")
    }

    // MARK: - 创建UI视图
    func setupUI() {

        createHeaderView()
        createtableView()
        createNavBar()

    }

    func createNavBar() {

        navView = UIView()
        navView?.backgroundColor = Constants.HDMainColor
        navView?.alpha = 0
        self.view.addSubview(navView!)

        navView?.snp.makeConstraints( { (make) -> Void in

            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(64)
            make.top.equalTo(0)

        })

        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 18)
        title.textColor = UIColor.white
        title.text = "我的"
        title.textAlignment = NSTextAlignment.center
        navView?.addSubview(title)

        unowned let WS = self
        title.snp.makeConstraints { (make) -> Void in

            make.top.equalTo(WS.navView!).offset(20)
            make.height.equalTo(44)
            make.width.equalTo(Constants.HDSCREENWITH)

        }

    }


    func createHeaderView() {

        unowned let WS = self

        /**
        *   背景图
        */
        headerBg = UIImageView(frame: CGRect(x: 0, y: -kHeadViewHeight, width: Constants.HDSCREENWITH, height: kHeadViewHeight))
        headerBg?.backgroundColor = UIColor.white
        headerBg?.image = UIImage(named: "bg02Icon")
        headerBg?.isUserInteractionEnabled = true

        /**
        *   头像
        */
        headerIcon = UIImageView()
        headerIcon?.layer.cornerRadius = Constants.HDSCREENWITH / 8;
        headerIcon?.layer.masksToBounds = true
        headerIcon?.layer.borderColor = UIColor.white.cgColor
        headerIcon?.layer.borderWidth = 1.5
        headerIcon?.image = UIImage(named: "defaultIcon")
        headerIcon?.backgroundColor = UIColor.red
        headerBg?.addSubview(headerIcon!)

        let tapGes = UITapGestureRecognizer(target: self, action: #selector(loginOrRegistAction))
        headerIcon?.isUserInteractionEnabled = true
        headerIcon?.addGestureRecognizer(tapGes)

        headerIcon?.snp.makeConstraints( { (make) -> Void in

            make.width.equalTo(Constants.HDSCREENWITH / 4)
            make.height.equalTo(Constants.HDSCREENWITH / 4)
            make.left.equalTo(WS.headerBg!).offset(Constants.HDSCREENWITH / 2 - Constants.HDSCREENWITH / 8)
            make.top.equalTo(WS.headerBg!).offset(80)
        })

        /**
        *   登录或注册
        */
        userName = UILabel()
        userName?.textColor = UIColor.white
        userName?.textAlignment = NSTextAlignment.center
        userName?.font = UIFont.systemFont(ofSize: 16)
        headerBg?.addSubview(userName!)

        userName?.snp.makeConstraints( { (make) -> Void in

            make.top.equalTo(WS.headerIcon!.snp.bottom).offset(5)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(30)
            make.left.equalTo(WS.headerBg!).offset(0)

        })

        //分割条
        sLine = UILabel()

        sLine?.backgroundColor = Constants.HDBGViewColor
        headerBg?.addSubview(sLine!)

        sLine?.snp.makeConstraints( { (make) -> Void in

            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(Constants.HDSpace)
            make.left.equalTo(0)
            make.bottom.equalTo(WS.headerBg!.snp.bottom).offset(0)

        })

        //显示关注 粉丝 好友 数量
        cntView = UIView()
        cntView?.backgroundColor = CoreUtils.HDColor(0, g: 0, b: 0, a: 0.4)
        cntView?.isHidden = true
        headerBg?.addSubview(cntView!)

        cntView?.snp.makeConstraints( { (make) -> Void in

            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(40)
            make.bottom.equalTo(WS.headerBg!.snp.bottom).offset(-10)

        })

        let space = Constants.HDSCREENWITH / 3
        for i in 0 ..< cntArray.count {

            let btn = UIButton(type: UIButtonType.custom)
            btn.tag = 1000 + i
            btn.setTitleColor(UIColor.white, for: UIControlState())
            btn.addTarget(self, action: #selector(cntAction(_:)), for: UIControlEvents.touchUpInside)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            cntView?.addSubview(btn)
            btn.snp.makeConstraints( { (make) -> Void in

                make.left.equalTo(WS.cntView!).offset(CGFloat(i) * space)
                make.top.equalTo(0)
                make.width.equalTo(space)
                make.height.equalTo(40)

            })

        }

        refreshUI()

    }

    func createtableView() {

        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(kHeadViewHeight, 0, 0, 0)
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        self.tableView.tableFooterView = UIView()
        self.tableView.addSubview(headerBg!)
        self.view.addSubview(self.tableView)

    }

    func refreshUI() {


        //判断用户是否已登录
        let defaults = UserDefaults.standard
        let sign = defaults.object(forKey: Constants.HDSign)

        if let _ = sign {

            cntView?.isHidden = false
            userName?.isHidden = false
            headerIcon?.isUserInteractionEnabled = false

            //关注 粉丝 好友

            let gzBtn = cntView?.viewWithTag(1000) as! UIButton
            gzBtn.setTitle(String(format: "关注: %d", HDUserInfoManager.shareInstance.followCnt!), for: UIControlState())

            let fsBtn = cntView?.viewWithTag(1001) as! UIButton
            fsBtn.setTitle(String(format: "粉丝: %d", HDUserInfoManager.shareInstance.fansCount!), for: UIControlState())

            let hyBtn = cntView?.viewWithTag(1002) as! UIButton
            hyBtn.setTitle(String(format: "好友: %d", HDUserInfoManager.shareInstance.friendCnt!), for: UIControlState())

            HDLog.LogOut(HDUserInfoManager.shareInstance.avatar!)

            userName?.text = HDUserInfoManager.shareInstance.userName

            headerIcon?.kf.setImage(with: URL(string: HDUserInfoManager.shareInstance.avatar!), placeholder: UIImage(named: "defaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

        } else {

            headerIcon?.image = UIImage(named: "defaultIcon")
            cntView?.isHidden = true
            userName?.isHidden = true
            headerIcon?.isUserInteractionEnabled = true
        }

    }

    // MARK: - 通知事件
    func ct01Notification(_ note: Notification) {


        let flag = (note as NSNotification).userInfo!["FLAG"] as? String

        if flag == "LOGIN" {

            /**
            *  用户登录
            */
            refreshUI()

        }

        if flag == "LOGOUT" {

            /**
            *   用户退出登录
            */
            refreshUI()

        }

    }

    // MARK: - private Methods



    // MARK: - events
    func loginOrRegistAction() {

        let hdct02VC = HDCT02Controller()
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdct02VC, animated: true)
        self.hidesBottomBarWhenPushed = false;
    }

    func cntAction(_ btn: UIButton) {

        switch(btn.tag) {

        case 1000:
            HDLog.LogOut("关注")
            break
        case 1001:
            HDLog.LogOut("粉丝")
            break
        case 1002:
            HDLog.LogOut("好友")
            break
        default:
            break
        }
    }

    // MARK: - UITableView delegate/datasource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ct01Array[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return ct01Array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        /**
         *  图标
         */
        var icon: UIImageView? = cell.viewWithTag(1000) as? UIImageView
        if icon == nil {

            icon = UIImageView()
            icon?.tag = 1000
            cell.contentView.addSubview(icon!)
            icon?.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(20)
                make.height.equalTo(20)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(12)

            })

        }


        /**
         *  名称
         */
        var title: UILabel? = cell.viewWithTag(2000) as? UILabel
        if title == nil {

            title = UILabel()
            title?.tag = 2000
            title?.textColor = Constants.HDMainTextColor
            title?.font = UIFont.systemFont(ofSize: 15)
            cell.contentView.addSubview(title!)
            title?.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(200)
                make.height.equalTo(44)
                make.left.equalTo(cell.contentView).offset(46)
                make.top.equalTo(cell.contentView).offset(0)
            })
        }

        /**
         *  箭头
         */
        var arrow: UIImageView? = cell.viewWithTag(3000) as? UIImageView
        if arrow == nil {

            arrow = UIImageView()
            arrow?.tag = 3000
            cell.contentView.addSubview(arrow!)

            arrow?.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(20)
                make.height.equalTo(20)
                make.right.equalTo(cell.contentView).offset(-20)
                make.top.equalTo(cell.contentView).offset(12)

            })

        }

        let array = ct01Array[(indexPath as NSIndexPath).section]
        icon?.image = UIImage(named: array[(indexPath as NSIndexPath).row]["image"]!)
        title?.text = array[(indexPath as NSIndexPath).row]["title"]
        arrow?.image = UIImage(named: "arrowIcon")

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //判断用户是否已登录
        let defaults = UserDefaults.standard
        let sign = defaults.object(forKey: Constants.HDSign)



        if (indexPath as NSIndexPath).row == 0 {

            if let _ = sign {

                //豆友
                let hdct08VC = HDCT08Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct08VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            } else {

                let hdct02VC = HDCT02Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct02VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            }


        } else if (indexPath as NSIndexPath).row == 1 {


            if let _ = sign {

                //动态
                let hdct10VC = HDCT10Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct10VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            } else {

                let hdct02VC = HDCT02Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct02VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            }


        } else if (indexPath as NSIndexPath).row == 2 {

            if let _ = sign {

                //话题
                let hdct09VC = HDCT09Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct09VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            } else {

                let hdct02VC = HDCT02Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct02VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            }

        } else if (indexPath as NSIndexPath).row == 3 {

            if let _ = sign {

                //消息
                let hdct11VC = HDCT11Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct11VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            } else {

                let hdct02VC = HDCT02Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct02VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            }


        } else {

            //设置
            let hdct06VC = HDCT06Controller()
            self.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(hdct06VC, animated: true)
            self.hidesBottomBarWhenPushed = false;
        }

    }

    // MARK: - UIScrollView Delegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        /**
        *  通过滚动视图获取到滚动偏移量从而去改变图片的变化
        */

        let yOffset = scrollView.contentOffset.y
        let xOffset = (yOffset + kHeadViewHeight) / 2

        if yOffset > -kHeadViewHeight {
            //上拉

            var ap = 1 - fabs(yOffset + 100) / CGFloat(180)

            if ap > 1 {

                ap = 1
            }

//            HDLog.LogOut("ap", obj: ap)

            navView?.alpha = ap

        } else {

            navView?.alpha = 0
        }

        if yOffset < -kHeadViewHeight {

            var rect = headerBg?.frame
            rect?.origin.y = yOffset
            rect?.size.height = -yOffset
            rect?.origin.x = xOffset
            rect?.size.width = Constants.HDSCREENWITH + fabs(xOffset) * 2
            headerBg?.frame = rect!

            headerIcon?.snp.updateConstraints({ (make) -> Void in

                make.left.equalTo(((rect?.width)! - 80) / 2)

            })

            userName?.snp.updateConstraints({ (make) -> Void in


                make.left.equalTo(((rect?.width)! - Constants.HDSCREENWITH) / 2)
            })

            sLine?.snp.updateConstraints({ (make) -> Void in

                make.left.equalTo(((rect?.width)! - Constants.HDSCREENWITH) / 2)
                make.bottom.equalTo(headerBg!.snp.bottom).offset(0)

            })

//            cntView?.snp.updateConstraints({ (make) -> Void in
//
//                make.left.equalTo(((rect?.width)! - Constants.HDSCREENWITH)/2)
//                make.bottom.equalTo(headerBg!.snp.bottom).offset(-10)
//
//            })

        }

    }

}

