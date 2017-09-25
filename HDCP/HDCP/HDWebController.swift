//
//  HDWebController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/13.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDWebController: BaseViewController, UIWebViewDelegate {


    var name: String!
    var url: String!
    var webView: UIWebView?

    override func viewDidLoad() {

        super.viewDidLoad()

        self.title = name

        setupUI()

        showHud()

        HDLog.LogOut(url as AnyObject)

    }

    // MARK: - 创建UI视图
    func setupUI() {

        let request: URLRequest = URLRequest(url: URL(string: url!)!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 30)
        webView = UIWebView()
        webView?.delegate = self
        webView?.backgroundColor = Constants.HDBGViewColor
        webView?.loadRequest(request)
        self.view.addSubview(webView!)

        unowned let WS = self;
        webView?.snp.makeConstraints({ (make) -> Void in

            make.top.equalTo(WS.view).offset(0)
            make.left.equalTo(WS.view).offset(0)
            make.bottom.equalTo(WS.view).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)

        })


    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
    }

    deinit {

        webView?.delegate = nil
        HDLog.LogClassDestory("HDWebController" as AnyObject)
    }

    // MARK: - events

    @objc func backAction() {

        navigationController!.popViewController(animated: true)

    }

    // MARK: - 提示动画显示和隐藏
    func showHud() {

        CoreUtils.showProgressHUD(self.webView!)

    }

    @objc func hidenHud() {

        CoreUtils.hidProgressHUD(self.webView!)
    }

    // MARK: - UIWebViewDelegate

    func webViewDidFinishLoad(_ webView: UIWebView) {

        self.perform(#selector(hidenHud), with: self, afterDelay: 0.5)
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {


        CoreUtils.showWarningHUD(self.view, title: Constants.HD_NO_NET_MSG)
    }
}
