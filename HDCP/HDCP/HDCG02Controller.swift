//
//  HDCG02Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDCG02Controller: UITableViewController {

    open var dataArray: Array<HDCG01TagModel>!
    var name: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = name
        
        setupUI()

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
    }

    deinit {

        HDLog.LogClassDestory("HDCG02Controller")

    }

    // MARK: - 创建UI视图

    func setupUI() {

        self.tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        self.tableView.tableFooterView = UIView()
        //兼容IOS11
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never;
        }
    }

    // MARK: - events

    @objc func backAction() {

        navigationController!.popViewController(animated: true)

    }

    // MARK: - UITableView  delegate/datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


        return dataArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        /**
         *  名称
         */
        var title: UILabel? = cell.viewWithTag(2000) as? UILabel
        if title == nil {

            title = UILabel()
            title?.tag = 2000
            title?.textColor = Constants.HDMainTextColor
            title?.font = UIFont.systemFont(ofSize: 16)
            cell.contentView.addSubview(title!)
            title?.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(200)
                make.height.equalTo(44)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(0)
            })
        }

        /**
         *  箭头
         */
        var arrow: UIImageView? = cell.viewWithTag(3000) as? UIImageView
        if arrow == nil {

            arrow = UIImageView()
            arrow?.tag = 3000
            cell.contentView.addSubview(arrow!)

            arrow?.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(20)
                make.height.equalTo(20)
                make.right.equalTo(cell.contentView).offset(-20)
                make.top.equalTo(cell.contentView).offset(12)

            })

        }

        let model = dataArray[(indexPath as NSIndexPath).row]

        title?.text = model.name
//        arrow?.image = UIImage(named: "arrowIcon")

        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let model = dataArray[(indexPath as NSIndexPath).row]
        let hdHM04VC = HDHM04Controller()
        let tmodel = TagListModel()
        tmodel.id = model.id;
        tmodel.name = model.name;
        hdHM04VC.tagModel = tmodel;
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdHM04VC, animated: true)
    }


}
