//
//  HDCT03Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/2/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDCT03Controller: UITableViewController {

    var mobile: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "注册"
        setupUI()

    }

    func setupUI() {

        self.view.backgroundColor = Constants.HDBGViewColor
        self.tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = UIColor.white
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //兼容IOS11
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never;
        }

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
    }

    deinit {

        HDLog.LogClassDestory("HDCT03Controller")
    }

    // MARK: - events

    @objc func backAction() {

        navigationController!.popViewController(animated: true)

    }

    @objc func nextAction() {


        guard CoreUtils.isMobileNumber(mobile.text!) else {

            //手机号码输入有误
            CoreUtils.showWarningHUD(self.view, title: "手机号码输入有误")
            return
        }

        let hdct04VC = HDCT04Controller()
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdct04VC, animated: true)

    }

    @objc func protocolAction() {

        let hdct07VC = HDCT07Controller()
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdct07VC, animated: true)

    }

    // MARK: - UITableView delegate/datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
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
            title.text = "手机:"
            title.font = UIFont.systemFont(ofSize: 16)
            title.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title)
            title.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(50)
                make.height.equalTo(50)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(10)
            })

            mobile = UITextField()
            mobile.placeholder = "请输入手机号码"
            mobile.keyboardType = UIKeyboardType.numberPad;
            mobile.font = UIFont.systemFont(ofSize: 16)
            cell.contentView.addSubview(mobile)
            mobile.snp.makeConstraints( { (make) -> Void in

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

        } else {


            let nextBtn = UIButton(type: UIButtonType.custom)
            nextBtn.setTitle("下一步", for: UIControlState())
            nextBtn.backgroundColor = UIColor.white
            nextBtn.addTarget(self, action: #selector(nextAction), for: UIControlEvents.touchUpInside)
            nextBtn.layer.cornerRadius = 5
            nextBtn.layer.masksToBounds = true
            nextBtn.layer.borderWidth = 1
            nextBtn.layer.borderColor = Constants.HDMainColor.cgColor
            nextBtn.setTitleColor(Constants.HDMainColor, for: UIControlState.normal)
            cell.contentView.addSubview(nextBtn)

            nextBtn.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 40)
                make.height.equalTo(40)
                make.left.equalTo(cell.contentView).offset(20)
                make.top.equalTo(cell.contentView).offset(20)

            })

            let title = "注册即表示同意《微菜谱协议》"
            let attributed = NSMutableAttributedString(string: title)
            attributed.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 16), range: NSMakeRange(7, 7))
            attributed.addAttribute(NSAttributedStringKey.foregroundColor, value: Constants.HDMainColor, range: NSMakeRange(7, 7))


            let protocolT = UILabel()
            protocolT.textAlignment = NSTextAlignment.center
            protocolT.textColor = Constants.HDMainTextColor
            protocolT.attributedText = attributed
            cell.contentView.addSubview(protocolT)
            protocolT.isUserInteractionEnabled = true
            /**
            *  添加点击事件
            */

            let tapGes = UITapGestureRecognizer(target: self, action: #selector(protocolAction))
            protocolT.addGestureRecognizer(tapGes)


            protocolT.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 40)
                make.height.equalTo(25)
                make.left.equalTo(cell.contentView).offset(20)
                make.top.equalTo(cell.contentView).offset(80)

            })

            let loginBtn = UIButton(type: UIButtonType.custom)
            loginBtn.setTitle("已有账号，点击登录", for: UIControlState())
            loginBtn.backgroundColor = UIColor.clear
            loginBtn.addTarget(self, action: #selector(backAction), for: UIControlEvents.touchUpInside)
            loginBtn.setTitleColor(Constants.HDMainColor, for: UIControlState.normal)
            cell.contentView.addSubview(loginBtn)

            loginBtn.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 40)
                make.height.equalTo(40)
                make.left.equalTo(cell.contentView).offset(20)
                make.top.equalTo(cell.contentView).offset(115)

            })

        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath as NSIndexPath).row == 0 {

            return 60
        } else {

            return 160
        }

    }

}
