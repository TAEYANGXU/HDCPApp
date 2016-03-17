//
//  HDCT02Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/2/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDCT02Controller: UITableViewController ,UITextFieldDelegate{

    var username:UITextField!
    var password:UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "登录"
        
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
    
    /**
     *  用户注册
     */
    func registAction(){
    
        let hdct03VC = HDCT03Controller()
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdct03VC, animated: true)
    }
    
    /**
     *  用户登录
     */
    func loginAction(){
    
        
        guard username.text?.characters.count > 0 else {
        
            CoreUtils.showWarningHUD(self.view, title: "请输入用户名")
            return
        }
        
        guard password.text?.characters.count > 0 else {
            
            CoreUtils.showWarningHUD(self.view, title: "请输入密码")
            return
        }
        
        //登录
        
        HDCT02Service().doGetRequest_HDCT02_01_URL("8752979", successBlock: { (hdResponse) -> Void in
            
            }) { (error) -> Void in
                
        }
    }
    
    /**
     *  忘记密码
     */
    func forgetAction(){
    
        
    }
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return 3
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
            title.text = "账号:"
            title.font = UIFont.systemFontOfSize(16)
            title.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title)
            title.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(50)
                make.height.equalTo(50)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(10)
            })
            
            username = UITextField()
            username.text = "15221472030"
            username.placeholder = "请输入邮箱账号或手机号码"
            username.font = UIFont.systemFontOfSize(16)
            cell.contentView.addSubview(username)
            username.snp_makeConstraints(closure: { (make) -> Void in
                
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
            
        }else if indexPath.row == 1 {
            
            let title = UILabel()
            title.text = "密码:"
            title.font = UIFont.systemFontOfSize(16)
            title.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title)
            title.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(50)
                make.height.equalTo(50)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(0)
            })
            
            password = UITextField()
            password.placeholder = "密码不少于6位，限字母和数字"
            password.text = "12345678"
            password.font = UIFont.systemFontOfSize(16)
            password.secureTextEntry = true
            cell.contentView.addSubview(password)
            password.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-80)
                make.height.equalTo(40)
                make.left.equalTo(title.snp_right).offset(0)
                make.top.equalTo(cell.contentView).offset(5)
                
            })
            
            let line = UILabel()
            line.backgroundColor = Constants.HDColor(227, g: 227, b: 229, a: 1)
            cell.contentView.addSubview(line)
            
            line.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-16)
                make.height.equalTo(1)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(49)
                
            })

        }else{
            
            let forgetBtn = UIButton(type: UIButtonType.Custom)
            forgetBtn.setTitle("忘记密码?", forState: UIControlState.Normal)
            forgetBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
            forgetBtn.addTarget(self, action: "forgetAction", forControlEvents: UIControlEvents.TouchUpInside)
            forgetBtn.setTitleColor(Constants.HDMainColor, forState: UIControlState.Normal)
            cell.contentView.addSubview(forgetBtn)
            
            forgetBtn.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(80)
                make.height.equalTo(40)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(20)
                
            })
            
            
            let registBtn = UIButton(type: UIButtonType.Custom)
            registBtn.setTitle("注册", forState: UIControlState.Normal)
            registBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
            registBtn.addTarget(self, action: "registAction", forControlEvents: UIControlEvents.TouchUpInside)
            registBtn.setTitleColor(Constants.HDMainColor, forState: UIControlState.Normal)
            cell.contentView.addSubview(registBtn)
            
            registBtn.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(80)
                make.height.equalTo(40)
                make.right.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(20)
                
            })
            
            
            let loginBtn = UIButton(type: UIButtonType.Custom)
            loginBtn.setTitle("登录", forState: UIControlState.Normal)
            loginBtn.backgroundColor = Constants.HDMainColor
            loginBtn.addTarget(self, action: "loginAction", forControlEvents: UIControlEvents.TouchUpInside)
            loginBtn.layer.cornerRadius = 5
            loginBtn.layer.masksToBounds = true
            loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            cell.contentView.addSubview(loginBtn)

            loginBtn.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-40)
                make.height.equalTo(40)
                make.left.equalTo(cell.contentView).offset(20)
                make.top.equalTo(cell.contentView).offset(70)
                
            })
        }

        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
        
            return 60
        }else if indexPath.row == 1 {
        
            return 50
        }else{
        
            return 140
        }
        
    }

}
