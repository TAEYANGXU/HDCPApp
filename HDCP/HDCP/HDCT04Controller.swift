//
//  HDCT04Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/2/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class HDCT04Controller: UITableViewController, UITextFieldDelegate {

    var code: UITextField!
    var username: UITextField!
    var password: UITextField!
    var secondBtn: UIButton!
    var timer: Timer!
    var second: Int = 59


    var disposeBag = DisposeBag()

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
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //兼容IOS11
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)

    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        timer.fire()

    }

    deinit {

        timer.invalidate()
        timer = nil

        HDLog.LogClassDestory("HDCT04Controller" as AnyObject)

    }

    // MARK: - events
    @objc func backAction() {

        for vc in (self.navigationController?.viewControllers)! {

            if vc.isKind(of: HDCT02Controller.classForCoder()) {

                self.navigationController!.popToViewController(vc, animated: true)
            }

        }

    }

    /**
     *  倒计时
     */
    @objc func timerAction() {

        if second == 0 {
            timer.invalidate()
            secondBtn.isEnabled = true
            secondBtn.setTitle("重新获取", for: UIControl.State())
        } else {

            secondBtn.isEnabled = false
            secondBtn.setTitle(String(format: "重新获取(%d)", second), for: UIControl.State())
            second -= 1
        }

    }

    /**
     *  重新获取
     */
    @objc func againAction() {

        timer.invalidate()
        timer = nil
        second = 59
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        timer.fire()
    }

    @objc func completeAction() {



    }

    // MARK: - UITableView delegate/datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        if (indexPath as NSIndexPath).row == 0 {

            let bg = UILabel()
            cell.contentView.addSubview(bg)
            bg.backgroundColor = Constants.HDBGViewColor
            bg.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(10)
                make.left.equalTo(cell.contentView).offset(0)
                make.top.equalTo(cell.contentView).offset(0)
            })

            let title = UILabel()
            title.text = "验证码:"
            title.font = UIFont.systemFont(ofSize: 16)
            title.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title)
            title.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(60)
                make.height.equalTo(50)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(10)
            })

            code = UITextField()
            code.placeholder = "请输入验证码"
            code.font = UIFont.systemFont(ofSize: 16)
            cell.contentView.addSubview(code)
            code.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 190)
                make.height.equalTo(40)
                make.left.equalTo(title.snp.right).offset(0)
                make.top.equalTo(cell.contentView).offset(15)

            })

            secondBtn = UIButton(type: UIButton.ButtonType.custom)
            secondBtn.layer.cornerRadius = 5
            secondBtn.layer.masksToBounds = true
            secondBtn.layer.borderWidth = 1
            secondBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            secondBtn.layer.borderColor = Constants.HDMainColor.cgColor
            secondBtn.setTitleColor(Constants.HDMainColor, for: UIControl.State.normal)
            secondBtn.addTarget(self, action: #selector(againAction), for: UIControl.Event.touchUpInside)
            secondBtn.backgroundColor = UIColor.white
            cell.contentView.addSubview(secondBtn)

            secondBtn.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(90)
                make.height.equalTo(30)
                make.right.equalTo(cell.contentView.snp.right).offset(-10)
                make.top.equalTo(cell.contentView).offset(20)

            })

            let line = UILabel()
            line.backgroundColor = CoreUtils.HDColor(227, g: 227, b: 229, a: 1)
            cell.contentView.addSubview(line)

            line.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 16)
                make.height.equalTo(1)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(59)

            })

        } else if (indexPath as NSIndexPath).row == 1 {

            let title = UILabel()
            title.text = "昵称:"
            title.font = UIFont.systemFont(ofSize: 16)
            title.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title)
            title.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(60)
                make.height.equalTo(50)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(0)
            })

            username = UITextField()
            username.placeholder = "昵称限汉字、字母、数字、下划线"
            username.font = UIFont.systemFont(ofSize: 16)
            cell.contentView.addSubview(username)
            username.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 80)
                make.height.equalTo(40)
                make.left.equalTo(title.snp.right).offset(0)
                make.top.equalTo(cell.contentView).offset(5)

            })

            let line = UILabel()
            line.backgroundColor = CoreUtils.HDColor(227, g: 227, b: 229, a: 1)
            cell.contentView.addSubview(line)

            line.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 16)
                make.height.equalTo(1)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(49)

            })

        } else if (indexPath as NSIndexPath).row == 2 {

            let title = UILabel()
            title.text = "密码:"
            title.font = UIFont.systemFont(ofSize: 16)
            title.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title)
            title.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(60)
                make.height.equalTo(50)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(0)
            })

            password = UITextField()
            password.placeholder = "密码不少于6位，限字母和数字"
            password.font = UIFont.systemFont(ofSize: 16)
            cell.contentView.addSubview(password)
            password.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 90)
                make.height.equalTo(40)
                make.left.equalTo(title.snp.right).offset(0)
                make.top.equalTo(cell.contentView).offset(5)

            })

            let line = UILabel()
            line.backgroundColor = CoreUtils.HDColor(227, g: 227, b: 229, a: 1)
            cell.contentView.addSubview(line)

            line.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 16)
                make.height.equalTo(1)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(49)

            })

        } else {

            let completeBtn = UIButton(type: UIButton.ButtonType.custom)
            completeBtn.setTitle("完成", for: UIControl.State())
            completeBtn.backgroundColor = Constants.HDMainColor
            completeBtn.addTarget(self, action: #selector(completeAction), for: UIControl.Event.touchUpInside)
            completeBtn.layer.cornerRadius = 5
            completeBtn.layer.masksToBounds = true
            completeBtn.setTitleColor(UIColor.white, for: UIControl.State())
            cell.contentView.addSubview(completeBtn)

            completeBtn.snp.makeConstraints({ (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 40)
                make.height.equalTo(40)
                make.left.equalTo(cell.contentView).offset(20)
                make.top.equalTo(cell.contentView).offset(20)

            })
        }


        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath as NSIndexPath).row == 0 {

            return 60
        } else if (indexPath as NSIndexPath).row == 1 || (indexPath as NSIndexPath).row == 2 {

            return 50
        } else {

            return 140
        }

    }

}
