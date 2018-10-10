//
//  HDGG04Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/26.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDGG04Controller: BaseViewController, UITextViewDelegate {

    var btn: UIButton?
    var textView: UITextView?
    var placeholder: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "意见反馈"

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
    }

    deinit {

        HDLog.LogClassDestory("HDGG03Controller")

    }

    // MARK: - 创建UI视图

    func setupUI() {

        textView = UITextView()
        textView?.font = UIFont.systemFont(ofSize: 15)
        textView?.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        textView?.delegate = self
        self.view.addSubview(textView!)
        textView?.becomeFirstResponder()

        textView?.snp.makeConstraints( { (make) -> Void in

            make.top.equalTo(self.view).offset(0)
            make.left.equalTo(self.view).offset(0)
            make.height.equalTo(120)
            make.width.equalTo(Constants.HDSCREENWITH)
        })

        btn = UIButton(type: UIButton.ButtonType.custom)
        btn?.setTitle("提交", for: UIControl.State())
        btn?.setTitleColor(Constants.HDMainColor, for: UIControl.State.normal)
        btn?.backgroundColor = UIColor.white
        btn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn?.layer.borderColor = Constants.HDMainColor.cgColor
        btn?.layer.borderWidth = 1
        btn?.layer.cornerRadius = 5
        btn?.layer.masksToBounds = true
        btn?.addTarget(self, action: #selector(onClickAction), for: UIControl.Event.touchUpInside)
        self.view.addSubview(btn!)

        btn?.snp.makeConstraints( { (make) -> Void in

            make.top.equalTo(textView!.snp.bottom).offset(40)
            make.left.equalTo(self.view).offset(20)
            make.width.equalTo(Constants.HDSCREENWITH - 40)
            make.height.equalTo(40)

        })

        placeholder = UILabel()

        placeholder?.textColor = UIColor.lightGray
        placeholder?.text = "说点什么"
        placeholder?.backgroundColor = UIColor.clear
        placeholder?.isEnabled = false
        placeholder?.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(placeholder!)

        placeholder?.snp.makeConstraints( { (make) -> Void in

            make.top.equalTo(self.view).offset(7)
            make.left.equalTo(self.view).offset(8)
            make.height.equalTo(20)
            make.width.equalTo(100)

        })

    }

    // MARK: - 提示动画显示和隐藏
    func showHud() {

        CoreUtils.showProgressHUD(self.view)

    }

    @objc func hidenHud() {

        CoreUtils.hidProgressHUD(self.view)

        backAction()
    }

    // MARK: - events

    @objc func backAction() {

        navigationController!.popViewController(animated: true)

    }

    @objc func onClickAction() {

        if textView!.text.characters.count == 0 {

            CoreUtils.showWarningHUD(self.view, title: "请说点什么")
        } else {

            showHud()
            self.perform(#selector(hidenHud), with: self, afterDelay: 1.5)
        }

    }

    // MARK: - UITextView delegate
    func textViewDidChange(_ textView: UITextView) {

        if textView.text.characters.count == 0 {

            placeholder?.text = "说点什么"
        } else {

            placeholder?.text = ""
        }
    }
}
