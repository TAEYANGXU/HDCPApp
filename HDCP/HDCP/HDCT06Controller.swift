//
//  HDCT06Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/2/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let ct06ArrayLogin = [[["title":"社交绑定"],
    ["title":"消息设置"],["title":"隐私设置"],["title":"账号安全"]],
    [["title":"夜间模式"],
        ["title":"2G/3G/4G下展示图片"],["title":"开启摇一摇震动"],["title":"清理缓存"]],
    [["title":"关于"],
        ["title":"意见反馈"],["title":"给我们评星"]],[["title":"退出登录"]],[]]

private let titleArrayLogin = ["个人","通用","支持","",""]

class HDCT06Controller: UITableViewController{
    
    var ct06Array = [[["title":"社交绑定"],
        ["title":"消息设置"],["title":"隐私设置"],["title":"账号安全"]],
        [["title":"夜间模式"],
            ["title":"2G/3G/4G下展示图片"],["title":"开启摇一摇震动"],["title":"清理缓存"]],
        [["title":"关于"],
            ["title":"意见反馈"],["title":"给我们评星"]],[]]
    var titleArray = ["个人","通用","支持",""]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let sign = defaults.objectForKey(Constants.HDSign)
        
        if let _ = sign {
        
            self.ct06Array = ct06ArrayLogin
            self.titleArray = titleArrayLogin
            
        }
        
        setupUI()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
    }
    
    // MARK: - events
    
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        self.tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return ct06Array[section].count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return titleArray.count
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        let cell = tableView .dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
    
        

        /**
         *  名称
         */
        var title:UILabel? = cell.viewWithTag(2000) as? UILabel
        if title == nil {
            
            title = UILabel()
            title?.tag = 2000
            
            title?.font = UIFont.systemFontOfSize(16)
            cell.contentView.addSubview(title!)
            title?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(200)
                make.height.equalTo(44)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(0)
            })
        }
        
        
        let array = ct06Array[indexPath.section]
        title?.text =   array[indexPath.row]["title"]
        
        if indexPath.section == 3 {
            
            /**
             *  名称
             */
            title?.textColor = UIColor.redColor()
            title?.textAlignment = NSTextAlignment.Center
            title?.backgroundColor = UIColor.whiteColor()
            cell.backgroundColor = UIColor.clearColor()
            
            title?.snp_updateConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(44)
                make.left.equalTo(cell.contentView).offset(0)
                make.top.equalTo(cell.contentView).offset(0)
            })
            
        }else{
            
            title?.textColor = Constants.HDMainTextColor
            title?.textAlignment = NSTextAlignment.Left
            cell.backgroundColor = UIColor.whiteColor()
            
            title?.snp_updateConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(200)
                make.height.equalTo(44)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(0)
            })
            
        }
        
        if indexPath.section == 1 || indexPath.section == 3 {
        
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            
        }else{
            
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.HDSpace*4)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleView = UIView(frame: CGRectMake(0,0,Constants.HDSCREENWITH,40))
        titleView.backgroundColor = Constants.HDBGViewColor
        let title = UILabel(frame: CGRectMake(16,0,Constants.HDSCREENWITH,40))
        title.font = UIFont.systemFontOfSize(13)
        title.text = titleArray[section]
        titleView.addSubview(title)
        
        return titleView
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        if indexPath.section == 3 {
            
            HDLog.LogOut("退出登录")
            
            HDUserInfoManager.shareInstance.clear()
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.HDREFRESHHDCT01, object: nil, userInfo: ["FLAG":"LOGOUT"])
            
            for vc in (self.navigationController?.viewControllers)! {
            
                if vc.isMemberOfClass(HDCT01Controller.classForCoder()){
                
                    self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
                
            }
        }
    }
}
