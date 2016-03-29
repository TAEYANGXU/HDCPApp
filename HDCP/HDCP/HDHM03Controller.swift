//
//  HDHM03Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/13.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM03Controller: UITableViewController {

    var dataArray:NSMutableArray!
    var offset:Int!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        offset = 0
        dataArray  = NSMutableArray()
        
        setupUI()
        showHud()
        doGetRequestData(10,offset: offset)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "营养餐桌"
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){

        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        
        //当列表滚动到底端 视图自动刷新
        self.tableView?.mj_footer = HDRefreshGifFooter(refreshingBlock: { () -> Void in
            self.doGetRequestData(10,offset: self.offset)
        })
        
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
    
    // MARK: - 数据加载
    func doGetRequestData(limit:Int,offset:Int){
    
        HDHM03Service().doGetRequest_HDHM03_URL(limit, offset: offset, successBlock: { (hdResponse) -> Void in
            
            
                self.offset = self.offset+10
            
                self.hidenHud()
            
                self.dataArray.addObjectsFromArray(hdResponse.result.list)
            
                self.tableView.mj_footer.endRefreshing()
            
                self.tableView.reloadData()
            
            
            }) { (error) -> Void in
                
                self.tableView.mj_footer.endRefreshing()
                CoreUtils.showWarningHUD(self.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return self.dataArray.count
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        let cell = tableView .dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        /// 图片
        var hm03ImageView = cell.viewWithTag(1000) as? UIImageView
        
        if hm03ImageView == nil {
        
            hm03ImageView = UIImageView()
            hm03ImageView?.backgroundColor = UIColor.redColor()
            hm03ImageView?.tag = 1000
            cell.contentView.addSubview(hm03ImageView!)
            
            hm03ImageView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(cell.contentView).offset(5)
                make.left.equalTo(cell.contentView).offset(15)
                make.width.equalTo(Constants.HDSCREENWITH-30)
                make.height.equalTo(120)
                
            })
            
        }
        
        /// 名称
        var title = cell.viewWithTag(2000) as? UILabel
        
        if title == nil {
        
            title = UILabel()
            title?.tag = 2000
            title?.font = UIFont.systemFontOfSize(15)
            title?.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title!)
            
            title?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(hm03ImageView!.snp_bottom).offset(0)
                make.left.equalTo(cell.contentView).offset(15)
                make.width.equalTo(Constants.HDSCREENWITH-30)
                make.height.equalTo(20)
                
            })
            
        }
        
        /// 内容说明
        var content = cell.viewWithTag(3000) as? UILabel
        
        if content == nil {
        
            content = UILabel()
            content?.tag = 3000
            content?.numberOfLines = 2
            content?.font = UIFont.systemFontOfSize(14)
            content?.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(content!)
            
            content?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(title!.snp_bottom).offset(0)
                make.left.equalTo(cell.contentView).offset(15)
                make.width.equalTo(Constants.HDSCREENWITH-30)
                make.height.equalTo(40)
                
            })
            
        }
        
        /// 设置UI内容
        let model = dataArray[indexPath.row] as! HDHM03List
        hm03ImageView?.sd_setImageWithURL(NSURL(string: model.image!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        title?.text = model.title
        content?.text = model.content
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 185
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /**
        *   根据URL显示web页面
        */
        let hdWebVC = HDWebController()
        let model = dataArray[indexPath.row] as! HDHM03List
        self.hidesBottomBarWhenPushed = true;
        hdWebVC.name = model.title
        hdWebVC.url = model.url
        self.navigationController?.pushViewController(hdWebVC, animated: true)
        
    }
}
