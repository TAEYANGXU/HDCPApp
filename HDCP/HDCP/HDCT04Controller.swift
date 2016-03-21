//
//  HDCT04Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/2/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDCT04Controller: UITableViewController ,UITextFieldDelegate{
    
    var code:UITextField!
    var username:UITextField!
    var password:UITextField!
    var secondBtn:UIButton!
    var timer:NSTimer!
    var second:Int = 59
    
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
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        timer.fire()
        
    }
    
    // MARK: - events
    func backAction(){
        
        for vc in  (self.navigationController?.viewControllers)! {
        
            if vc.isKindOfClass(HDCT02Controller.classForCoder()){
            
                 self.navigationController?.popToViewController(vc, animated: true)
            }
            
        }
        
    }
    
    /**
     *  倒计时
     */
    func timerAction(){
    
        if second == 0 {
            timer.invalidate()
            secondBtn.enabled = true
            secondBtn.setTitle("重新获取", forState: UIControlState.Normal)
        }else{
            
            secondBtn.enabled = false
            secondBtn.setTitle(String(format: "重新获取(%d)",second), forState: UIControlState.Normal)
            second--
        }
        
    }
    
    /**
     *  重新获取
     */
    func againAction(){
    
        timer = nil
        second = 59
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        timer.fire()
    }
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return 4
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
            title.text = "验证码:"
            title.font = UIFont.systemFontOfSize(16)
            title.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title)
            title.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(60)
                make.height.equalTo(50)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(10)
            })
            
            code = UITextField()
            code.placeholder = "请输入验证码"
            code.font = UIFont.systemFontOfSize(16)
            cell.contentView.addSubview(code)
            code.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-190)
                make.height.equalTo(40)
                make.left.equalTo(title.snp_right).offset(0)
                make.top.equalTo(cell.contentView).offset(15)
                
            })
            
            secondBtn = UIButton(type: UIButtonType.Custom)
            secondBtn.layer.cornerRadius = 5
            secondBtn.layer.masksToBounds = true
            secondBtn.layer.borderWidth = 1
            secondBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
            secondBtn.layer.borderColor = Constants.HDMainColor.CGColor
            secondBtn.setTitleColor(Constants.HDMainColor, forState: UIControlState.Normal)
            secondBtn.addTarget(self, action: "againAction", forControlEvents: UIControlEvents.TouchUpInside)
            secondBtn.backgroundColor = UIColor.whiteColor()
            cell.contentView.addSubview(secondBtn)
            
            secondBtn.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(90)
                make.height.equalTo(30)
                make.right.equalTo(cell.contentView.snp_right).offset(-10)
                make.top.equalTo(cell.contentView).offset(20)
                
            })
            
            let line = UILabel()
            line.backgroundColor = CoreUtils.HDColor(227, g: 227, b: 229, a: 1)
            cell.contentView.addSubview(line)
            
            line.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-16)
                make.height.equalTo(1)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(59)
                
            })
            
        }else if indexPath.row == 1 {
            
            let title = UILabel()
            title.text = "昵称:"
            title.font = UIFont.systemFontOfSize(16)
            title.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title)
            title.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(60)
                make.height.equalTo(50)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(0)
            })
            
            username = UITextField()
            username.placeholder = "昵称限汉字、字母、数字、下划线"
            username.font = UIFont.systemFontOfSize(16)
            cell.contentView.addSubview(username)
            username.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-80)
                make.height.equalTo(40)
                make.left.equalTo(title.snp_right).offset(0)
                make.top.equalTo(cell.contentView).offset(5)
                
            })
            
            let line = UILabel()
            line.backgroundColor = CoreUtils.HDColor(227, g: 227, b: 229, a: 1)
            cell.contentView.addSubview(line)
            
            line.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-16)
                make.height.equalTo(1)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(49)
                
            })
          
        }else if indexPath.row == 2 {
            
            let title = UILabel()
            title.text = "密码:"
            title.font = UIFont.systemFontOfSize(16)
            title.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(title)
            title.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(60)
                make.height.equalTo(50)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(0)
            })
            
            password = UITextField()
            password.placeholder = "密码不少于6位，限字母和数字"
            password.font = UIFont.systemFontOfSize(16)
            cell.contentView.addSubview(password)
            password.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-90)
                make.height.equalTo(40)
                make.left.equalTo(title.snp_right).offset(0)
                make.top.equalTo(cell.contentView).offset(5)
                
            })
            
            let line = UILabel()
            line.backgroundColor = CoreUtils.HDColor(227, g: 227, b: 229, a: 1)
            cell.contentView.addSubview(line)
            
            line.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-16)
                make.height.equalTo(1)
                make.left.equalTo(cell.contentView).offset(16)
                make.top.equalTo(cell.contentView).offset(49)
                
            })
            
        }else{
            
            let completeBtn = UIButton(type: UIButtonType.Custom)
            completeBtn.setTitle("完成", forState: UIControlState.Normal)
            completeBtn.backgroundColor = Constants.HDMainColor
            completeBtn.addTarget(self, action: "completeAction", forControlEvents: UIControlEvents.TouchUpInside)
            completeBtn.layer.cornerRadius = 5
            completeBtn.layer.masksToBounds = true
            completeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            cell.contentView.addSubview(completeBtn)
            
            completeBtn.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-40)
                make.height.equalTo(40)
                make.left.equalTo(cell.contentView).offset(20)
                make.top.equalTo(cell.contentView).offset(20)
                
            })
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 60
        }else if indexPath.row == 1 || indexPath.row == 2 {
            
            return 50
        }else{
            
            return 140
        }
        
    }
    
}