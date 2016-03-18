//
//  HDCT01ViewController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let ct01Array = [[["title":"豆友","image":"DYIcon"],
    ["title":"动态","image":"DTIcon"],["title":"话题","image":"HTIcon"],
    ["title":"消息","image":"msgIcon"],["title":"设置","image":"SZIcon"]]]

private let cntArray = ["关注","粉丝","好友"]

private let kHeadViewHeight:CGFloat = 260

class HDCT01Controller: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {

    enum BTNTag: Int {
        case GZ = 1000 , FS, HY
    }
    
    var tableView:UITableView!
    var headerBg:UIImageView?
    var headerIcon:UIImageView?
    var userName:UILabel?
    var sLine:UILabel?
    var cntView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge.None;
        self.extendedLayoutIncludesOpaqueBars = false;
        self.modalPresentationCapturesStatusBarAppearance = false;
        self.automaticallyAdjustsScrollViewInsets = true;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ct01Notification:", name: Constants.HDREFRESHHDCT01, object: nil)
        
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    deinit{
    
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.HDREFRESHHDCT01, object: nil)
        
    }
    
    // MARK: - 创建UI视图
    func setupUI(){
        
        createHeaderView()
        createtableView()
    
    }
    
    
    func createHeaderView(){
    
        /**
        *   背景图
        */
        headerBg = UIImageView(frame: CGRectMake(0,-kHeadViewHeight,Constants.HDSCREENWITH,kHeadViewHeight))
        headerBg?.backgroundColor = UIColor.whiteColor()
        headerBg?.image = UIImage(named: "bg02Icon")
        headerBg?.userInteractionEnabled = true
        
        /**
        *   头像
        */
        headerIcon = UIImageView()
        headerIcon?.layer.cornerRadius = 40;
        headerIcon?.layer.masksToBounds = true
        headerIcon?.layer.borderColor = UIColor.whiteColor().CGColor
        headerIcon?.layer.borderWidth = 1.5
        headerIcon?.image = UIImage(named: "defaultIcon")
        headerIcon?.backgroundColor = UIColor.redColor()
        headerBg?.addSubview(headerIcon!)
        
        let tapGes = UITapGestureRecognizer(target: self, action: "loginOrRegistAction")
        headerIcon?.userInteractionEnabled = true
        headerIcon?.addGestureRecognizer(tapGes)
        
        headerIcon?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.left.equalTo(headerBg!).offset(Constants.HDSCREENWITH/2-40)
            make.top.equalTo(headerBg!).offset(80)
        })
        
        /**
        *   登录或注册
        */
        userName = UILabel()
        userName?.textColor = UIColor.whiteColor()
        userName?.textAlignment = NSTextAlignment.Center
        userName?.font = UIFont.systemFontOfSize(16)
        headerBg?.addSubview(userName!)
        
        userName?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.top.equalTo(headerIcon!.snp_bottom).offset(5)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(30)
            make.left.equalTo(headerBg!).offset(0)
            
        })
        
        //分割条
        sLine = UILabel()
        
        sLine?.backgroundColor = Constants.HDBGViewColor
        headerBg?.addSubview(sLine!)
        
        sLine?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(Constants.HDSpace)
            make.left.equalTo(0)
            make.bottom.equalTo(headerBg!.snp_bottom).offset(0)
            
        })
        
        //显示关注 粉丝 好友 数量
        cntView = UIView()
        cntView?.backgroundColor = Constants.HDColor(0, g: 0, b: 0, a: 0.4)
        cntView?.hidden = true
        headerBg?.addSubview(cntView!)
        
        cntView?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(40)
            make.bottom.equalTo(headerBg!.snp_bottom).offset(-10)
            
        })
        
        let space = Constants.HDSCREENWITH/3
        for var i=0;i<cntArray.count;i++ {
        
            let btn = UIButton(type: UIButtonType.Custom)
            btn.tag = 1000 + i
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btn.addTarget(self, action: "cntAction:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.titleLabel?.font = UIFont.systemFontOfSize(14)
            cntView?.addSubview(btn)
            btn.snp_makeConstraints(closure: { (make) -> Void in
                
                make.left.equalTo(cntView!).offset(CGFloat(i)*space)
                make.top.equalTo(0)
                make.width.equalTo(space)
                make.height.equalTo(40)
                
            })
            
        }
        
        refreshUI()
        
    }
    
    func createtableView(){
    
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(kHeadViewHeight, 0, 0, 0)
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        self.tableView.tableFooterView = UIView()
        self.tableView.addSubview(headerBg!)
        self.view.addSubview(self.tableView)
        
    }
    
    func refreshUI(){
    
        
        //判断用户是否已登录
        let defaults = NSUserDefaults.standardUserDefaults()
        let sign = defaults.objectForKey(Constants.HDSign)
        
        if let _ = sign {
            
            cntView?.hidden = false
            userName?.hidden = false
            
            //关注 粉丝 好友
            
            let gzBtn = cntView?.viewWithTag(1000) as! UIButton
            gzBtn.setTitle(String(format: "关注: %d", HDUserInfoManager.shareInstance.followCnt!), forState: UIControlState.Normal)
            
            let fsBtn = cntView?.viewWithTag(1001) as! UIButton
            fsBtn.setTitle(String(format: "粉丝: %d", HDUserInfoManager.shareInstance.fansCount!), forState: UIControlState.Normal)
            
            let hyBtn = cntView?.viewWithTag(1002) as! UIButton
            hyBtn.setTitle(String(format: "好友: %d", HDUserInfoManager.shareInstance.friendCnt!), forState: UIControlState.Normal)
            
            HDLog.LogOut(HDUserInfoManager.shareInstance.avatar!)
            
            userName?.text = HDUserInfoManager.shareInstance.userName
            headerIcon?.sd_setImageWithURL(NSURL(string: HDUserInfoManager.shareInstance.avatar!), placeholderImage: UIImage(named: "defaultIcon"))
            
        }else{
        
            headerIcon?.image = UIImage(named: "defaultIcon")
            cntView?.hidden = true
            userName?.hidden = true
        }
        
    }
    
    // MARK: - 通知事件
    func ct01Notification(note:NSNotification){
    
        
        let flag = note.userInfo!["FLAG"] as? String
        
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
    
    // MARK: - events
    func loginOrRegistAction(){
    
        let hdct02VC = HDCT02Controller()
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdct02VC, animated: true)
        self.hidesBottomBarWhenPushed = false;
    }
    
    func cntAction(btn:UIButton){
    
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
            ""
        }
    }
    
    // MARK: - UITableView delegate/datasource
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return ct01Array[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return ct01Array.count
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        let cell = tableView .dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        /**
         *  图标
         */
        var icon:UIImageView? = cell.viewWithTag(1000) as? UIImageView
        if icon == nil {
            
            icon = UIImageView()
            icon?.tag = 1000
            cell.contentView.addSubview(icon!)
            icon?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(20)
                make.height.equalTo(20)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(12)
                
            })
        
        }
        
        
        /**
         *  名称
         */
        var title:UILabel? = cell.viewWithTag(2000) as? UILabel
        if title == nil {
            
            title = UILabel()
            title?.tag = 2000
            title?.textColor = Constants.HDMainTextColor
            title?.font = UIFont.systemFontOfSize(15)
            cell.contentView.addSubview(title!)
            title?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(200)
                make.height.equalTo(44)
                make.left.equalTo(cell.contentView).offset(46)
                make.top.equalTo(cell.contentView).offset(0)
            })
        }
        
        /**
         *  箭头
         */
        var arrow:UIImageView? = cell.viewWithTag(3000) as? UIImageView
        if arrow == nil {
            
            arrow = UIImageView()
            arrow?.tag = 3000
            cell.contentView.addSubview(arrow!)
            
            arrow?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(20)
                make.height.equalTo(20)
                make.right.equalTo(cell.contentView).offset(-20)
                make.top.equalTo(cell.contentView).offset(12)
                
            })
            
        }
        
        let array = ct01Array[indexPath.section]
        icon?.image = UIImage(named: array[indexPath.row]["image"]!)
        title?.text =   array[indexPath.row]["title"]
        arrow?.image = UIImage(named: "arrowIcon")
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //判断用户是否已登录
        let defaults = NSUserDefaults.standardUserDefaults()
        let sign = defaults.objectForKey(Constants.HDSign)
        
        
        
        if indexPath.row == 0 {
            
            if let _ = sign {
            
                //豆友
                let hdct08VC = HDCT08Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct08VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            }else{
            
                let hdct02VC = HDCT02Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct02VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            }
            
            
        }else if indexPath.row == 1 {
            
            
            if let _ = sign {
                
                //动态
                let hdct09VC = HDCT09Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct09VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            }else{
                
                let hdct02VC = HDCT02Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct02VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            }

            
        }else if indexPath.row == 2 {
            
            if let _ = sign {
                
                //话题
                let hdct10VC = HDCT10Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct10VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            }else{
                
                let hdct02VC = HDCT02Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct02VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            }
            
        }else if indexPath.row == 3 {
            
            if let _ = sign {
                
                //消息
                let hdct11VC = HDCT11Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct11VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            }else{
                
                let hdct02VC = HDCT02Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct02VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
            }

            
        }else{
        
            //设置
            let hdct06VC = HDCT06Controller()
            self.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(hdct06VC, animated: true)
            self.hidesBottomBarWhenPushed = false;
        }
        
    }
    
    // MARK: - UIScrollView Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        /**
        *  通过滚动视图获取到滚动偏移量从而去改变图片的变化
        */
        
        let yOffset = scrollView.contentOffset.y
        let xOffset = (yOffset + kHeadViewHeight)/2
        
        if yOffset < -kHeadViewHeight {
        
            var rect = headerBg?.frame
            rect?.origin.y = yOffset
            rect?.size.height = -yOffset
            rect?.origin.x = xOffset
            rect?.size.width = Constants.HDSCREENWITH + fabs(xOffset)*2
            headerBg?.frame = rect!
            
            headerIcon?.snp_updateConstraints(closure: { (make) -> Void in
                
                make.left.equalTo(((rect?.width)! - 80)/2)
                
            })
            
            userName?.snp_updateConstraints(closure: { (make) -> Void in
                
                
                make.left.equalTo(((rect?.width)! - Constants.HDSCREENWITH)/2)
            })
            
            sLine?.snp_updateConstraints(closure: { (make) -> Void in
                
                make.left.equalTo(((rect?.width)! - Constants.HDSCREENWITH)/2)
                make.bottom.equalTo(headerBg!.snp_bottom).offset(0)
                
            })
            
            cntView?.snp_updateConstraints(closure: { (make) -> Void in
                
                make.left.equalTo(((rect?.width)! - Constants.HDSCREENWITH)/2)
                make.bottom.equalTo(headerBg!.snp_bottom).offset(-10)
                
            })
            
        }
        
    }

}

