//
//  HDHM07Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/15.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM07Controller: UITableViewController {

    var dataArray:NSMutableArray!
    var offset:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offset = 0
        dataArray  = NSMutableArray()
        
        setupUI()
        showHud()
        doGetRequestData(10,offset: self.offset)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "厨房宝典"
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(HDHM07Cell.classForCoder(), forCellReuseIdentifier: "myCell")
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
        
        HDHM07Service().doGetRequest_HDHM07_URL(limit, offset: offset, successBlock: { (hm07Response) -> Void in
            
            self.offset = self.offset+10
            
            self.hidenHud()
            
            self.dataArray.addObjectsFromArray((hm07Response.result?.list)!)
            
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
        let cell = tableView .dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! HDHM07Cell
        
        let model = dataArray[indexPath.row] as! HDHM07ListModel
        cell.coverImageV?.sd_setImageWithURL(NSURL(string: model.image!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        cell.title?.text = model.title
        cell.content?.text = model.content

        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = dataArray[indexPath.row] as! HDHM07ListModel
        let hdWebVC = HDWebController()
        hdWebVC.name = model.title
        hdWebVC.url = model.url
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdWebVC, animated: true)
    }


}
