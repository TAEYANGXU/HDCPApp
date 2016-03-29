//
//  HDHM04Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/13.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM04Controller: UITableViewController {
    
    var tagModel:TagListModel?
    var dataArray:NSMutableArray!
    var offset:Int!

        
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        offset = 0
        dataArray  = NSMutableArray()
        setupUI()
        showHud()
        
        self.title = tagModel?.name
        
        doGetRequestData(self.tagModel!.id!,limit: 10,offset: self.offset)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(HDHM04Cell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        
        //当列表滚动到底端 视图自动刷新
        self.tableView?.mj_footer = HDRefreshGifFooter(refreshingBlock: { () -> Void in
            self.doGetRequestData(self.tagModel!.id!,limit: 10,offset: self.offset)
        })
        
    }
    
    // MARK: - 提示动画显示和隐藏
    func showHud(){
        
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.view)
    }
    
    // MARK: - 数据加载
    func doGetRequestData(tagId:Int,limit:Int,offset:Int){
    
        HDHM04Service().doGetRequest_HDHM04_URL(tagId, limit: limit, offset: offset, successBlock: { (hm04Response) -> Void in
            
            self.offset = self.offset+10
            
            self.hidenHud()
            
            self.dataArray.addObjectsFromArray((hm04Response.result?.list)!)
            
            self.tableView.mj_footer.endRefreshing()
            
            self.tableView.reloadData()
            
            }) { (error) -> Void in
                
                self.tableView.mj_footer.endRefreshing()
                CoreUtils.showWarningHUD(self.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }
    
    // MARK: - events
    
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return self.dataArray.count
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        let cell = tableView .dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! HDHM04Cell
        
        let model = dataArray[indexPath.row] as! HDHM04ListModel
        
        cell.coverImageV?.sd_setImageWithURL(NSURL(string: model.cover!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        cell.title?.text = model.title
        cell.count?.text = String(format: "%d收藏  %d浏览", model.commentCount!, model.viewCount!)
        
        var stuffStr = String()
        
        for (i,_) in (model.stuff?.enumerate())! {
            
            let stuff = model.stuff![i]
            
            if i == (model.stuff?.count)!-1 {
                stuffStr.appendContentsOf(stuff.name!)
                
            }else{
                stuffStr.appendContentsOf(String(format: "%@、", stuff.name!))
            }
            
        }
        
        cell.stuff?.text = stuffStr
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = dataArray[indexPath.row] as! HDHM04ListModel

        let hdHM08VC = HDHM08Controller()
        hdHM08VC.rid = model.recipeId
        hdHM08VC.name = model.title
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdHM08VC, animated: true)
        
    }
}
