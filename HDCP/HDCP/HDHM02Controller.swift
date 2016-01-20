//
//  HDHM02Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/12.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM02Controller: UITableViewController {

    
    var hdHM02Response:HDHM02Response!
    var dataArray:Array<HDHM02List>!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dataArray = Array<HDHM02List>()
        
        setupUI()
        
        doGetRequestData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "排行榜"
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
    }
    
    
    
    // MARK: - 创建UI视图
    
    func setupUI(){
    
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        
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
    
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func didHeaderView(ges:UITapGestureRecognizer){
    
        
        let headerView = ges.view
        let tag = (headerView?.tag)! - 100
        
        let model:HDHM02List =  dataArray[tag]
        
        if model.isShow == true {
            //显示则隐藏
            model.isShow = false
        }else{
            //隐藏则显示
            model.isShow = true
        }
        
        dataArray[tag] = model
        
        //刷新指定组
        self.tableView.reloadSections(NSIndexSet(index: tag), withRowAnimation: UITableViewRowAnimation.Fade)
        
        
    }
    
    // MARK: - 数据加载
    func doGetRequestData(){
        
        
        showHud()
        
        HDHM02Service().doGetRequest_HDHM02_URL({ (hdHM02Response) -> Void in
            
            self.hidenHud()
            self.dataArray = hdHM02Response.result?.recipeList!
            self.hdHM02Response = hdHM02Response
            self.tableView!.reloadData()
            
            
            }) { (error) -> Void in
                
                self.tableView?.mj_header.endRefreshing()
                CoreUtils.showWarningHUD(self.view, title: Constants.HD_NO_NET_MSG)
                
        }
        
        
    }
    
    // MARK: - UITableView delegate
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        let model:HDHM02List = dataArray[section]
        
        
        if model.isShow == true {
            
            return (model.recipe?.count)!
        }else{
            
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.dataArray.count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let model:HDHM02List = dataArray[section]
        
        let headerView = UIView(frame: CGRectMake(0,0,Constants.HDSCREENWITH,49))
        headerView.backgroundColor = UIColor.whiteColor()
        
        /// 名称
        let title = UILabel()
        title.font = UIFont.systemFontOfSize(16)
        title.textColor = Constants.HDMainTextColor
        title.text = model.title
        headerView.addSubview(title)
        
        title.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(headerView).offset(16)
            make.top.equalTo(headerView).offset(5)
            make.height.equalTo(40)
            make.width.equalTo(Constants.HDSCREENWITH-100)
            
        }
        
        /// 箭头
        let arrowView = UIImageView()
        
        if model.isShow == true {

            arrowView.image = UIImage(named: "arrowTopIcon")
        }else{
        
            arrowView.image = UIImage(named: "arrowBottomIcon")
        }
        
        headerView.addSubview(arrowView)
        
        arrowView.snp_makeConstraints { (make) -> Void in
            
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.left.equalTo(headerView).offset(Constants.HDSCREENWITH-40)
            make.top.equalTo(headerView).offset(15)
            
        }
        
        
        let lineTopView = UIView()
        lineTopView.backgroundColor = Constants.HDBGViewColor
        headerView.addSubview(lineTopView)
        
        lineTopView.snp_makeConstraints { (make) -> Void in
            
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(Constants.HDSpace/2)
            make.left.equalTo(headerView).offset(0)
            make.top.equalTo(headerView).offset(0)
            
        }


        let lineBottomView = UIView()
        lineBottomView.backgroundColor = Constants.HDBGViewColor
        headerView.addSubview(lineBottomView)
        
        lineBottomView.snp_makeConstraints { (make) -> Void in
            
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(Constants.HDSpace/2)
            make.left.equalTo(headerView).offset(0)
            make.top.equalTo(headerView).offset(50-Constants.HDSpace/2)
            
        }
        
        headerView.tag = section+100
        let tapGes = UITapGestureRecognizer(target: self, action: "didHeaderView:")
        headerView.gestureRecognizers = [tapGes]
        
        
        return headerView
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        
        let cell = tableView .dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        /// 图标
        var icon =  cell.contentView.viewWithTag(1000) as? UIImageView
        
        if icon == nil {
        
            icon = UIImageView()
            icon?.tag = 1000
            cell.contentView.addSubview(icon!)
            
            icon?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(24)
                make.height.equalTo(24)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(10)
                
            })
            
            
        }
        
        /// 排名
        var num =  cell.contentView.viewWithTag(2000) as? UILabel
        
        if num == nil {
        
            num = UILabel()
            num?.tag = 2000
            num?.textAlignment = NSTextAlignment.Center
            num?.textColor = UIColor.whiteColor()
            num!.font = UIFont.systemFontOfSize(13)
            cell.contentView.addSubview(num!)
            
            num?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(20)
                make.height.equalTo(20)
                make.left.equalTo(cell.contentView).offset(18)
                make.top.equalTo(12)
                
            })
            
        }
        
        /// 菜谱名称
        var title =  cell.contentView.viewWithTag(3000) as? UILabel
        
        if title == nil {
        
            title = UILabel()
            title?.tag = 3000
            title!.font = UIFont.systemFontOfSize(15)
            title!.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title!)
            
            title?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.left.equalTo(icon!.snp_right).offset(10)
                make.top.equalTo(cell.contentView).offset(0)
                make.bottom.equalTo(cell.contentView).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH-140)
                
            })
            
        }
        
        /// 访问人数
        var rconut =  cell.contentView.viewWithTag(4000) as? UILabel
        
        if rconut == nil {
            
            rconut = UILabel()
            rconut?.tag = 4000
            rconut!.font = UIFont.systemFontOfSize(14)
            rconut!.textAlignment = NSTextAlignment.Right
            rconut!.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(rconut!)
            
            rconut?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.left.equalTo(cell.contentView).offset(Constants.HDSCREENWITH-100)
                make.top.equalTo(cell.contentView).offset(0)
                make.bottom.equalTo(cell.contentView).offset(0)
                make.width.equalTo(80)
                
            })
            
        }
        
        //赋值
        let model:HDHM02List = dataArray[indexPath.section]
        let repice:HDHM02RecipeModel = model.recipe![indexPath.row]
        
        title?.text = repice.title
        rconut!.text = String(format: "%ld", repice.viewCount!)
        
        
        /**
        *   根据排名 显示不同的Icon
        */
        
        if indexPath.row == 0 {
            
            /// 第一名
            icon?.image = UIImage(named: "HM02OneIcon")
            //防止复用
            num?.text = ""
            
        }else if indexPath.row == 1 {
        
            /// 第二名
            icon?.image = UIImage(named: "HM02TwoIcon")
            num?.text = String(format: "%ld", indexPath.row+1)
        }else if indexPath.row == 2 {
        
            /// 第三名
            icon?.image = UIImage(named: "HM02ThreeIcon")
            num?.text = String(format: "%ld", indexPath.row+1)
        }else{
        
            /// 其他
            icon?.image = UIImage(named: "HM02FourIcon")
            num?.text = String(format: "%ld", indexPath.row+1)
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model:HDHM02List = dataArray[indexPath.section]
        let repice:HDHM02RecipeModel = model.recipe![indexPath.row]
        
        let hdHM08VC = HDHM08Controller()
        hdHM08VC.rid = repice.recipeId
        hdHM08VC.name = repice.title
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdHM08VC, animated: true)
        
        
    }
}
