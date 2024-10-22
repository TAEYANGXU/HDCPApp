//
//  HDGG02Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/25.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let appArray = [["title": "微菜谱", "image": "AppIcon_06", "intro": ""],
    ["title": "金牌牙医-医生版", "image": "AppIcon_02", "intro": ""],
    ["title": "金牌牙医", "image": "AppIcon_03", "intro": ""],
    ["title": "金牌牙医-助手版", "image": "AppIcon_04", "intro": ""],
    ["title": "好豆菜谱", "image": "AppIcon_01", "intro": ""],
    ["title": "蝉游记", "image": "AppIcon_05", "intro": ""]]

class HDGG02Controller: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        self.title = "应用推荐"

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
    }

    deinit {

        HDLog.LogClassDestory("HDGG02Controller" as AnyObject)

    }

    // MARK: - 创建UI视图

    func setupUI() {

        self.tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        self.tableView.tableFooterView = UIView()
        //兼容IOS11
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        }
    }

    // MARK: - events

    @objc func backAction() {

//        navigationController!.popViewController(animated: true)
        navigationController!.popViewController(animated: true)
    }


    // MARK: - UITableView  delegate/datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


        return appArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath)


        /**
         *  图片
         */
        var coverImageV: UIImageView? = cell.viewWithTag(1000) as? UIImageView

        if coverImageV == nil {

            coverImageV = UIImageView()
            coverImageV?.layer.cornerRadius = 5
            coverImageV?.layer.masksToBounds = true
            cell.contentView.addSubview(coverImageV!)

            coverImageV?.snp.makeConstraints({ (make) -> Void in

                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(10)
                make.width.equalTo(50)
                make.height.equalTo(50)

            })

        }

        /**
         *  名称
         */
        var title: UILabel? = cell.viewWithTag(2000) as? UILabel
        if title == nil {

            title = UILabel()
            title?.tag = 2000
            title?.textColor = Constants.HDMainTextColor
            title?.font = UIFont.systemFont(ofSize: 15)
            cell.contentView.addSubview(title!)
            title?.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 100)
                make.height.equalTo(20)
                make.left.equalTo(coverImageV!.snp.right).offset(10)
                make.top.equalTo(cell.contentView).offset(7)
            })
        }


        /**
         *  介绍
         */
        var intro: UILabel? = cell.viewWithTag(3000) as? UILabel
        if intro == nil {

            intro = UILabel()
            intro?.tag = 2000
            intro?.textColor = UIColor.lightGray
            intro?.font = UIFont.systemFont(ofSize: 13)
            intro?.numberOfLines = 2
            cell.contentView.addSubview(intro!)
            intro?.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 100)
                make.height.equalTo(40)
                make.left.equalTo(coverImageV!.snp.right).offset(10)
                make.top.equalTo(title!.snp.bottom).offset(0)
            })
        }


//        let intro = appArray[indexPath.row]["intro"]

        title?.text = appArray[(indexPath as NSIndexPath).row]["title"]
        coverImageV?.image = UIImage(named: appArray[(indexPath as NSIndexPath).row]["image"]!)
        intro?.text = "2015年12月4日，苹果公司宣布其Swift编程语言现在开放源代码"

        return cell

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 70
    }

}
