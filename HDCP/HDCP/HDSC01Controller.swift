//
//  HDSC01ViewController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit



class HDSC01Controller: UITableViewController,UISearchControllerDelegate{

    var searchController:UISearchController?
    
    let searchArray = [["title":"热门搜索","image":"RMSSIcon"],
        ["title":"最近搜索","image":"ZJSSIcon"],
        ["title":"最近浏览","image":"ZJLLIcon"],
        ["title":"最近流行","image":"ZJLXIcon"],
        ["title":"摇一摇","image":"YYYIcon"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if (self.searchController!.active) {
            print(true)
        }else{
            
            print("flase")
        }
        
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
    
        self.tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "mycell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        self.tableView.tableFooterView = UIView()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.dimsBackgroundDuringPresentation =  false
        searchController?.searchBar.placeholder = "搜索菜谱"
        searchController?.delegate = self
        searchController?.searchBar.frame = CGRectMake(0, 0, Constants.kSCREENWITH, 44)
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.barTintColor = Constants.HDBGViewColor
        searchController?.searchBar.layer.borderWidth = 1;
        searchController?.searchBar.layer.borderColor = Constants.HDBGViewColor.CGColor;
        searchController?.searchBar.showsCancelButton = false
        searchController?.hidesNavigationBarDuringPresentation = false
        self.tableView.tableHeaderView = searchController?.searchBar
        
    }
    
    // MARK: - UISearchController delegate
    func willPresentSearchController(searchController: UISearchController){
    
        print("willPresentSearchController")
    }

    func didPresentSearchController(searchController: UISearchController){
    
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        
        print("didPresentSearchController")
    }

    func willDismissSearchController(searchController: UISearchController){
    
        print("willDismissSearchController")
    }
    
    func didDismissSearchController(searchController: UISearchController){
    
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        print("didDismissSearchController")
    }
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return searchArray.count
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        let cell = tableView .dequeueReusableCellWithIdentifier("mycell", forIndexPath: indexPath)
        
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
        
        icon?.image = UIImage(named: searchArray[indexPath.row]["image"]!)
        title?.text =   searchArray[indexPath.row]["title"]
        arrow?.image = UIImage(named: "arrowIcon")
        
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }

}
