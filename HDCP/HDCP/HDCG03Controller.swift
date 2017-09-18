//
//  HDCG03Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/22.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit
import Kingfisher

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


class ArrayCount: NSObject {

    var count: NSNumber!

}

class HDCG03Controller: UITableViewController, UISearchBarDelegate {

    var dataArray: NSMutableArray!
    var hisDataArray: NSMutableArray!
    var offset: Int!
    var searchBar: UISearchBar!

    var result: HDHM04Result?
    /// 初始显示历史记录
    var isShowHis: Bool! = true

    var objCont: ArrayCount!

    override func viewDidLoad() {


        super.viewDidLoad()

        objCont = ArrayCount()
        objCont.setValue(NSNumber(value: 0 as Int), forKey: "count")

        offset = 0
        dataArray = NSMutableArray()
        hisDataArray = NSMutableArray()

        let userDefault = UserDefaults.standard
        let array = userDefault.object(forKey: Constants.HDHistory) as? NSArray

        if array?.count > 0 {

            hisDataArray.addObjects(from: array! as [AnyObject])
            hisDataArray.insert("清除历史记录", at: 0)
        }

        // 对历史记录数进行监听 从而判断是否添加下拉自动刷新
        objCont.addObserver(self, forKeyPath: "count", options: NSKeyValueObservingOptions.new, context: nil)

        setupUI()



    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)


    }

    deinit {

        objCont.removeObserver(self, forKeyPath: "count")
        HDLog.LogClassDestory("HDCG03Controller" as AnyObject)
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true


        let button = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("取消", for: UIControlState())
        button.addTarget(self, action: #selector(cancel), for: UIControlEvents.touchUpInside)
        button.contentMode = UIViewContentMode.scaleToFill
        let rightItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightItem

    }

    // MARK: - KVO

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

        guard keyPath == "count" else {
            return
        }

//        let count = change?["new"] as! NSNumber
//
//        if !isShowHis!{
//
//            if count.intValue*80 > Constants.HDSCREENHEIGHT-64 {
//
//                if self.tableView?.mj_footer == nil {
//                    //当列表滚动到底端 视图自动刷新
//                    self.tableView?.mj_footer = HDRefreshGifFooter(refreshingBlock: { () -> Void in
//                        self.offset = self.offset + 20
//                        self.doGetRequestData(self.searchBar.text!,limit: 10,offset: self.offset)
//                    })
//
//                }
//
//            }
//
//        }

    }

    // MARK: - 创建UI视图

    func setupUI() {

        self.tableView.tableFooterView = UIView()
        self.tableView.register(HDHM04Cell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.register(HDHM04Cell.classForCoder(), forCellReuseIdentifier: "myCell2")
        self.tableView.backgroundColor = UIColor.white
        //兼容IOS11
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never;
        }
        searchBar = UISearchBar()
        searchBar.placeholder = "搜索菜谱、食材或功效"
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 0, y: 0, width: Constants.HDSCREENWITH - 40, height: 44)
        searchBar.barTintColor = Constants.HDBGViewColor
        searchBar.showsCancelButton = false
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()

    }

    // MARK: - 提示动画显示和隐藏
    func showHud() {

        CoreUtils.showProgressHUD(self.tableView)

    }

    func hidenHud() {

        CoreUtils.hidProgressHUD(self.tableView)
    }

    func cancel() {

        navigationController!.popToRootViewController(animated: false)

    }

    // MARK: - 数据加载
    func doGetRequestData(_ keyWord: String, limit: Int, offset: Int) {

        unowned let WS = self
        HDCG03Service().doGetRequest_HDCG03_URL(keyWord, limit: limit, offset: offset, successBlock: { (hm04Response) -> Void in
            WS.offset = WS.offset + 1

            WS.hidenHud()

            WS.dataArray.addObjects(from: (hm04Response.result?.list)!)

            WS.objCont.setValue(NSNumber(value: WS.dataArray.count as Int), forKey: "count")

            if (WS.tableView.mj_footer != nil) {

                WS.tableView.mj_footer.endRefreshing()
            }

            WS.tableView.reloadData()

        }) { (error) -> Void in

            WS.tableView.mj_footer.endRefreshing()
            CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }

    }

    // MARK: - events

    func backAction() {

        navigationController!.popViewController(animated: true)

    }
    // MARK: - UISearchBar delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        //保存历史记录

        let userDefault = UserDefaults.standard
        let array = userDefault.object(forKey: Constants.HDHistory) as? NSArray
        let hisArray = NSMutableArray()

        if array?.count > 0 {

            hisArray.addObjects(from: array! as [AnyObject])
            hisArray.add(searchBar.text!)

        } else {

            hisArray.add(searchBar.text!)

        }

        userDefault.set(NSArray(array: hisArray), forKey: Constants.HDHistory)
        userDefault.synchronize()

        dataArray = NSMutableArray()
        isShowHis = false
        showHud()
        searchBar.resignFirstResponder()
        doGetRequestData(searchBar.text!, limit: 20, offset: self.offset)
    }


    // MARK: - UITableView delegate/datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isShowHis! {

            return self.hisDataArray.count
        } else {

            return self.dataArray.count
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        if isShowHis! {

            let cell = tableView .dequeueReusableCell(withIdentifier: "myCell2", for: indexPath) as! HDHM04Cell

            var title = cell.viewWithTag(1000) as? UILabel

            if title == nil {

                title = UILabel()
                title?.font = UIFont.systemFont(ofSize: 15)
                cell.contentView.addSubview(title!)

                title?.snp.makeConstraints({ (make) -> Void in

                    make.top.equalTo(cell.contentView).offset(0)
                    make.left.equalTo(cell.contentView).offset(15)
                    make.bottom.equalTo(cell.contentView).offset(0)
                    make.width.equalTo(Constants.HDSCREENWITH - 30)


                })

            }

            title?.textColor = Constants.HDMainTextColor
            let name = hisDataArray[(indexPath as NSIndexPath).row] as! String
            title?.text = name
            return cell

        } else {


            let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! HDHM04Cell

            let model = dataArray[(indexPath as NSIndexPath).row] as! HDHM04ListModel
            cell.coverImageV?.kf.setImage(with: URL(string: model.cover!), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)
            cell.title?.text = model.title
            cell.count?.text = String(format: "%d收藏  %d浏览", model.commentCount!, model.viewCount!)

            var stuffStr = String()

            for (i, _) in (model.stuff?.enumerated())! {

                let stuff = model.stuff![i]

                if i == (model.stuff?.count)! - 1 {
                    stuffStr.append(stuff.name!)

                } else {
                    stuffStr.append(String(format: "%@、", stuff.name!))
                }

            }

            cell.stuff?.text = stuffStr

            return cell
        }


    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if isShowHis! {
            return 44
        } else {

            return 80
        }

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if isShowHis! {

            if (indexPath as NSIndexPath).row == 0 {
                //清除历史记录
                let userDefault = UserDefaults.standard
                userDefault.set(nil, forKey: Constants.HDHistory)
                userDefault.synchronize()

                hisDataArray = NSMutableArray()
                self.tableView.reloadData()

            } else {

                isShowHis = false
                let name = hisDataArray[(indexPath as NSIndexPath).row] as! String
                hisDataArray = NSMutableArray()
                self.tableView.reloadData()
                showHud()
                searchBar.resignFirstResponder()
                doGetRequestData(name, limit: 20, offset: self.offset)

            }


        } else {

            let model = dataArray[(indexPath as NSIndexPath).row] as! HDHM04ListModel
            let hdHM08VC = HDHM08Controller()
            hdHM08VC.rid = model.recipeId
            hdHM08VC.name = model.title
            self.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(hdHM08VC, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {

        if (indexPath as NSIndexPath).row != 0 {
            return UITableViewCellEditingStyle.delete
        } else {
            return UITableViewCellEditingStyle.none
        }

    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        self.hisDataArray.removeObject(at: (indexPath as NSIndexPath).row)

        let userDefault = UserDefaults.standard
        let array = userDefault.object(forKey: Constants.HDHistory) as? NSArray
        let hisArray = NSMutableArray()

        if array?.count > 0 {

            hisArray.addObjects(from: array! as [AnyObject])
            hisArray.removeObject(at: (indexPath as NSIndexPath).row - 1)

        }

        userDefault.set(NSArray(array: hisArray), forKey: Constants.HDHistory)
        userDefault.synchronize()

        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)

        if hisArray.count == 0 {

            self.hisDataArray = NSMutableArray()
            self.tableView.reloadData()
        }

    }

}
