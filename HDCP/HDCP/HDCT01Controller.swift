//
//  HDCT01ViewController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let ct01Array = [[["title":"我的菜谱","image":"WDCPIcon"],
    ["title":"我的收藏","image":"SCIcon"]],
    [["title":"扫一扫","image":"SYSCIcon"],
        ["title":"晒一晒","image":"SYSIcon"]],
    [["title":"动态","image":"DTIcon"],
        ["title":"设置","image":"SZIcon"]]]

class HDCT01Controller: UITableViewController {

    var headerView:UIView?
    var headerBg:UIImageView?
    var headerIcon:UIImageView?
    var loginBtn:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - 创建UI视图
    
    func setupUI(){
    
        
        headerView = UIView(frame: CGRectMake(0,0,Constants.HDSCREENWITH,160))
        headerView?.backgroundColor = UIColor.clearColor()
        
        /**
        *   背景图
        */
        headerBg = UIImageView()
        headerBg?.backgroundColor = UIColor.whiteColor()
        headerBg?.image = UIImage(named: "userBGIcon")
        headerView?.addSubview(headerBg!)
        
        headerBg?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(160)
            make.top.equalTo(headerView!).offset(0)
            make.left.equalTo(headerView!).offset(0)
            
        })
        
        /**
        *   头像
        */
        headerIcon = UIImageView()
        headerIcon?.layer.cornerRadius = 40;
        headerIcon?.layer.masksToBounds = true
        headerIcon?.image = UIImage(named: "noDataDefaultIcon")
        headerIcon?.backgroundColor = UIColor.redColor()
        headerView?.addSubview(headerIcon!)
        
        headerIcon?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.left.equalTo(headerView!).offset(Constants.HDSCREENWITH/2-40)
            make.top.equalTo(headerView!).offset(30)
        })
        
        /**
        *   登录或注册
        */
        loginBtn = UIButton()
        loginBtn?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginBtn?.setTitle("登录/注册", forState: UIControlState.Normal)
        loginBtn?.titleLabel?.font = UIFont.systemFontOfSize(16)
        loginBtn?.addTarget(self, action: "loginOrRegistAction:", forControlEvents: UIControlEvents.TouchUpInside)
        headerView?.addSubview(loginBtn!)
        
        loginBtn?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.top.equalTo(headerIcon!.snp_bottom).offset(5)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(40)
            make.left.equalTo(headerView!).offset(0)
            
        })
        
        self.tableView.tableHeaderView = headerView;
        self.tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK: - events
    func loginOrRegistAction(btn:UIButton){
    
        let hdct02VC = HDCT02Controller()
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdct02VC, animated: true)
        self.hidesBottomBarWhenPushed = false;
    }
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return ct01Array[section].count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 3
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        let cell = tableView .dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
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
            
            if indexPath.section == 2 {
            
                if indexPath.row == ct01Array[indexPath.section].count-1 {
                    
                    icon?.snp_updateConstraints(closure: { (make) -> Void in
                        
                        
                        make.width.equalTo(14)
                        make.height.equalTo(14)
                        make.left.equalTo(cell.contentView).offset(16)
                        make.top.equalTo(cell.contentView).offset(15)

                        
                    })
                    
                }
                
            }
        
        }
        
        
        /**
         *  名称
         */
        var title:UILabel? = cell.viewWithTag(2000) as? UILabel
        if title == nil {
            
            title = UILabel()
            title?.tag = 2000
            title?.textColor = Constants.HDMainTextColor
            title?.font = UIFont.systemFontOfSize(16)
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
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.HDSpace)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        if indexPath.section == 2 {
            
            if indexPath.row == 1 {
                
                let hdct06VC = HDCT06Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdct06VC, animated: true)
                self.hidesBottomBarWhenPushed = false;
                
            }
            
        }
        
    }

}

