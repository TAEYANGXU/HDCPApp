//
//  HDCT08Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class HDCT08Controller: UITableViewController {

    var dataArray:NSMutableArray!
    var offset:Int!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dataArray = NSMutableArray()
        setupUI()
        offset = 0
        showHud()
        doGetRequestData(10, offset: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "豆友"
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
        
    }
    
    deinit{
        
        HDLog.LogClassDestory("HDCT08Controller")
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        
        //当列表滚动到底端 视图自动刷新
        unowned let WS = self
        self.tableView?.mj_footer = HDRefreshGifFooter(refreshingBlock: { () -> Void in
            WS.doGetRequestData(10, offset: WS.offset)
        })
        
    }
    
    // MARK: - events
    func backAction(){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - 数据加载
    func doGetRequestData(_ limit:Int,offset:Int){
    
        unowned let WS = self
        HDCT08Service().doGetRequest_HDCT08_URL(limit, offset: offset, successBlock: { (hdResponse) -> Void in
            
            WS.offset = WS.offset+10
            
            WS.hidenHud()
            
            WS.dataArray.addObjects(from: (hdResponse.result?.list)!)
            
            WS.tableView.mj_footer.endRefreshing()
            
            WS.tableView.reloadData()
            
            }) { (error) -> Void in
                
                WS.tableView.mj_footer.endRefreshing()
                CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }
    
    // MARK: - 提示动画显示和隐藏
    func showHud(){
        
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.view)
    }
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return self.dataArray.count
    }
    
    override func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) ->UITableViewCell
    {
        let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        //豆友头像
        var icon = cell.contentView.viewWithTag(1000) as? UIImageView
        
        if icon == nil {
        
            icon = UIImageView()
            icon?.layer.cornerRadius = 25
            icon?.tag = 1000
            icon?.layer.masksToBounds = true
            cell.contentView.addSubview(icon!)
            
            icon?.snp.makeConstraints( { (make) -> Void in
                
                make.left.equalTo(15)
                make.top.equalTo(10)
                make.width.equalTo(50)
                make.height.equalTo(50)
                
            })
            
        }
        
        //豆友名称
        var name = cell.contentView.viewWithTag(2000) as? UILabel
        
        if name == nil {
        
            name = UILabel()
            name?.textColor = Constants.HDMainTextColor
            name?.adjustsFontSizeToFitWidth=true
            name?.tag = 2000
            name?.font = UIFont.systemFont(ofSize: 16)
            cell.contentView.addSubview(name!)
        
            name?.snp.makeConstraints( { (make) -> Void in
                
                make.left.equalTo(icon!.snp.right).offset(20)
                make.top.equalTo(cell.contentView).offset(10)
                make.width.equalTo(60)
                make.height.equalTo(20)
                
            })
        }
        
        //是否是VIP用户
        var vip = cell.contentView.viewWithTag(3000) as? UIImageView
        
        if vip == nil {
        
            vip = UIImageView()
            vip?.tag = 3000
            cell.contentView.addSubview(vip!)
            
            vip?.snp.makeConstraints( { (make) -> Void in
                
                make.top.equalTo(10)
                make.left.equalTo(name!.snp.right).offset(10)
                make.width.equalTo(20)
                make.height.equalTo(20)
                
            })
            
        }
        
        //性别
        var sex = cell.contentView.viewWithTag(4000) as? UIImageView
        
        if sex == nil {
            
            sex = UIImageView()
            sex?.tag = 4000
            cell.contentView.addSubview(sex!)
            
            sex?.snp.makeConstraints( { (make) -> Void in
                
                
                make.top.equalTo(10)
                make.left.equalTo(vip!.snp.right).offset(10)
                make.width.equalTo(20)
                make.height.equalTo(20)
            })
            
        }
        //标签
        
        var favoriteList = cell.contentView.viewWithTag(5000) as? UILabel
        
        if favoriteList == nil {
        
            favoriteList = UILabel()
            favoriteList?.tag = 5000
            favoriteList?.textColor = Constants.HDMainTextColor
            favoriteList?.font = UIFont.systemFont(ofSize: 13)
            cell.contentView.addSubview(favoriteList!)
            
            favoriteList?.snp.makeConstraints( { (make) -> Void in
                
                make.left.equalTo(icon!.snp.right).offset(20)
                make.top.equalTo(name!.snp.bottom).offset(10)
                make.width.equalTo(Constants.HDSCREENWITH-100)
                make.height.equalTo(20)
                
            })
            
        }
        
        //地址
        var address = cell.contentView.viewWithTag(6000) as? UILabel
        
        if address == nil {
            
            address = UILabel()
            address?.tag = 6000
            address?.textColor = UIColor.lightGray
            address?.font = UIFont.systemFont(ofSize: 12)
            cell.contentView.addSubview(address!)
            
            address?.snp.makeConstraints( { (make) -> Void in
                
                make.left.equalTo(icon!.snp.right).offset(20)
                make.bottom.equalTo(cell.contentView.snp.bottom).offset(-10)
                make.width.equalTo(Constants.HDSCREENWITH-100)
                make.height.equalTo(20)
                
            })
            
        }
        
        //分割条
        var line = cell.contentView.viewWithTag(7000) as? UILabel
        
        if line == nil {
        
            line = UILabel()
            line?.tag = 7000
            line?.backgroundColor = Constants.HDBGViewColor
            cell.contentView.addSubview(line!)
            
            line?.snp.makeConstraints( { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(Constants.HDSpace/2)
                make.bottom.equalTo(cell.contentView.snp.bottom).offset(0)
                
            })
            
        }
        
        let model = dataArray[(indexPath as NSIndexPath).row] as! HDCT08ListModel
        icon?.sd_setImage(with:URL(string: model.avatar), placeholderImage: UIImage(named: "defaultIcon"))
        
        /// 文本宽度计算
        let text:NSString = NSString(string: model.userName)
        let attributes = [NSFontAttributeName: name!.font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect = text.boundingRect(with: CGSize(width: 200, height: 300), options: option, attributes: attributes, context: nil)
        name?.text = model.userName
        name?.snp.updateConstraints({ (make) -> Void in
            
            make.width.equalTo(rect.size.width)
        })
        
        if model.vip == 1 {
            
            //是vip用户
            vip?.isHidden = false
            vip?.image = UIImage(named: "VIcon")
            
        }else{
        
            vip?.isHidden = true
        }
        
        //0:=女 1:男
        if model.gender == 0 {
        
            sex?.image = UIImage(named: "womanIcon")
        }else{
        
            sex?.image = UIImage(named: "manIcon")
        }
        
        address?.text = model.address
        
        
        /// 拼接用户喜好列表
        var favoriteStr = String()
        
        if model.favoriteList!.count > 0 {
        
            for i in 0 ..< (model.favoriteList?.count)! {
                
                let favorite = model.favoriteList![i]
                
                if i == (model.favoriteList?.count)!-1 {
                    favoriteStr.append(favorite.name!)
                    
                }else{
                    favoriteStr.append(String(format: "%@、", favorite.name!))
                }
                
            }
            
            favoriteList?.isHidden = false
            favoriteList?.text = favoriteStr
            
        }else{
        
            favoriteList?.text = ""
            favoriteList?.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = dataArray[(indexPath as NSIndexPath).row] as! HDCT08ListModel
        if model.favoriteList?.count > 0 {
        
            return 100
        }else{
            return 70
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
}
