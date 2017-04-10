//
//  HDCT06Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/2/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let ct06ArrayLogin = [[["title": "社交绑定"],
    ["title": "消息设置"], ["title": "隐私设置"], ["title": "账号安全"]],
    [["title": "夜间模式"],
        ["title": "2G/3G/4G下展示图片"], ["title": "开启摇一摇震动"], ["title": "清理缓存"]],
    [["title": "关于"],
        ["title": "意见反馈"], ["title": "给我们评星"]], [["title": "退出登录"]], []]

private let titleArrayLogin = ["个人", "通用", "支持", "", ""]

class HDCT06Controller: UITableViewController {

    var ct06Array = [[["title": "社交绑定"],
        ["title": "消息设置"], ["title": "隐私设置"], ["title": "账号安全"]],
        [["title": "夜间模式"],
            ["title": "2G/3G/4G下展示图片"], ["title": "开启摇一摇震动"], ["title": "清理缓存"]],
        [["title": "关于"],
            ["title": "意见反馈"], ["title": "给我们评星"]], []]
    var titleArray = ["个人", "通用", "支持", ""]
    var cacheSize: CGFloat = 0.0;

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge();
        self.navigationController?.navigationBar.isTranslucent = false

        self.title = "设置"

        let defaults = UserDefaults.standard
        let sign = defaults.object(forKey: Constants.HDSign)

        if let _ = sign {

            self.ct06Array = ct06ArrayLogin
            self.titleArray = titleArrayLogin

        }

        self.cacheSize = self.getCacheSize();

        setupUI()

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
    }

    deinit {

        HDLog.LogClassDestory("HDCT06Controller")
    }

    // MARK: - 计算缓存大小

    func getCacheSize() -> CGFloat {

//        let size = SDImageCache.shared().getSize()
        let mb: CGFloat = CGFloat(1024 * 1024 * 2 / 1024 / 1024)

        return mb
    }

    // MARK: - 删除本地缓存

    open func deleteCacheFile() -> Bool {

        showHud()

        let path: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let cachePath = path + "/default/com.hackemist.SDWebImageCache.default"

        let fileManager = FileManager.default
        let contents = try! fileManager.contentsOfDirectory(atPath: cachePath)

        for fileName in contents {

            try! fileManager.removeItem(atPath: cachePath + ("/" + fileName))
        }

        print("delete over !")

        self.perform(#selector(hidenHud), with: self, afterDelay: 1.5)

        return true
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

    // MARK: - 创建UI视图

    func setupUI() {

        self.tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - UITableView delegate/datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ct06Array[section].count
    }

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return titleArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath)




        /**
         *  名称
         */
        var title: UILabel? = cell.contentView.viewWithTag(2000) as? UILabel
        if title == nil {

            title = UILabel()
            title?.tag = 2000
            title?.font = UIFont.systemFont(ofSize: 16)
            cell.contentView.addSubview(title!)

            title?.snp.makeConstraints( { (make) -> Void in
                make.width.equalTo(200)
                make.height.equalTo(44)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(0)
            })
        }

        //缓存大小
        var cacheSizeLabel: UILabel? = cell.contentView.viewWithTag(2001) as? UILabel

        if cacheSizeLabel == nil {

            cacheSizeLabel = UILabel()
            cacheSizeLabel?.isHidden = true
            cacheSizeLabel?.tag = 2001
            cacheSizeLabel?.textColor = Constants.HDMainTextColor
            cacheSizeLabel?.textAlignment = NSTextAlignment.right
            cacheSizeLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.contentView.addSubview(cacheSizeLabel!)

            cacheSizeLabel?.snp.makeConstraints( { (make) in
                make.top.equalTo(7)
                make.right.equalTo(-20)
                make.width.equalTo(60)
                make.height.equalTo(30)
            })
        }

        let array = ct06Array[(indexPath as NSIndexPath).section]
        title?.text = array[(indexPath as NSIndexPath).row]["title"]


        if (indexPath as NSIndexPath).section == 1 {

            if (indexPath as NSIndexPath).row == 3 {

                cacheSizeLabel?.isHidden = false
                cacheSizeLabel?.text = String(format: "%0.1fMB", self.cacheSize)
            } else {

                cacheSizeLabel?.isHidden = true
            }
        }

        if (indexPath as NSIndexPath).section == 3 {

            /**
             *  名称
             */
            title?.textColor = UIColor.red
            title?.textAlignment = NSTextAlignment.center
            title?.backgroundColor = UIColor.white
            cell.backgroundColor = UIColor.clear

            title?.snp.updateConstraints({ (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(44)
                make.left.equalTo(cell.contentView).offset(0)
                make.top.equalTo(cell.contentView).offset(0)
            })

        } else {

            title?.textColor = Constants.HDMainTextColor
            title?.textAlignment = NSTextAlignment.left
            cell.backgroundColor = UIColor.white

            title?.snp.updateConstraints({ (make) -> Void in

                make.width.equalTo(200)
                make.height.equalTo(44)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(0)
            })

        }

        if (indexPath as NSIndexPath).section == 1 || (indexPath as NSIndexPath).section == 3 {

            cell.accessoryType = UITableViewCellAccessoryType.none


        } else {

            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.HDSpace * 4)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.HDSCREENWITH, height: 40))
        titleView.backgroundColor = Constants.HDBGViewColor
        let title = UILabel(frame: CGRect(x: 16, y: 0, width: Constants.HDSCREENWITH, height: 40))
        title.font = UIFont.systemFont(ofSize: 13)
        title.text = titleArray[section]
        titleView.addSubview(title)

        return titleView
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 44

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if (indexPath as NSIndexPath).section == 1 {

            if (indexPath as NSIndexPath).row == 3 {

                let alertVC = UIAlertController(title: nil, message: "确定要删除吗?", preferredStyle: .alert)
                let cancelAl = UIAlertAction(title: "取消", style: .cancel, handler: { (UIAlertAction) in
                    return
                })

                unowned let ws = self
                let okAl = UIAlertAction(title: "确定", style: .default, handler: { (UIAlertAction) in
                    ws.deleteCacheFile()
                })

                alertVC.addAction(cancelAl)
                alertVC.addAction(okAl)

                self.present(alertVC, animated: true, completion: nil)
            }

        }

        if (indexPath as NSIndexPath).section == 2 {

            if (indexPath as NSIndexPath).row == 1 {

                /**
                 *   意见反馈
                 */
                let hdgg04VC = HDGG04Controller()
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(hdgg04VC, animated: true)
                self.hidesBottomBarWhenPushed = false

            }
        }

        if (indexPath as NSIndexPath).section == 3 {

            HDLog.LogOut("退出登录")

            HDUserInfoManager.shareInstance.clear()
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.HDREFRESHHDCT01), object: nil, userInfo: ["FLAG": "LOGOUT"])

            for vc in (self.navigationController?.viewControllers)! {

                if vc.isMember(of: HDCT01Controller.classForCoder()) {

                    self.navigationController!.popToViewController(vc, animated: true)
                    break
                }

            }
        }
    }
}
