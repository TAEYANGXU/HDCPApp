//
//  HDCG03Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/22.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class ArrayCount: NSObject {
    
    var count:NSNumber!
    
}

class HDCG03Controller: UITableViewController,UISearchBarDelegate {

    var dataArray:NSMutableArray!
    var hisDataArray:NSMutableArray!
    var offset:Int!
    var searchBar:UISearchBar!
    
    var result:HDHM04Result?
    /// 初始显示历史记录
    var isShowHis:Bool! = true
    
    var objCont:ArrayCount!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        objCont = ArrayCount()
        objCont.setValue(NSNumber(integer: 0), forKey: "count")
        
        offset = 0
        dataArray  = NSMutableArray()
        hisDataArray  = NSMutableArray()
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        let array = userDefault.objectForKey(Constants.HDHistory) as? NSArray
        
        if array?.count>0 {
        
            hisDataArray.addObjectsFromArray(array! as [AnyObject])
            hisDataArray.insertObject("清除历史记录", atIndex: 0)
        }
        
        // 对历史记录数进行监听 从而判断是否添加下拉自动刷新
        objCont.addObserver(self, forKeyPath: "count", options: NSKeyValueObservingOptions.New, context: nil)
        
        setupUI()
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        
    }
    
    deinit{
    
        objCont.removeObserver(self, forKeyPath: "count")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        
        
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 40, 30)
        button.titleLabel?.font = UIFont.systemFontOfSize(16)
        button.setTitle("取消", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(cancel), forControlEvents: UIControlEvents.TouchUpInside)
        button.contentMode = UIViewContentMode.ScaleToFill
        let rightItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    // MARK: - KVO
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        
        
        if keyPath == "count" {
        
            let count = change!["new"] as! NSNumber
            
            if !isShowHis!{
            
                if count.integerValue*80 > Constants.HDSCREENHEIGHT-64 {
                    
                    if self.tableView?.mj_footer == nil {
                        //当列表滚动到底端 视图自动刷新
                        self.tableView?.mj_footer = HDRefreshGifFooter(refreshingBlock: { () -> Void in
                            self.offset = self.offset + 20
                            self.doGetRequestData(self.searchBar.text!,limit: 10,offset: self.offset)
                        })
                        
                    }
                    
                }
                
            }
            
            
        }
        
        
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(HDHM04Cell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.registerClass(HDHM04Cell.classForCoder(), forCellReuseIdentifier: "myCell2")
        self.tableView.backgroundColor = UIColor.whiteColor()
        
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
        
        CoreUtils.showProgressHUD(self.tableView)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.tableView)
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
            
            self.objCont.setValue(NSNumber(integer: self.dataArray.count), forKey: "count")
            
            if (self.tableView.mj_footer  != nil){
            
                self.tableView.mj_footer.endRefreshing()
            }
            
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
    
        //保存历史记录
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        let array = userDefault.objectForKey(Constants.HDHistory) as? NSArray
        let hisArray = NSMutableArray()
        
        if array?.count>0 {
        
            hisArray.addObjectsFromArray(array! as [AnyObject])
            hisArray.addObject(searchBar.text!)
            
        }else{
        
            hisArray.addObject(searchBar.text!)
            
        }
        
        userDefault.setObject(NSArray(array: hisArray), forKey: Constants.HDHistory)
        userDefault.synchronize()
        
        dataArray = NSMutableArray()
        isShowHis = false
        showHud()
        searchBar.resignFirstResponder()
        doGetRequestData(searchBar.text!,limit: 20,offset: self.offset)
    }
    
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        if isShowHis! {
        
            return self.hisDataArray.count
        }else{
        
            return self.dataArray.count
        }
        
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        
        if isShowHis! {
        
            let cell = tableView .dequeueReusableCellWithIdentifier("myCell2", forIndexPath: indexPath) as! HDHM04Cell
            
            var title = cell.viewWithTag(1000) as? UILabel
            
            if title == nil {
            
                title = UILabel()
                title?.font = UIFont.systemFontOfSize(15)
                cell.contentView.addSubview(title!)
                
                title?.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.top.equalTo(cell.contentView).offset(0)
                    make.left.equalTo(cell.contentView).offset(15)
                    make.bottom.equalTo(cell.contentView).offset(0)
                    make.width.equalTo(Constants.HDSCREENWITH-30)
                    
                    
                })
                
            }
            
            title?.textColor = Constants.HDMainTextColor
            let name = hisDataArray[indexPath.row] as! String
            title?.text = name
            return cell
            
        }else{
        
            
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
        
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if isShowHis! {
            return 44
        }else{
        
            return 80
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if isShowHis! {
            
            if indexPath.row == 0 {
                //清除历史记录
                let userDefault = NSUserDefaults.standardUserDefaults()
                userDefault.setObject(nil, forKey: Constants.HDHistory)
                userDefault.synchronize()
                
                hisDataArray = NSMutableArray()
                self.tableView.reloadData()
                
            }else{
            
                isShowHis = false
                let name = hisDataArray[indexPath.row] as! String
                hisDataArray = NSMutableArray()
                self.tableView.reloadData()
                showHud()
                searchBar.resignFirstResponder()
                doGetRequestData(name,limit: 20,offset: self.offset)
                
            }
            
            
        }else{
            
            let model = dataArray[indexPath.row] as! HDHM04ListModel
            let hdHM08VC = HDHM08Controller()
            hdHM08VC.rid = model.recipeId
            hdHM08VC.name = model.title
            self.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(hdHM08VC, animated: true)
        }
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if indexPath.row != 0 {
            return UITableViewCellEditingStyle.Delete
        }else{
            return UITableViewCellEditingStyle.None
        }
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        self.hisDataArray.removeObjectAtIndex(indexPath.row)
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        let array = userDefault.objectForKey(Constants.HDHistory) as? NSArray
        let hisArray = NSMutableArray()
        
        if array?.count>0 {
            
            hisArray.addObjectsFromArray(array! as [AnyObject])
            hisArray.removeObjectAtIndex(indexPath.row-1)
            
        }
        
        userDefault.setObject(NSArray(array: hisArray), forKey: Constants.HDHistory)
        userDefault.synchronize()
        
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
        if hisArray.count == 0 {
        
            self.hisDataArray = NSMutableArray()
            self.tableView.reloadData()
        }
        
    }

}
