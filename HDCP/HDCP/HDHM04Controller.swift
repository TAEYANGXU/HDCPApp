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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
    }
    
    deinit{
    
        HDLog.LogClassDestory("HDHM04Controller")
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(HDHM04Cell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        
        //当列表滚动到底端 视图自动刷新
        unowned let WS = self;
        self.tableView?.mj_footer = HDRefreshGifFooter(refreshingBlock: { () -> Void in
            WS.doGetRequestData(WS.tagModel!.id!,limit: 10,offset: WS.offset)
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
    func doGetRequestData(_ tagId:Int,limit:Int,offset:Int){
    
        unowned let WS = self;
        HDHM04Service().doGetRequest_HDHM04_URL(tagId, limit: limit, offset: offset, successBlock: { (hm04Response) -> Void in
            
            WS.offset = WS.offset+10
            
            WS.hidenHud()
            
            WS.dataArray.addObjects(from: (hm04Response.result?.list)!)
            
            WS.tableView.mj_footer.endRefreshing()
            
            WS.tableView.reloadData()
            
            }) { (error) -> Void in
                
                self.tableView.mj_footer.endRefreshing()
                CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }
    
    // MARK: - events
    
    func backAction(){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return self.dataArray.count
    }
    
    override func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) ->UITableViewCell
    {
        let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! HDHM04Cell
        
        let model = dataArray[(indexPath as NSIndexPath).row] as! HDHM04ListModel
        
        cell.coverImageV?.sd_setImage(with:URL(string: model.cover!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        cell.title?.text = model.title
        cell.count?.text = String(format: "%d收藏  %d浏览", model.commentCount!, model.viewCount!)
        
        var stuffStr = String()
        
        for (i,_) in (model.stuff?.enumerated())! {
            
            let stuff = model.stuff![i]
            
            if i == (model.stuff?.count)!-1 {
                stuffStr.append(stuff.name!)
                
            }else{
                stuffStr.append(String(format: "%@、", stuff.name!))
            }
            
        }
        
        cell.stuff?.text = stuffStr
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArray[(indexPath as NSIndexPath).row] as! HDHM04ListModel

        let hdHM08VC = HDHM08Controller()
        hdHM08VC.rid = model.recipeId
        hdHM08VC.name = model.title
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdHM08VC, animated: true)
        
    }
}
