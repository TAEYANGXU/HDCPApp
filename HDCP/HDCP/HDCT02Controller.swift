//
//  HDCT02Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/2/14.
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


class HDCT02Controller: UITableViewController, UITextFieldDelegate {

    var username: UITextField!
    var password: UITextField!

    override func viewDidLoad() {

        super.viewDidLoad()
        self.title = "登录"

        setupUI()

    }

    func setupUI() {

        self.view.backgroundColor = Constants.HDBGViewColor
        self.tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = UIColor.white
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)

    }

    deinit {

        HDLog.LogClassDestory("HDCT02Controller")
    }

    // MARK: - events
    func backAction() {

        navigationController!.popViewController(animated: true)

    }

    // MARK: - 提示动画显示和隐藏
    func showHud() {

        CoreUtils.showProgressHUD(self.view)

    }

    func hidenHud() {

        CoreUtils.hidProgressHUD(self.view)
    }


    /**
     *  用户注册
     */
    func registAction() {

        let hdct03VC = HDCT03Controller()
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdct03VC, animated: true)
    }

    /**
     *  用户登录
     */
    func loginAction() {


        guard username.text?.characters.count > 0 else {

            CoreUtils.showWarningHUD(self.view, title: "请输入用户名")
            return
        }

        guard password.text?.characters.count > 0 else {

            CoreUtils.showWarningHUD(self.view, title: "请输入密码")
            return
        }

        //登录
        showHud()
        unowned let WS = self
        HDCT02Service().doGetRequest_HDCT02_01_URL("8752979", successBlock: { (hdResponse) -> Void in

            WS.hidenHud()
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.HDREFRESHHDCT01), object: nil, userInfo: ["FLAG": "LOGIN"])
            WS.navigationController!.popToRootViewController(animated: true)

        }) { (error) -> Void in

            WS.hidenHud()
            CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }
    }

    /**
     *  忘记密码
     */
    func forgetAction() {


    }

    // MARK: - UITableView delegate/datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        cell.selectionStyle = UITableViewCellSelectionStyle.none

        if (indexPath as NSIndexPath).row == 0 {

            let bg = UILabel()
            cell.contentView.addSubview(bg)
            bg.backgroundColor = Constants.HDBGViewColor
            bg.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(10)
                make.left.equalTo(cell.contentView).offset(0)
                make.top.equalTo(cell.contentView).offset(0)
            })

            let title = UILabel()
            title.text = "账号:"
            title.font = UIFont.systemFont(ofSize: 16)
            title.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title)
            title.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(50)
                make.height.equalTo(50)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(10)
            })

            username = UITextField()
            username.text = "15221472030"
            username.placeholder = "请输入邮箱账号或手机号码"
            username.font = UIFont.systemFont(ofSize: 16)
            cell.contentView.addSubview(username)
            username.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 80)
                make.height.equalTo(40)
                make.left.equalTo(title.snp.right).offset(0)
                make.top.equalTo(cell.contentView).offset(15)

            })

            let line = UILabel()
            line.backgroundColor = CoreUtils.HDColor(227, g: 227, b: 229, a: 1)
            cell.contentView.addSubview(line)

            line.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 16)
                make.height.equalTo(1)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(59)

            })

        } else if (indexPath as NSIndexPath).row == 1 {

            let title = UILabel()
            title.text = "密码:"
            title.font = UIFont.systemFont(ofSize: 16)
            title.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title)
            title.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(50)
                make.height.equalTo(50)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(0)
            })

            password = UITextField()
            password.placeholder = "密码不少于6位，限字母和数字"
            password.text = "12345678"
            password.font = UIFont.systemFont(ofSize: 16)
            password.isSecureTextEntry = true
            cell.contentView.addSubview(password)
            password.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 80)
                make.height.equalTo(40)
                make.left.equalTo(title.snp.right).offset(0)
                make.top.equalTo(cell.contentView).offset(5)

            })

            let line = UILabel()
            line.backgroundColor = CoreUtils.HDColor(227, g: 227, b: 229, a: 1)
            cell.contentView.addSubview(line)

            line.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 16)
                make.height.equalTo(1)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(49)

            })

        } else {

            let forgetBtn = UIButton(type: UIButtonType.custom)
            forgetBtn.setTitle("忘记密码?", for: UIControlState())
            forgetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            forgetBtn.addTarget(self, action: #selector(forgetAction), for: UIControlEvents.touchUpInside)
            forgetBtn.setTitleColor(Constants.HDMainColor, for: UIControlState.normal)
            cell.contentView.addSubview(forgetBtn)

            forgetBtn.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(80)
                make.height.equalTo(40)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(20)

            })


            let registBtn = UIButton(type: UIButtonType.custom)
            registBtn.setTitle("注册", for: UIControlState())
            registBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            registBtn.addTarget(self, action: #selector(registAction), for: UIControlEvents.touchUpInside)
            registBtn.setTitleColor(Constants.HDMainColor, for: UIControlState.normal)
            cell.contentView.addSubview(registBtn)

            registBtn.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(80)
                make.height.equalTo(40)
                make.right.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(20)

            })


            let loginBtn = UIButton(type: UIButtonType.custom)
            loginBtn.setTitle("登录", for: UIControlState())
            loginBtn.backgroundColor = Constants.HDMainColor
            loginBtn.addTarget(self, action: #selector(loginAction), for: UIControlEvents.touchUpInside)
            loginBtn.layer.cornerRadius = 5
            loginBtn.layer.masksToBounds = true
            loginBtn.setTitleColor(UIColor.white, for: UIControlState())
            cell.contentView.addSubview(loginBtn)

            loginBtn.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 40)
                make.height.equalTo(40)
                make.left.equalTo(cell.contentView).offset(20)
                make.top.equalTo(cell.contentView).offset(70)

            })
        }


        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath as NSIndexPath).row == 0 {

            return 60
        } else if (indexPath as NSIndexPath).row == 1 {

            return 50
        } else {

            return 140
        }

    }

}
