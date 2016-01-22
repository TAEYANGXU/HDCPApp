//
//  HDCG03Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/22.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDCG03Controller: UITableViewController,UISearchBarDelegate {

    var dataArray:NSMutableArray!
    var offset:Int!
    var searchBar:UISearchBar!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        offset = 0
        dataArray  = NSMutableArray()
        
        setupUI()
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        
        
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 40, 30)
        button.titleLabel?.font = UIFont.systemFontOfSize(16)
        button.setTitle("取消", forState: UIControlState.Normal)
        button.addTarget(self, action: "cancel", forControlEvents: UIControlEvents.TouchUpInside)
        button.contentMode = UIViewContentMode.ScaleToFill
        let rightItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(HDHM04Cell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        
        //当列表滚动到底端 视图自动刷新
        self.tableView?.mj_footer = HDRefreshGifFooter(refreshingBlock: { () -> Void in
            self.offset = self.offset + 1
            self.doGetRequestData(self.searchBar.text!,limit: 10,offset: self.offset)
        })
        
        searchBar =  UISearchBar()
        searchBar.placeholder = "搜索菜谱、食材或功效"
        searchBar.delegate = self
        searchBar.frame = CGRectMake(0, 0, Constants.HDSCREENWITH-40, 44)
        searchBar.barTintColor = Constants.HDBGViewColor
        searchBar.showsCancelButton = false
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        
//        searchController = UISearchController(searchResultsController: nil)
//        searchController?.dimsBackgroundDuringPresentation =  false
//        searchController?.searchBar.placeholder = "搜索菜谱"
//        searchController?.delegate = self
//        searchController?.searchBar.delegate = self
//        searchController?.searchBar.frame = CGRectMake(0, 0, Constants.HDSCREENWITH, 44)
//        searchController?.searchBar.sizeToFit()
//        searchController?.searchBar.barTintColor = Constants.HDBGViewColor
//        searchController?.searchBar.layer.borderWidth = 1;
//        searchController?.searchBar.layer.borderColor = Constants.HDBGViewColor.CGColor;
//        searchController?.searchBar.showsCancelButton = false
//        self.tableView.tableHeaderView = searchController?.searchBar
//        
//        searchController?.becomeFirstResponder()
//        searchController!.active = true
//        searchController?.becomeFirstResponder()
    }
    
    // MARK: - 提示动画显示和隐藏
    func showHud(){
        
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.view)
    }
    
    func cancel(){
    
        self.navigationController?.popToRootViewControllerAnimated(false)
        
    }
    
    // MARK: - 数据加载
    func doGetRequestData(keyWord:String,limit:Int,offset:Int){
        
        HDCG03Service().doGetRequest_HDCG03_URL(keyWord, limit: limit, offset: offset, successBlock: { (hm04Response) -> Void in
            self.offset = self.offset+1
            
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
    // MARK: - UISearchBar delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
    
        showHud()
        searchBar.resignFirstResponder()
        doGetRequestData(searchBar.text!,limit: 20,offset: self.offset)
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
        for var i=0;i<model.stuff?.count;i++ {
            
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
