//
//  HDCG02Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDCG02Controller: UITableViewController {

    var dataArray:Array<HDCG01TagModel>!
    var name:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = name
        
        dataArray = HDCG01Service().getTagListByCate(name)
        
        setupUI()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        self.tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        self.tableView.tableFooterView = UIView()
    
    }
    
    // MARK: - events
    
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    // MARK: - UITableView  delegate/datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        
        return dataArray.count
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    
        let cell = tableView .dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        
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
                make.left.equalTo(cell.contentView).offset(16)
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
        
        let model = dataArray[indexPath.row]
        
        title?.text =   model.name
        arrow?.image = UIImage(named: "arrowIcon")
        
        return cell
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = dataArray[indexPath.row]
        let hdHM04VC = HDHM04Controller()
        let tmodel = TagListModel()
        tmodel.id = model.id;
        tmodel.name = model.name;
        hdHM04VC.tagModel = tmodel;
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdHM04VC, animated: true)
    }
    

}
