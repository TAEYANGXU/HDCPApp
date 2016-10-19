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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "厨房宝典"
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
    }
    
    deinit{
        
        HDLog.LogClassDestory("HDHM07Controller")
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(HDHM07Cell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        
        //当列表滚动到底端 视图自动刷新
        unowned let WS = self
        self.tableView?.mj_footer = HDRefreshGifFooter(refreshingBlock: { () -> Void in
            WS.doGetRequestData(10,offset: WS.offset)
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
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - 数据加载
    func doGetRequestData(_ limit:Int,offset:Int){
        
        unowned let WS = self
        HDHM07Service().doGetRequest_HDHM07_URL(limit, offset: offset, successBlock: { (hm07Response) -> Void in
            
            WS.offset = self.offset+10
            
            WS.hidenHud()
            
            WS.dataArray.addObjects(from: (hm07Response.result?.list)!)
            
            WS.tableView.mj_footer.endRefreshing()
            
            WS.tableView.reloadData()
            
            }) { (error) -> Void in
                
                WS.tableView.mj_footer.endRefreshing()
                CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return self.dataArray.count
    }
    
    override func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) ->UITableViewCell
    {
        let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! HDHM07Cell
        
        let model = dataArray[(indexPath as NSIndexPath).row] as! HDHM07ListModel
        cell.coverImageV?.sd_setImage(with:URL(string: model.image!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        cell.title?.text = model.title
        cell.content?.text = model.content

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArray[(indexPath as NSIndexPath).row] as! HDHM07ListModel
        let hdWebVC = HDWebController()
        hdWebVC.name = model.title
        hdWebVC.url = model.url
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdWebVC, animated: true)
    }


}
