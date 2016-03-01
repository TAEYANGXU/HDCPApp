//
//  HDHM10Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/1.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM10Controller: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var response:HDHM08Response!
    var tableView:UITableView!
    var putView:UIView!
    var textView:UITextField!
    var commitBtn:UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        getContentHeight()
        
        setupUI()
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        
        tableView = UITableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
        tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        tableView.tableFooterView = UIView()
        tableView?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.top.equalTo(self.view).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.left.equalTo(self.view).offset(0)
            make.height.equalTo(Constants.HDSCREENHEIGHT-64-50)
            
        })
        
        putView = UIView()
        putView.backgroundColor = Constants.HDBGViewColor
        self.view.addSubview(putView)
        
        putView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(tableView.snp_bottom).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.left.equalTo(self.view).offset(0)
            make.height.equalTo(50)
            
        }
        
        /**
        *  输入框
        */
        
        textView = UITextField()
        textView.placeholder = "说点什么..."
        textView.layer.borderWidth = 0.7
        textView.layer.borderColor = Constants.HDMainTextColor.CGColor
        textView.layer.cornerRadius = 5
        textView.font = UIFont.systemFontOfSize(15)
        textView.layer.masksToBounds = true
        putView.addSubview(textView)
        
        textView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(putView.snp_top).offset(5)
            make.left.equalTo(putView).offset(15)
            make.width.equalTo(Constants.HDSCREENWITH-15-80)
            make.height.equalTo(40)
            
        }
        
        
        commitBtn = UIButton(type: UIButtonType.Custom)
        commitBtn.setTitle("发送", forState: UIControlState.Normal)
        commitBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        commitBtn.backgroundColor = Constants.HDMainColor
        commitBtn.setTitleColor(Constants.HDMainTextColor, forState: UIControlState.Normal)
        commitBtn.layer.cornerRadius = 5
        commitBtn.layer.masksToBounds = true
        putView.addSubview(commitBtn)
        
        commitBtn.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(textView.snp_right).offset(10)
            make.top.equalTo(putView.snp_top).offset(5)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
        self.title = String(format: "评论(%d)", (self.response.result?.comment?.count)!)
      
    }
    
    // MARK: - 计算文本高度
    
    func getContentHeight(){
    
        for (var i=0;i<self.response.result?.comment?.count;i++) {
        
            let rect = CoreUtils.getTextRectSize((self.response.result?.comment![i].content)!, font: UIFont.systemFontOfSize(15), size: CGSizeMake(Constants.HDSCREENWITH-80, 999))
            self.response.result?.comment![i].height = rect.height
            
        }
        
    }

    // MARK: - events
    
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    // MARK: - UIScrollView delegate
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return (self.response.result?.comment?.count)!
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell
    {
        
        let cell = tableView .dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        /**
        *   头像
        */
        
        var icon = cell.contentView.viewWithTag(1000) as? UIImageView
        
        if icon == nil {
        
            icon = UIImageView()
            icon?.tag = 1000
            icon?.layer.cornerRadius = 20
            icon?.layer.masksToBounds = true
            cell.contentView.addSubview(icon!)
            
            icon?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(cell.contentView).offset(10)
                make.left.equalTo(cell.contentView).offset(15)
                make.width.equalTo(40)
                make.height.equalTo(40)
                
                
            })
            
        }
        
        /**
        *   昵称
        */
         
         var username = cell.contentView.viewWithTag(2000) as? UILabel
        
        if username == nil {
        
            username = UILabel()
            username?.tag = 2000
            username?.font = UIFont.systemFontOfSize(14)
            username?.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(username!)
            
            username?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(cell.contentView).offset(12)
                make.left.equalTo(icon!.snp_right).offset(5)
                make.width.equalTo(200)
                make.height.equalTo(20)
            })
            
        }
         
        
        /**
        *   发表时间
        */
         
        var createTime = cell.contentView.viewWithTag(3000) as? UILabel
        
        if createTime == nil {
            
            createTime = UILabel()
            createTime?.tag = 3000
            createTime?.font = UIFont.systemFontOfSize(12)
            createTime?.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(createTime!)
            
            createTime?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(username!.snp_bottom).offset(0)
                make.left.equalTo(icon!.snp_right).offset(5)
                make.width.equalTo(200)
                make.height.equalTo(20)
            })
            
        }

        
        /**
        *   内容
        */
        
        var content = cell.contentView.viewWithTag(4000) as? UILabel
        
        if content == nil {
            
            content = UILabel()
            content?.tag = 4000
            content?.font = UIFont.systemFontOfSize(15)
            content?.textColor = Constants.HDMainTextColor
            content?.numberOfLines = 0
            cell.contentView.addSubview(content!)
            
            content?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(icon!.snp_bottom).offset(5)
                make.left.equalTo(cell.contentView).offset(60)
                make.width.equalTo(Constants.HDSCREENWITH-80)
                make.height.equalTo(20)
            })
            
        }

        
        let model = response.result?.comment![indexPath.row]
        
        icon?.sd_setImageWithURL(NSURL(string: (model?.avatar)!), placeholderImage: UIImage(imageLiteral: "noDataDefaultIcon"))
        username?.text = model?.userName
        createTime?.text = model?.createTime
        content?.text = model?.content
        
        content?.snp_updateConstraints(closure: { (make) -> Void in
            
            make.height.equalTo(model!.height)
            
        })
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        
        let model = response.result?.comment![indexPath.row]
        return 60 + model!.height
    }
}
