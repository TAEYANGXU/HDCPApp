//
//  HDGG01Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let gg01Array = [["title":"厨房宝典","image":"CFBDIcon"],
    ["title":"应用推荐","image":"YYTJIcon"],
    ["title":"意见反馈","image":"YJFKIcon"],
    ["title":"菜谱专辑","image":"CPZJIcon"],
    ["title":"营养餐桌","image":"YYCZIcon"],
    ["title":"食材百科","image":"SCBKIcon"]]

class HDGG01Controller: BaseViewController ,UITableViewDelegate,UITableViewDataSource,HDGG01RowViewProtocol{

    var hdGG01Response:HDGG01Response!
    var tableView:UITableView?
    var headerView:UIView?
    var count:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge();
        self.navigationController?.navigationBar.isTranslucent = false
        
        //双击TabItem通知
        NotificationCenter.default.addObserver(self, selector: #selector(gg01Notification(_:)), name: NSNotification.Name(rawValue: Constants.HDREFRESHHDGG01), object: nil)
        
        count = 0
        setupUI()
        
        if HDGG01Service().isExistEntity() {
            /**
            *  读取本地数据
            */
            
            self.hdGG01Response =  HDGG01Service().getAllResponseEntity()
            self.count = hdGG01Response.array2D!.count
            self.tableView!.reloadData()
            
            self.tableView?.isHidden = false
            
            doGetRequestData()
            
        }else{
        
            if CoreUtils.networkIsReachable() {
                
                showHud()
                doGetRequestData()
                
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hidenHud()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
    }

    deinit{
    
        tableView?.delegate = nil
        tableView?.dataSource = nil
        
        HDLog.LogClassDestory("HDGG01Controller")
    }
    // MARK: - 创建UI视图
   
    func setupUI(){
    
        createTableView()
        createHeaderView()
        
    }
    
    func createHeaderView(){
    
        if headerView == nil {
            
            headerView = UIView(frame: CGRect(x: 0,y: 0,width: Constants.HDSCREENWITH/3,height: 2*Constants.HDSCREENWITH/3+2*CGFloat(Constants.HDSpace)))
            headerView?.backgroundColor = UIColor.clear
            tableView?.tableHeaderView = headerView
            
            var index = 0
            
            for i in 0 ..< 2 {
                
                for j in 0 ..< 3 {
                
                    let btn = HDGG01Button()
                    btn.tag = index+400
                    btn.setImage(UIImage(named: gg01Array[index]["image"]!), for: UIControlState())
                    btn.setTitle(gg01Array[index]["title"]!, for: UIControlState())
                    btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                    btn.backgroundColor = UIColor.white
                    btn.titleLabel?.textAlignment = NSTextAlignment.center
                    btn.layer.borderWidth = 0.5
                    btn.layer.borderColor = Constants.HDBGViewColor.cgColor
                    btn.setTitleColor(Constants.HDMainTextColor, for: UIControlState.normal)
                    btn.addTarget(self, action: #selector(menuBtnOnclick(_:)), for: UIControlEvents.touchUpInside)
                    headerView!.addSubview(btn)

                    unowned let WS = self
                    btn.snp.makeConstraints( { (make) -> Void in
                        
                        make.top.equalTo(WS.headerView!).offset(CGFloat(i)*Constants.HDSCREENWITH/3+10)
                        make.left.equalTo(WS.headerView!).offset(CGFloat(j)*Constants.HDSCREENWITH/3)
                        make.width.equalTo(Constants.HDSCREENWITH/3)
                        make.height.equalTo(Constants.HDSCREENWITH/3)
                        
                    })
                    index += 1
                }
                
            }
            
        }
        
    }
    
    func createTableView(){
    
        if tableView == nil {
        
            tableView = UITableView()
            tableView?.tableFooterView = UIView()
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.backgroundColor = UIColor.clear
            tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
            self.tableView?.isHidden = true
            self.view.addSubview(self.tableView!)
            tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
            tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "mycell2")
            unowned let WS = self
            tableView?.snp.makeConstraints( { (make) -> Void in
                
                make.top.equalTo(WS.view).offset(0)
                make.left.equalTo(WS.view).offset(0)
                make.bottom.equalTo(WS.view).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                
            })
            
            tableView?.mj_header = HDRefreshGifHeader(refreshingBlock: { () -> Void in
                
                WS.doGetRequestData()
                
            })

        }
        
    }
    
    // MARK: - 提示动画显示和隐藏
    func showHud(){
        
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.view)
    }
    
    // MARK: - 通知事件
    
    func gg01Notification(_ noti:Notification){
        
        let flag = (noti as NSNotification).userInfo!["FLAG"] as? String
        
        if flag == Constants.HDREFRESHHDGG01 {
            
            /**
            *  开始刷新 获取最新数据
            */
            self.tableView?.mj_header.beginRefreshing()
            
        }
        
        
    }
    
    // MARK: - onclik events
    
    func menuBtnOnclick(_ btn:UIButton){
    
        let tag:Int = btn.tag - 400
        switch tag {
            
        case 0:
            /**
            *   厨房宝典
            */
            let hdHM07VC = HDHM07Controller()
            self.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(hdHM07VC, animated: true)
            self.hidesBottomBarWhenPushed = false
            HDLog.LogOut(btn.currentTitle!)
            break
        case 1:
            /**
            *   应用推荐
            */
            let hdgg02VC = HDGG02Controller()
            self.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(hdgg02VC, animated: true)
            self.hidesBottomBarWhenPushed = false
            HDLog.LogOut(btn.currentTitle!)
            break
            
        case 2:
            /**
            *   意见反馈
            */
            let hdgg04VC = HDGG04Controller()
            self.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(hdgg04VC, animated: true)
            self.hidesBottomBarWhenPushed = false
            HDLog.LogOut(btn.currentTitle!)
            break
            
        case 3:
            /**
            *   菜谱专辑
            */
            let hdHM06VC = HDHM06Controller()
            self.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(hdHM06VC, animated: true)
            self.hidesBottomBarWhenPushed = false
            HDLog.LogOut(btn.currentTitle!)
            break
        case 4:
            /**
            *   营养餐桌
            */
            let hdHM03VC = HDHM03Controller()
            self.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(hdHM03VC, animated: true)
            self.hidesBottomBarWhenPushed = false
            HDLog.LogOut(btn.currentTitle!)
            break
        case 5:
            /**
            *   食材百科
            */
            let hdcg02VC = HDCG02Controller()
            hdcg02VC.name = "流行食材"
            self.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(hdcg02VC, animated: true)
            self.hidesBottomBarWhenPushed = false
            HDLog.LogOut(btn.currentTitle!)
            break

        default:
            break
        }
        
    }
    
    // MARK: - 数据加载
    /**
     *  加载数据
     */
    func doGetRequestData(){
    
        unowned let WS = self
        HDGG01Service().doGetRequest_HDGG01_URL({ (hdResponse) -> Void in
            
            WS.hidenHud()
            WS.count = hdResponse.array2D!.count
            WS.hdGG01Response = hdResponse
            WS.tableView!.reloadData()
            
            WS.tableView?.isHidden = false
            
            WS.tableView?.mj_header.endRefreshing()
            
            }) { (error) -> Void in
                
                WS.tableView?.mj_header.endRefreshing()
                CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
                
        }

        
    }
    
    // MARK: - HDGG01RowViewProtocol
    func didSelectHDGG01RowView(_ indexPath:IndexPath,index:Int)->Void{
        
        
        let array2d = self.hdGG01Response.array2D![(indexPath as NSIndexPath).row] as! Array<HDGG01ListModel>
        let model:HDGG01ListModel = array2d[index]
        
        if model.url.hasPrefix("http") {
        
            //进入webView
            let webVC = HDWebController()
            webVC.name = model.title
            webVC.url = model.url
            self.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(webVC, animated: true)
            self.hidesBottomBarWhenPushed = false
            
        }else{
        
            //菜谱专辑
            let hdhm05VC = HDHM05Controller()
            hdhm05VC.name = model.title
            hdhm05VC.cid = NSInteger(model.url)
            self.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(hdhm05VC, animated: true)
            self.hidesBottomBarWhenPushed = false
            
            
        }
        
        
    }
    
    // MARK: - UIScrollView delegate
    func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return count
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) ->UITableViewCell
    {
        
        
        
        if (indexPath as NSIndexPath).row%2==0 {
        
            /**
             *  左边大图
             */
            
            let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            
            // 大图 左
            var leftImageView = cell.viewWithTag(1000)  as? HDGG01RowView
            if leftImageView == nil {
                
                leftImageView = HDGG01RowView()
                leftImageView?.tag = 1000
                cell.contentView.addSubview(leftImageView!)
                
                leftImageView?.snp.makeConstraints( { (make) -> Void in
                    
                    make.left.equalTo(cell.contentView).offset(10)
                    make.top.equalTo(cell.contentView).offset(10)
                    make.height.equalTo(3*Constants.HDSCREENWITH/5)
                    make.width.equalTo(3*Constants.HDSCREENWITH/5)
                })
                
            }
            
            // 小图 上
            var topImageView = cell.viewWithTag(2000)  as? HDGG01RowView
            if topImageView == nil {
                
                topImageView = HDGG01RowView()
                topImageView?.tag = 2000
                cell.contentView.addSubview(topImageView!)
                
                topImageView?.snp.makeConstraints( { (make) -> Void in
                    
                    make.right.equalTo(cell.contentView).offset(-10)
                    make.top.equalTo(cell.contentView).offset(10)
                    make.height.equalTo((3*Constants.HDSCREENWITH/5-5)/2)
                    make.width.equalTo(2*Constants.HDSCREENWITH/5-30)
                })
                
            }
            // 小图 下
            var bottomImageView = cell.viewWithTag(3000)  as? HDGG01RowView
            if bottomImageView == nil {
                
                bottomImageView = HDGG01RowView()
                bottomImageView?.tag = 3000
                cell.contentView.addSubview(bottomImageView!)
                
                bottomImageView?.snp.makeConstraints( { (make) -> Void in
                    
                    make.right.equalTo(cell.contentView).offset(-10)
                    make.bottom.equalTo(cell.contentView).offset(-20)
                    make.height.equalTo((3*Constants.HDSCREENWITH/5-5)/2)
                    make.width.equalTo(2*Constants.HDSCREENWITH/5-30)
                })
                
            }
    
            var bgLine =  cell.viewWithTag(10000) as? UILabel
            
            if bgLine == nil {
                
                bgLine = UILabel()
                bgLine?.tag = 10000
                bgLine?.backgroundColor = Constants.HDBGViewColor
                cell.contentView.addSubview(bgLine!)
                
                bgLine?.snp.makeConstraints( { (make) -> Void in
                    
                    make.bottom.equalTo(0)
                    make.left.equalTo(0)
                    make.width.equalTo(Constants.HDSCREENWITH)
                    make.height.equalTo(Constants.HDSpace)
                    
                })
            }
            
            let array2d = self.hdGG01Response.array2D![(indexPath as NSIndexPath).row] as! Array<HDGG01ListModel>
            
            let leftModel = array2d[0]
            leftImageView!.imageView.kf.setImage(with: URL(string: (leftModel.image!)), placeholder: UIImage(named:"noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)
            
            leftImageView?.title.text = leftModel.title
            leftImageView?.delegate = self
            leftImageView?.indexPath = indexPath
            leftImageView!.index = 0
            
            let topModel = array2d[1]
            
            topImageView!.imageView.kf.setImage(with: URL(string: (topModel.image!)), placeholder: UIImage(named:"noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)
            
            topImageView?.title.text = topModel.title
            topImageView?.delegate = self
            topImageView?.indexPath = indexPath
            topImageView!.index = 1
            
            let bottomModel = array2d[2]
            
            bottomImageView!.imageView.kf.setImage(with: URL(string: (bottomModel.image!)), placeholder: UIImage(named:"noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)
            
            bottomImageView?.title.text = bottomModel.title
            bottomImageView?.delegate = self
            bottomImageView?.indexPath = indexPath
            bottomImageView!.index = 2
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        }else{
        
            /**
             *  右边大图
             */

            let cell = tableView .dequeueReusableCell(withIdentifier: "mycell2", for: indexPath)
            
            //  右大图
            var rightImageView = cell.viewWithTag(4000)  as? HDGG01RowView
            if rightImageView == nil {
                rightImageView = HDGG01RowView()
                rightImageView?.tag = 4000
                cell.contentView.addSubview(rightImageView!)
                
                rightImageView?.snp.makeConstraints( { (make) -> Void in
                    
                    make.right.equalTo(cell.contentView).offset(-10)
                    make.top.equalTo(cell.contentView).offset(10)
                    make.height.equalTo(3*Constants.HDSCREENWITH/5)
                    make.width.equalTo(3*Constants.HDSCREENWITH/5)
                })
                
            }

            //  上小图
            var topImageView = cell.viewWithTag(5000)  as? HDGG01RowView
            if topImageView == nil {
                
                topImageView = HDGG01RowView()
                topImageView?.tag = 5000
                cell.contentView.addSubview(topImageView!)
                
                topImageView?.snp.makeConstraints( { (make) -> Void in
                    
                    make.left.equalTo(cell.contentView).offset(10)
                    make.top.equalTo(cell.contentView).offset(10)
                    make.height.equalTo((3*Constants.HDSCREENWITH/5-5)/2)
                    make.width.equalTo(2*Constants.HDSCREENWITH/5-30)
                })
                
            }
            
            //  下小图
            var bottomImageView = cell.viewWithTag(6000)  as? HDGG01RowView
            if bottomImageView == nil {
                
                bottomImageView = HDGG01RowView()
                bottomImageView?.tag = 6000
                cell.contentView.addSubview(bottomImageView!)
                
                bottomImageView?.snp.makeConstraints( { (make) -> Void in
                    
                    make.left.equalTo(cell.contentView).offset(10)
                    make.bottom.equalTo(cell.contentView).offset(-20)
                    make.height.equalTo((3*Constants.HDSCREENWITH/5-5)/2)
                    make.width.equalTo(2*Constants.HDSCREENWITH/5-30)
                })
                
            }


            var bgLine =  cell.viewWithTag(20000) as? UILabel
            
            if bgLine == nil {
                
                bgLine = UILabel()
                bgLine?.tag = 20000
                bgLine?.backgroundColor = Constants.HDBGViewColor
                cell.contentView.addSubview(bgLine!)
                
                bgLine?.snp.makeConstraints( { (make) -> Void in
                    
                    make.bottom.equalTo(0)
                    make.left.equalTo(0)
                    make.width.equalTo(Constants.HDSCREENWITH)
                    make.height.equalTo(Constants.HDSpace)
                    
                })
            }
            
            let array2d = self.hdGG01Response.array2D![(indexPath as NSIndexPath).row] as! Array<HDGG01ListModel>
            
            let rightModel:HDGG01ListModel = array2d[0]
            rightImageView!.imageView.kf.setImage(with: URL(string: rightModel.image!), placeholder: UIImage(named:"noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)
            
            rightImageView?.title.text = rightModel.title
            rightImageView?.delegate = self
            rightImageView?.indexPath = indexPath
            rightImageView!.index = 0
            
            let topModel = array2d[1]
            topImageView!.imageView.kf.setImage(with: URL(string: topModel.image!), placeholder: UIImage(named:"noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)
            topImageView?.title.text = topModel.title
            topImageView?.delegate = self
            topImageView?.indexPath = indexPath
            topImageView!.index = 1
            
            let bottomModel = array2d[2]
            bottomImageView!.imageView.kf.setImage(with: URL(string: bottomModel.image!), placeholder: UIImage(named:"noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)
            bottomImageView?.title.text = bottomModel.title
            bottomImageView?.delegate = self
            bottomImageView?.indexPath = indexPath
            bottomImageView!.index = 2
        
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 3*Constants.HDSCREENWITH/5+20+10
    }

}
