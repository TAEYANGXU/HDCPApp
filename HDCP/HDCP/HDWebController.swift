//
//  HDWebController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/13.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDWebController: BaseViewController ,UIWebViewDelegate{

    
    var name:String!
    var url:String!
    var webView:UIWebView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = name
        
        setupUI()
        
        showHud()
        
        print("\(url)")
        
    }
    
    // MARK: - 创建UI视图
    func setupUI(){
    
        let request:NSURLRequest = NSURLRequest(URL: NSURL(string: url!)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 30)
        webView = UIWebView()
        webView?.delegate = self
        webView?.backgroundColor = Constants.HDBGViewColor
        webView?.loadRequest(request)
        self.view.addSubview(webView!)
        webView?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.top.equalTo(self.view).offset(0)
            make.left.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            
        })

        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
    }
    
    deinit{
    
        webView?.delegate = nil
    }
    
    // MARK: - events
    
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    // MARK: - 提示动画显示和隐藏
    func showHud(){
        
        CoreUtils.showProgressHUD(self.webView!)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.webView!)
    }
    
    // MARK: - UIWebViewDelegate
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        self.performSelector("hidenHud", withObject: self, afterDelay: 0.5)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        
        CoreUtils.showWarningHUD(self.view, title: Constants.HD_NO_NET_MSG)
    }
}
