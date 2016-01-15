//
//  HDCG01ViewController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let cateArray = [["title":"口味","image":"KWIcon"],
    ["title":"菜系","image":"CXIcon"],
    ["title":"菜品","image":"CPIcon"],
    ["title":"场景","image":"CJIcon"],
    ["title":"热门分类","image":"RMFLIcon"],
    ["title":"流行食材","image":"LXSCIcon"],
    ["title":"常见功效","image":"CJGXIcon"],
    ["title":"加工工艺","image":"JGGYIcon"],
    ["title":"厨房用具","image":"CFYJIcon"]]

class HDCG01Controller: UITableViewController,UISearchControllerDelegate {

 
    var searchController:UISearchController?
    var dataArray:Array<HDCG02ListModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray = Array<HDCG02ListModel>()
        
        doGetRequestData()
        
        setupUI()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        
    }
    
    func showHud(){
        
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.view)
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        self.tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        self.tableView.tableFooterView = UIView()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.dimsBackgroundDuringPresentation =  false
        searchController?.searchBar.placeholder = "搜索菜谱"
        searchController?.delegate = self
        searchController?.searchBar.frame = CGRectMake(0, 0, Constants.HDSCREENWITH, 44)
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.barTintColor = Constants.HDBGViewColor
        searchController?.searchBar.layer.borderWidth = 1;
        searchController?.searchBar.layer.borderColor = Constants.HDBGViewColor.CGColor;
        searchController?.searchBar.showsCancelButton = false
        self.tableView.tableHeaderView = searchController?.searchBar
        
    }
    
    // MARK: - 数据加载
    func doGetRequestData(){
        
        
        showHud()
        
        HDCG02Service().doGetRequest_HDCG02_URL({ (hdCG02Response) -> Void in
            
            self.hidenHud()
            self.dataArray = hdCG02Response.result?.list!
            self.tableView!.reloadData()
            
            }) { (error) -> Void in
                
                CoreUtils.showProgressHUD(self.view, title: Constants.HD_NO_NET_MSG)
                
        }
        
        
    }

    
    // MARK: - UISearchController delegate
    func willPresentSearchController(searchController: UISearchController){
        
//        print("willPresentSearchController")
    }
    
    func didPresentSearchController(searchController: UISearchController){
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        self.tabBarController?.tabBar.hidden = true
//        print("didPresentSearchController")
    }
    
    func willDismissSearchController(searchController: UISearchController){
        
//        print("willDismissSearchController")
    }
    
    func didDismissSearchController(searchController: UISearchController){
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
//        print("didDismissSearchController")
        self.tabBarController?.tabBar.hidden = false
    }
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return dataArray.count
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        let cell = tableView .dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
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
                make.left.equalTo((icon?.snp_right)!).offset(16)
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
        
        
        let model = dataArray[indexPath.row] as HDCG02ListModel
        icon?.sd_setImageWithURL(NSURL(string: model.imgUrl!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        title?.text =   model.cate!
        
        
        arrow?.image = UIImage(named: "arrowIcon")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /**
        *  分类列表
        */
        let model = dataArray[indexPath.row] as HDCG02ListModel
        
        let hdcg02VC = HDCG02Controller()
        hdcg02VC.dataArray = model.tags
        hdcg02VC.name = model.cate
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdcg02VC, animated: true)
        self.hidesBottomBarWhenPushed = false;
        
    }

}
