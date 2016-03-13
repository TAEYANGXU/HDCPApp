//
//  HDCT03Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/2/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDCT03Controller: UITableViewController {

    var mobile:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "注册"
        setupUI()
        
    }
    
    func setupUI(){
        
        self.view.backgroundColor = Constants.HDBGViewColor
        self.tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
    }
    
    // MARK: - events
    
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func nextAction(){
        
        
        guard CoreUtils.isMobileNumber(mobile.text!) else {
            
            //手机号码输入有误
            CoreUtils.showWarningHUD(self.view, title: "手机号码输入有误")
            return
        }
    
        let hdct04VC = HDCT04Controller()
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdct04VC, animated: true)
        
    }
    
    func protocolAction(){
    
        let hdct07VC = HDCT07Controller()
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdct07VC, animated: true)
        
    }
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return 2
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        let cell = tableView .dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if indexPath.row == 0 {
            
            let bg = UILabel()
            cell.contentView.addSubview(bg)
            bg.backgroundColor = Constants.HDBGViewColor
            bg.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(10)
                make.left.equalTo(cell.contentView).offset(0)
                make.top.equalTo(cell.contentView).offset(0)
            })
            
            let title = UILabel()
            title.text = "手机:"
            title.font = UIFont.systemFontOfSize(16)
            title.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title)
            title.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(50)
                make.height.equalTo(50)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(10)
            })
            
            mobile = UITextField()
            mobile.placeholder = "请输入手机号码"
            mobile.keyboardType = UIKeyboardType.NumberPad;
            mobile.font = UIFont.systemFontOfSize(16)
            cell.contentView.addSubview(mobile)
            mobile.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-80)
                make.height.equalTo(40)
                make.left.equalTo(title.snp_right).offset(0)
                make.top.equalTo(cell.contentView).offset(15)
                
            })
            
            
            let line = UILabel()
            line.backgroundColor = Constants.HDColor(227, g: 227, b: 229, a: 1)
            cell.contentView.addSubview(line)
            
            line.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-16)
                make.height.equalTo(1)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(59)
                
            })
            
        }else{
            
            
            let nextBtn = UIButton(type: UIButtonType.Custom)
            nextBtn.setTitle("下一步", forState: UIControlState.Normal)
            nextBtn.backgroundColor = UIColor.whiteColor()
            nextBtn.addTarget(self, action: "nextAction", forControlEvents: UIControlEvents.TouchUpInside)
            nextBtn.layer.cornerRadius = 5
            nextBtn.layer.masksToBounds = true
            nextBtn.layer.borderWidth = 1
            nextBtn.layer.borderColor = Constants.HDMainColor.CGColor
            nextBtn.setTitleColor(Constants.HDMainColor, forState: UIControlState.Normal)
            cell.contentView.addSubview(nextBtn)
            
            nextBtn.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-40)
                make.height.equalTo(40)
                make.left.equalTo(cell.contentView).offset(20)
                make.top.equalTo(cell.contentView).offset(20)
                
            })
            
            let title = "注册即表示同意《微菜谱协议》"
            let attributed = NSMutableAttributedString(string: title)
            attributed.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16), range: NSMakeRange(7, 7))
            attributed.addAttribute(NSForegroundColorAttributeName, value: Constants.HDMainColor, range: NSMakeRange(7, 7))
            
            
            let protocolT = UILabel()
            protocolT.textAlignment = NSTextAlignment.Center
            protocolT.textColor = Constants.HDMainTextColor
            protocolT.attributedText = attributed
            cell.contentView.addSubview(protocolT)
            protocolT.userInteractionEnabled = true
            /**
            *  添加点击事件
            */
            
            let tapGes = UITapGestureRecognizer(target: self, action: "protocolAction")
            protocolT.addGestureRecognizer(tapGes)
            
            
            protocolT.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-40)
                make.height.equalTo(25)
                make.left.equalTo(cell.contentView).offset(20)
                make.top.equalTo(cell.contentView).offset(80)
                
            })
            
            let loginBtn = UIButton(type: UIButtonType.Custom)
            loginBtn.setTitle("已有账号，点击登录", forState: UIControlState.Normal)
            loginBtn.backgroundColor = UIColor.clearColor()
            loginBtn.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
            loginBtn.setTitleColor(Constants.HDMainColor, forState: UIControlState.Normal)
            cell.contentView.addSubview(loginBtn)
            
            loginBtn.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-40)
                make.height.equalTo(40)
                make.left.equalTo(cell.contentView).offset(20)
                make.top.equalTo(cell.contentView).offset(115)
                
            })
            
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 60
        }else{
            
            return 160
        }
        
    }

}
