//
//  HDHM06Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/15.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM06Controller: UITableViewController {

    var dataArray: NSMutableArray!
    var offset: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        offset = 0
        dataArray = NSMutableArray()

        setupUI()
        showHud()
        doGetRequestData(10, offset: self.offset)

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.title = "菜谱专辑"
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
    }

    deinit {

        HDLog.LogClassDestory("HDHM06Controller")
    }

    // MARK: - 创建UI视图

    func setupUI() {

        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor

        //当列表滚动到底端 视图自动刷新
        unowned let WS = self;
        WS.tableView?.mj_footer = HDRefreshGifFooter(refreshingBlock: { () -> Void in
            WS.doGetRequestData(10, offset: WS.offset)
        })
    }


    // MARK: - 提示动画显示和隐藏
    func showHud() {

        CoreUtils.showProgressHUD(self.view)

    }

    func hidenHud() {

        CoreUtils.hidProgressHUD(self.view)
    }

    // MARK: - events

    func backAction() {

        navigationController!.popViewController(animated: true)

    }

    // MARK: - 数据加载
    func doGetRequestData(_ limit: Int, offset: Int) {

        unowned let WS = self;
        HDHM06Service().doGetRequest_HDHM06_URL(limit, offset: offset, successBlock: { (hm06Response) -> Void in

            WS.offset = WS.offset + 10

            WS.hidenHud()

            WS.dataArray.addObjects(from: (hm06Response.result?.list)!)

            WS.tableView.mj_footer.endRefreshing()

            WS.tableView.reloadData()

        }) { (error) -> Void in

            WS.tableView.mj_footer.endRefreshing()
            CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }

    }

    // MARK: - UITableView delegate/datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        var imageView = cell.contentView.viewWithTag(1000) as? UIImageView

        if imageView == nil {

            imageView = UIImageView()
            imageView?.tag = 1000
            cell.contentView.addSubview(imageView!)

            imageView?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(cell.contentView).offset(0)
                make.left.equalTo(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(200)

            })

        }

        var title = cell.contentView.viewWithTag(2000) as? UILabel

        if title == nil {

            title = UILabel()
            title?.tag = 2000
            title?.font = UIFont.systemFont(ofSize: 16)
            title?.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title!)

            title?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo((imageView?.snp.bottom)!).offset(5)
                make.left.equalTo(cell.contentView).offset(15)
                make.width.equalTo(Constants.HDSCREENWITH - 30)
                make.height.equalTo(20)

            })
        }

        var userName = cell.contentView.viewWithTag(3000) as? UILabel

        if userName == nil {

            userName = UILabel()
            userName?.tag = 3000
            userName?.font = UIFont.systemFont(ofSize: 15)
            userName?.textColor = UIColor.lightGray
            cell.contentView.addSubview(userName!)

            userName?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo((title?.snp.bottom)!).offset(0)
                make.left.equalTo(cell.contentView).offset(14)
                make.width.equalTo(Constants.HDSCREENWITH - 30)
                make.height.equalTo(20)

            })

        }

        var line = cell.contentView.viewWithTag(4000) as? UILabel

        if line == nil {

            line = UILabel()
            line?.tag = 4000
            line?.backgroundColor = Constants.HDBGViewColor
            cell.contentView.addSubview(line!)

            line?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo((userName?.snp.bottom)!).offset(5)
                make.left.equalTo(cell.contentView).offset(0)
                make.height.equalTo(10)
                make.width.equalTo(Constants.HDSCREENWITH)


            })

        }

        let model = dataArray[(indexPath as NSIndexPath).row] as! HDHM06ListModel
        imageView?.kf.setImage(with: URL(string: model.cover!), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

        title?.text = model.title
        userName?.text = String(format: "by %@", model.userName!)


        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let model = dataArray[(indexPath as NSIndexPath).row] as! HDHM06ListModel
        let hdhm05VC = HDHM05Controller()
        hdhm05VC.name = model.title
        hdhm05VC.cid = model.id
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdhm05VC, animated: true)

    }

}
