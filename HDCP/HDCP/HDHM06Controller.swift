//
//  HDHM06Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/15.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM06Controller: UITableViewController {

    var dataArray:NSMutableArray!
    var offset:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        offset = 0
        dataArray  = NSMutableArray()
        
        setupUI()
        showHud()
        doGetRequestData(20,offset: self.offset)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "菜谱专辑"
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
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
        
        HDHM06Service().doGetRequest_HDHM06_URL(limit, offset: offset, successBlock: { (hm06Response) -> Void in
            
            self.offset = self.offset+1
            
            self.hidenHud()
            
            self.dataArray.addObjectsFromArray((hm06Response.result?.list)!)
            
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
        
        var imageView = cell.contentView.viewWithTag(1000) as? UIImageView
        
        if  imageView == nil {
        
            imageView = UIImageView()
            imageView?.tag = 1000
            cell.contentView.addSubview(imageView!)
            
            imageView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(cell.contentView).offset(0)
                make.left.equalTo(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(200)
                
            })
            
        }
        
        var title = cell.contentView.viewWithTag(2000) as? UILabel
        
        if title == nil {
            
            title = UILabel()
            title?.tag = 2000
            title?.font = UIFont.systemFontOfSize(16)
            title?.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title!)
            
            title?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo((imageView?.snp_bottom)!).offset(5)
                make.left.equalTo(cell.contentView).offset(15)
                make.width.equalTo(Constants.HDSCREENWITH-30)
                make.height.equalTo(20)
                
            })
        }
        
        var userName = cell.contentView.viewWithTag(3000) as? UILabel
        
        if userName == nil {
        
            userName = UILabel()
            userName?.tag = 3000
            userName?.font = UIFont.systemFontOfSize(15)
            userName?.textColor = UIColor.lightGrayColor()
            cell.contentView.addSubview(userName!)
            
            userName?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo((title?.snp_bottom)!).offset(0)
                make.left.equalTo(cell.contentView).offset(14)
                make.width.equalTo(Constants.HDSCREENWITH-30)
                make.height.equalTo(20)
                
            })
            
        }
        
        var line = cell.contentView.viewWithTag(4000) as? UILabel
        
        if line == nil {
        
            line = UILabel()
            line?.tag = 4000
            line?.backgroundColor = Constants.HDBGViewColor
            cell.contentView.addSubview(line!)
            
            line?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo((userName?.snp_bottom)!).offset(5)
                make.left.equalTo(cell.contentView).offset(0)
                make.height.equalTo(10)
                make.width.equalTo(Constants.HDSCREENWITH)
                
                
            })
            
        }
        
        let model = dataArray[indexPath.row] as! HDHM06ListModel
        imageView?.sd_setImageWithURL(NSURL(string: model.cover!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        title?.text = model.title
        userName?.text = String(format: "by %@", model.userName!)
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 260
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = dataArray[indexPath.row] as! HDHM06ListModel
        let hdhm05VC = HDHM05Controller()
        hdhm05VC.name = model.title
        hdhm05VC.cid = model.id
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdhm05VC, animated: true)
        
    }
    
}
