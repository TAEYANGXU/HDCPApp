//
//  HDCT09Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDCT09Controller: UITableViewController {
    
    var response:HDCT09Response?
    
    var ct09GroupList = Array<HDCT09GroupModel>()
    var ct09HotList = Array<HDCT09HotModel>()
    var todayStar = Array<HDCT09TodayStarModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showHud()
        setupUI()
        doGetRequestData(0, offset: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "话题"
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
        
    }
    
    deinit{
    
        HDLog.LogClassDestory("HDCT09Controller")
    }
    
    // MARK: - 创建UI视图
    func setupUI(){
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "hotCell")
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "groupCell")
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "starCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
       
    }

    
    // MARK: - events
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    // MARK: - 提示动画显示和隐藏
    func showHud(){
        
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.view)
    }
    
    
    // MARK: - 数据加载
    func doGetRequestData(limit:Int,offset:Int){
        
        unowned let WS = self
        HDCT09Service().doGetRequest_HDCT09_URL(0, offset: 0, successBlock: { (hdResponse) -> Void in
            
            WS.hidenHud()
            WS.ct09HotList = (hdResponse.result?.ct09HotList)!
            WS.ct09GroupList = (hdResponse.result?.ct09GroupList)!
            WS.todayStar = (hdResponse.result?.todayStar)!
            WS.response = hdResponse
            WS.tableView.reloadData()
            
            }) { (error) -> Void in
                
                WS.hidenHud()
                CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return ct09HotList.count
        } else if section == 1 {
            
            return ct09GroupList.count
        } else {
            
            return 1;
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    
        return 3;
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.HDSpace*3)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headView = UIView(frame: CGRectMake(0,0,Constants.HDSCREENWITH,30))
        headView.backgroundColor = Constants.HDBGViewColor
        
        let icon = UIImageView()
        icon.layer.cornerRadius = 8;
        icon.layer.masksToBounds = true
        headView.addSubview(icon)
        icon.snp_makeConstraints { (make) in
            
            make.top.equalTo(7)
            make.left.equalTo(10)
            make.width.equalTo(16)
            make.height.equalTo(16)
            
        }
        
        //标题
        let title = UILabel()
        title.font = UIFont.systemFontOfSize(14)
        title.textColor = Constants.HDMainTextColor
        headView.addSubview(title)
        title.snp_makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.left.equalTo(icon.snp_right).offset(5)
            make.width.equalTo(100)
            make.height.equalTo(30)
            
        }
        
        let rightIcon = UIImageView()
        rightIcon.image = UIImage(named: "ArroIcon")
        headView.addSubview(rightIcon)
        
        rightIcon.snp_makeConstraints { (make) in
            
            make.top.equalTo(5)
            make.right.equalTo(-15)
            make.width.equalTo(20)
            make.height.equalTo(20)
            
        }
        
        if section == 0 {
            
            title.text = "实时热点"
            icon.image = UIImage(named: "hotIcon")
            
        }else if section == 1 {
        
            title.text = "话题小组"
            icon.image = UIImage(named: "groupIcon")
            
        }else{
        
            title.text = "活跃豆星"
            icon.image = UIImage(named: "starIcon")
        }
        
        return headView
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 100
        }else if indexPath.section == 1 {
        
            return 60
        }else{
        
            return 75
        }
        
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        
        if indexPath.section == 0 {
            
            let cell = tableView .dequeueReusableCellWithIdentifier("hotCell", forIndexPath: indexPath)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            //图片
            var hotImageV = cell.contentView.viewWithTag(1000) as? UIImageView
            
            if hotImageV == nil {
                
                hotImageV = UIImageView()
                hotImageV?.tag = 1000
                cell.contentView.addSubview(hotImageV!)
                
                hotImageV?.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(10)
                    make.left.equalTo(10)
                    make.width.equalTo(80)
                    make.height.equalTo(80)
                    
                })
                
            }
            
            //标题
            var title = cell.contentView.viewWithTag(2000) as? UILabel
            
            if title == nil {
                
                title = UILabel()
                title?.tag = 2000
                title?.font = UIFont.systemFontOfSize(15)
                title?.textColor = Constants.HDMainTextColor
                cell.contentView.addSubview(title!)
                
                title?.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(5)
                    make.left.equalTo(hotImageV!.snp_right).offset(10)
                    make.width.equalTo(Constants.HDSCREENWITH - 110)
                    make.height.equalTo(20)
                    
                })
                
            }
            
            //头像
            
            var uIcon = cell.contentView.viewWithTag(3000) as? UIImageView
            
            if uIcon == nil {
                
                uIcon = UIImageView()
                uIcon?.tag = 3000
                uIcon?.layer.cornerRadius = 7.5
                uIcon?.layer.masksToBounds = true
                cell.contentView.addSubview(uIcon!)
                
                uIcon?.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(title!.snp_bottom).offset(0)
                    make.left.equalTo(hotImageV!.snp_right).offset(10)
                    make.width.equalTo(15)
                    make.height.equalTo(15)
                    
                })
                
            }
            
            //名称
            
            var userName = cell.contentView.viewWithTag(4000) as? UILabel
            
            if userName == nil {
                
                userName = UILabel()
                userName?.tag = 4000
                userName?.font = UIFont.systemFontOfSize(12)
                userName?.textColor = UIColor.lightGrayColor()
                cell.contentView.addSubview(userName!)
                
                userName?.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(title!.snp_bottom).offset(0)
                    make.left.equalTo(uIcon!.snp_right).offset(10)
                    make.width.equalTo(200)
                    make.height.equalTo(15)
                    
                })

            }
            
            //内容
            var content = cell.contentView.viewWithTag(5000) as? UILabel
            
            if content == nil {
                
                content = UILabel()
                content?.tag = 5000
                content?.font = UIFont.systemFontOfSize(14)
                content?.numberOfLines = 2
                content?.textColor = UIColor.lightGrayColor()
                cell.contentView.addSubview(content!)
                
                content?.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(userName!.snp_bottom).offset(0)
                    make.left.equalTo(hotImageV!.snp_right).offset(10)
                    make.width.equalTo(Constants.HDSCREENWITH - 110)
                    make.height.equalTo(35)
                    
                })
                
            }
            
            //赞
            var digIcon = cell.contentView.viewWithTag(6000) as? UIImageView
            
            if digIcon == nil {
                
                digIcon = UIImageView()
                digIcon?.tag = 6000
                digIcon?.image = UIImage(named: "zanIcon")
                cell.contentView.addSubview(digIcon!)
                
                digIcon?.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(content!.snp_bottom).offset(1)
                    make.left.equalTo(hotImageV!.snp_right).offset(10)
                    make.width.equalTo(15)
                    make.height.equalTo(15)
                    
                })
                
            }
            
            var digCount = cell.contentView.viewWithTag(7000) as? UILabel
            
            if digCount == nil {
                
                digCount = UILabel()
                digCount?.tag = 7000
                digCount?.font = UIFont.systemFontOfSize(12)
                digCount?.textColor = UIColor.lightGrayColor()
                cell.contentView.addSubview(digCount!)
                digCount?.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(content!.snp_bottom).offset(1)
                    make.left.equalTo(digIcon!.snp_right).offset(5)
                    make.width.equalTo(25)
                    make.height.equalTo(15)
                    
                })
            }
            
            //评论
            var commentIcon = cell.contentView.viewWithTag(8000) as? UIImageView
            
            if commentIcon == nil {
                
                commentIcon = UIImageView()
                commentIcon?.tag = 8000
                commentIcon?.image = UIImage(named: "commIcon")
                cell.contentView.addSubview(commentIcon!)
                
                commentIcon?.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(content!.snp_bottom).offset(1)
                    make.left.equalTo(digCount!.snp_right).offset(0)
                    make.width.equalTo(15)
                    make.height.equalTo(15)
                    
                })
                
            }
            
            var commentCount = cell.contentView.viewWithTag(9000) as? UILabel
            
            if commentCount == nil {
                
                commentCount = UILabel()
                commentCount?.tag = 9000
                commentCount?.font = UIFont.systemFontOfSize(12)
                commentCount?.textColor = UIColor.lightGrayColor()
                cell.contentView.addSubview(commentCount!)
                commentCount?.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(content!.snp_bottom).offset(1)
                    make.left.equalTo(commentIcon!.snp_right).offset(5)
                    make.width.equalTo(60)
                    make.height.equalTo(15)
                    
                })
            }
            
            
            let model = ct09HotList[indexPath.row]
            
            hotImageV?.sd_setImageWithURL(NSURL(string: model.img), placeholderImage: UIImage(named: "noDataDefaultIcon"))
            uIcon?.sd_setImageWithURL(NSURL(string: model.avatar), placeholderImage: UIImage(named: "defaultIcon"))
            userName?.text = model.userName
            content?.text = model.previewContent
            title?.text = model.title
            digCount?.text = String(format: "%d",model.digCount)
            commentCount?.text = String(format: "%d",model.commentCount)
            
            return cell
        }else if indexPath.section == 1 {
            
            let cell = tableView .dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            //图片
            var topicImageV = cell.contentView.viewWithTag(1000) as? UIImageView
            if topicImageV == nil {
                
                topicImageV = UIImageView()
                topicImageV?.tag = 1000
                cell.contentView.addSubview(topicImageV!)
                
                topicImageV?.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(5)
                    make.left.equalTo(10)
                    make.width.equalTo(50)
                    make.height.equalTo(50)
                })
                
                
            }
            
            //标题
            var title = cell.contentView.viewWithTag(2000) as? UILabel
            
            if title == nil {
                
                title = UILabel()
                title?.tag = 2000
                title?.font = UIFont.systemFontOfSize(15)
                title?.textColor = Constants.HDMainTextColor
                cell.contentView.addSubview(title!)
                
                title?.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(5)
                    make.left.equalTo(topicImageV!.snp_right).offset(10)
                    make.width.equalTo(Constants.HDSCREENWITH - 210)
                    make.height.equalTo(20)
                    
                })
                
            }
            
            //围观人数
            var ViewDesc = cell.contentView.viewWithTag(3000) as? UILabel
            
            if ViewDesc == nil {
                
                ViewDesc = UILabel()
                ViewDesc?.tag = 3000
                ViewDesc?.textAlignment = NSTextAlignment.Right
                ViewDesc?.font = UIFont.systemFontOfSize(12)
                ViewDesc?.textColor = Constants.HDMainTextColor
                cell.contentView.addSubview(ViewDesc!)
                
                ViewDesc?.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(5)
                    make.right.equalTo(-10)
                    make.width.equalTo(Constants.HDSCREENWITH - 210)
                    make.height.equalTo(20)
                    
                })
                
            }
            
            
            //内容
            var desc = cell.contentView.viewWithTag(4000) as? UILabel
            
            if desc == nil {
                
                desc = UILabel()
                desc?.tag = 4000
                desc?.font = UIFont.systemFontOfSize(14)
                desc?.textColor = Constants.HDMainTextColor
                cell.contentView.addSubview(desc!)
                
                desc?.snp_makeConstraints(closure: { (make) in
                    
                    make.top.equalTo(title!.snp_bottom).offset(10)
                    make.left.equalTo(topicImageV!.snp_right).offset(10)
                    make.width.equalTo(Constants.HDSCREENWITH - 80)
                    make.height.equalTo(20)
                    
                })
                
            }
            
            //分割线
            var line = cell.contentView.viewWithTag(5000)
            
            if line == nil {
                
                line = UIView()
                line?.tag = 5000
                line?.backgroundColor = Constants.HDBGViewColor
                cell.contentView.addSubview(line!)
                line?.snp_makeConstraints(closure: { (make) in
                    
                    make.width.equalTo(Constants.HDSCREENWITH-10)
                    make.left.equalTo(10)
                    make.height.equalTo(1)
                    make.bottom.equalTo(0)
                    
                })
                
            }
            
            let model = ct09GroupList[indexPath.row]
            
            topicImageV?.sd_setImageWithURL(NSURL(string: model.img), placeholderImage: UIImage(named: "noDataDefaultIcon"))
            title?.text = model.name
            ViewDesc?.text = model.viewDesc
            desc?.text = model.desc
            
            return cell
        }else{
            
            let cell = tableView .dequeueReusableCellWithIdentifier("starCell", forIndexPath: indexPath)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            
            if todayStar.count > 0 {
            
                let space = (Constants.HDSCREENWITH - 200)/10
                
                for i in 0 ..< todayStar.count {
                    
                    let model = todayStar[i]
                    
                    var icon = cell.contentView.viewWithTag(1000+i) as? UIImageView
                    
                    if icon == nil {
                        
                        icon = UIImageView()
                        icon?.tag = 1000+i
                        icon?.layer.cornerRadius = 20
                        icon?.layer.masksToBounds = true
                        cell.contentView.addSubview(icon!)
                        
                        icon?.snp_makeConstraints(closure: { (make) in
                            
                            make.top.equalTo(10)
                            make.left.equalTo(CGFloat(i)*(2*space+40)+space)
                            make.width.equalTo(40)
                            make.height.equalTo(40)
                            
                        })
                        
                    }
                    
                    var username = cell.contentView.viewWithTag(2000+i) as? UILabel
                    
                    if username == nil {
                        
                        username = UILabel()
                        username?.tag = 2000+i
                        username?.font = UIFont.systemFontOfSize(11)
                        username?.textAlignment = NSTextAlignment.Center
                        username?.textColor = Constants.HDMainTextColor
                        cell.contentView.addSubview(username!)
                        
                        username?.snp_makeConstraints(closure: { (make) in
                            
                            make.top.equalTo(icon!.snp_bottom).offset(5)
                            make.left.equalTo(CGFloat(i)*Constants.HDSCREENWITH/5)
                            make.width.equalTo(Constants.HDSCREENWITH/5)
                            make.height.equalTo(20)
                            
                        })
                        
                        
                    }
                    
                    icon?.sd_setImageWithURL(NSURL(string: model.avatar), placeholderImage: UIImage(named: "defaultIcon"))
                    //去空格
                    let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    username?.text = model.userName.stringByTrimmingCharactersInSet(whitespace)
                    
                }
                
            }
            
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
}
