//
//  HDGG04Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/26.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDGG04Controller: BaseViewController ,UITextViewDelegate{

    var btn:UIButton?
    var textView:UITextView?
    var placeholder:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "意见反馈"
        
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        textView = UITextView()
        textView?.font = UIFont.systemFontOfSize(15)
        textView?.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        textView?.delegate = self
        self.view.addSubview(textView!)
        textView?.becomeFirstResponder()
        
        textView?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.top.equalTo(self.view).offset(0)
            make.left.equalTo(self.view).offset(0)
            make.height.equalTo(200)
            make.width.equalTo(Constants.HDSCREENWITH)
        })
        
        btn = UIButton(type: UIButtonType.Custom)
        btn?.setTitle("提交", forState: UIControlState.Normal)
        btn?.setTitleColor(Constants.HDMainColor, forState: UIControlState.Normal)
        btn?.backgroundColor = UIColor.whiteColor()
        btn?.titleLabel?.font = UIFont.systemFontOfSize(15)
        btn?.layer.borderColor = Constants.HDMainColor.CGColor
        btn?.layer.borderWidth = 1
        btn?.layer.cornerRadius = 5
        btn?.layer.masksToBounds = true
        btn?.addTarget(self, action: "onClickAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn!)
        
        btn?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.top.equalTo(textView!.snp_bottom).offset(40)
            make.left.equalTo(self.view).offset(20)
            make.width.equalTo(Constants.HDSCREENWITH-40)
            make.height.equalTo(40)
            
        })
        
        placeholder = UILabel()
        
        placeholder?.textColor = UIColor.lightGrayColor()
        placeholder?.text = "说点什么"
        placeholder?.backgroundColor = UIColor.clearColor()
        placeholder?.enabled = false
        placeholder?.font = UIFont.systemFontOfSize(15)
        self.view.addSubview(placeholder!)
        
        placeholder?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.top.equalTo(self.view).offset(71)
            make.left.equalTo(self.view).offset(8)
            make.height.equalTo(20)
            make.width.equalTo(100)
            
        })
        
    }
    
    // MARK: - 提示动画显示和隐藏
    func showHud(){
        
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.view)
        
        backAction()
    }
    
    // MARK: - events
    
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func onClickAction(){
    
        if textView!.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            
            CoreUtils.showWarningHUD(self.view, title: "请说点什么")
        }else{
        
            showHud()
            self.performSelector("hidenHud", withObject: self, afterDelay: 1.5)
        }
        
    }
    
    // MARK: - UITextView delegate
    func textViewDidChange(textView: UITextView){
    
        if textView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
        
            placeholder?.text = "说点什么"
        }else{
        
            placeholder?.text = ""
        }
    }
}
