//
//  HDHM10Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/1.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class HDHM10Controller: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var tableView:UITableView!
    var putView:UIView!
    var textView:UITextField!
    var commitBtn:UIButton!
    var commentArray = Array<HDHM10Comment>()
    var offset:Int!
    var rid:Int!
    
    //rid=%@&type=0&offset=0&limit=20
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        offset = 0
        
        setupUI()
        showHud()
        doGetRequestData(50,offset: self.offset)
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        unowned let WS = self
        
        tableView = UITableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
        tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        tableView.tableFooterView = UIView()
        
        tableView.snp.makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.top.equalTo(0)
            make.bottom.equalTo(-50)
            
        }
        
        tableView.isUserInteractionEnabled = true
        
        /**
        *   添加点击事件收齐键盘
        */
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tableView.addGestureRecognizer(tapGes)

        
        putView = UIView()
        putView.backgroundColor = Constants.HDBGViewColor
        self.view.addSubview(putView)
        
        
        putView.snp.makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.top.equalTo(WS.tableView.snp.bottom).offset(0)
            make.bottom.equalTo(0);
            
        }
        
        
        /**
        *  分割线
        */
        
        let line = UIView()
        line.frame = CoreUtils.HDFrame(0, y: 0, width: Constants.HDSCREENWITH, height: 1)
        line.backgroundColor = CoreUtils.HDColor(227, g: 227, b: 229, a: 1)
        putView.addSubview(line)
        
        /**
        *  输入框
        */
        
        textView = UITextField()
        textView.placeholder = "说点什么..."
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = Constants.HDMainTextColor.cgColor
        textView.layer.cornerRadius = 5
        textView.backgroundColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.layer.masksToBounds = true
        putView.addSubview(textView)
        
        textView.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(WS.putView.snp.top).offset(5)
            make.left.equalTo(WS.putView).offset(15)
            make.width.equalTo(Constants.HDSCREENWITH-15-80)
            make.height.equalTo(40)
            
        }
        
        
        commitBtn = UIButton(type: UIButtonType.custom)
        commitBtn.setTitle("发送", for: UIControlState())
        commitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        commitBtn.backgroundColor = Constants.HDMainColor
        commitBtn.setTitleColor(UIColor.white, for: UIControlState())
        commitBtn.addTarget(self, action: #selector(sendComment), for: UIControlEvents.touchUpInside)
        commitBtn.layer.cornerRadius = 5
        commitBtn.layer.masksToBounds = true
        putView.addSubview(commitBtn)
        
        commitBtn.snp.makeConstraints { (make) -> Void in
            
            make.left.equalTo(WS.textView.snp.right).offset(10)
            make.top.equalTo(WS.putView.snp.top).offset(5)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame , object: nil)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
        
      
    }
    
    deinit{
    
        tableView.delegate = nil
        tableView.dataSource = nil
        
        /**
        *  移除通知
        */
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        HDLog.LogClassDestory("HDHM10Controller")
    }
    
    // MARK: - 键盘变化
    func keyboardWillShow(_ note:Notification){
    
        
       let rect =  (note as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey]
        
        let height:CGFloat = ((rect as AnyObject).cgRectValue.height)
        
        unowned let WS = self
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            WS.tableView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(-(height+50))
            })
            
            WS.view.layoutIfNeeded()
            
            if WS.commentArray.count>0 {
                
                /// cell滚动到底部
                let indexPath = IndexPath(row: WS.commentArray.count-1, section: 0)
                WS.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
            }
            
        }) 
        
    }
    
    func keyboardWillHide(_ note:Notification){
        
        unowned let WS = self
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            WS.tableView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(-50)
            })
            
            WS.view.layoutIfNeeded()
            
            if WS.commentArray.count>0 {
                
                /// cell滚动到底部
                let indexPath = IndexPath(row: WS.commentArray.count-1, section: 0)
                WS.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
            }
            
        }) 
        
    }
    
    func keyboardWillChange(_ note:Notification){
        
       

        
    }
    
    // MARK: - 提示动画显示和隐藏
    func showHud(){
        
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.view)
    }
    
    // MARK: - 计算文本高度
    
    func getContentHeight(){
    
        for i in 0 ..< commentArray.count {
        
            let comment:HDHM10Comment = commentArray[i]
            let rect = CoreUtils.getTextRectSize((comment.content)! as NSString, font: UIFont.systemFont(ofSize: 15), size: CGSize(width: Constants.HDSCREENWITH-80, height: 999))
            commentArray[i].height = rect.height
            
        }
        
    }
    
    
    // MARK: - 数据加载
    func doGetRequestData(_ limit:Int,offset:Int){
        
        unowned let WS = self
        
        HDHM10Service().doGetRequest_HDHM10_URL(limit, offset: offset,rid: rid, successBlock: { (hm10Response) -> Void in
            
            WS.offset = WS.offset+10
            
            WS.hidenHud()
            
            if hm10Response.result?.list?.count > 0 {
            
                WS.commentArray = (hm10Response.result?.list)!
            }
            
            WS.getContentHeight()
            
            WS.title = String(format: "评论(%d)", WS.commentArray.count)
            
            WS.tableView.reloadData()
            
        }) { (error) -> Void in
            
            WS.tableView.mj_footer.endRefreshing()
            CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }

    // MARK: - events
    
    func backAction(){
        
        navigationController!.popViewController(animated: true)
        
    }
    
    /**
     * 隐藏键盘
     */
    func hideKeyBoard(){
    
        textView.resignFirstResponder()
        
        
    }
    
    /**
     *  发送评论
     */
    func sendComment(){
    
        if textView.text?.characters.count > 0 {
        
            let mutableArray = NSMutableArray(array: commentArray)
            let model = HDHM10Comment()
            model.avatar = ""
            model.content = textView.text
            model.createTime = "刚刚"
            model.userName = "小徐"
            let rect = CoreUtils.getTextRectSize(textView.text! as NSString, font: UIFont.systemFont(ofSize: 15), size: CGSize(width: Constants.HDSCREENWITH-80, height: 999))
            model.height = rect.height
            mutableArray.add(model)
            commentArray = NSArray(array: mutableArray) as! Array<HDHM10Comment>
            
            tableView.reloadData()
            
            let indexPath = IndexPath(row: commentArray.count-1, section: 0)
            tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            
            textView.text = ""
            
            self.title = String(format: "评论(%d)", commentArray.count)
            
        }
        
        
    }
    
    // MARK: - UIScrollView delegate
    func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return commentArray.count
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) ->UITableViewCell
    {
        
        let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
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
            
            icon?.snp.makeConstraints( { (make) -> Void in
                
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
            username?.font = UIFont.systemFont(ofSize: 14)
            username?.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(username!)
            
            username?.snp.makeConstraints( { (make) -> Void in
                
                make.top.equalTo(cell.contentView).offset(12)
                make.left.equalTo(icon!.snp.right).offset(5)
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
            createTime?.font = UIFont.systemFont(ofSize: 12)
            createTime?.textColor = Constants.HDMainTextColor
            cell.contentView.addSubview(createTime!)
            
            createTime?.snp.makeConstraints( { (make) -> Void in
                
                make.top.equalTo(username!.snp.bottom).offset(0)
                make.left.equalTo(icon!.snp.right).offset(5)
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
            content?.font = UIFont.systemFont(ofSize: 15)
            content?.textColor = Constants.HDMainTextColor
            content?.numberOfLines = 0
            cell.contentView.addSubview(content!)
            
            content?.snp.makeConstraints( { (make) -> Void in
                
                make.top.equalTo(icon!.snp.bottom).offset(5)
                make.left.equalTo(cell.contentView).offset(60)
                make.width.equalTo(Constants.HDSCREENWITH-80)
                make.height.equalTo(20)
            })
            
        }

        
        let model = commentArray[(indexPath as NSIndexPath).row]
        icon?.kf.setImage(with: URL(string: (model.avatar)!), placeholder: UIImage(named:"defaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)
        
        username?.text = model.userName
        createTime?.text = model.createTime
        content?.text = model.content
        
        content?.snp.updateConstraints({ (make) -> Void in
            
            make.height.equalTo(model.height)
            
        })
        
        /**
        *  富文本 - 给名称添加颜色
        */
        if model.content.hasPrefix("@") {
        
            let str:String =  model.content.components(separatedBy: ":")[0]
            let attributed = NSMutableAttributedString(string: model.content)
            attributed.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, str.characters.count))
            attributed.addAttribute(NSForegroundColorAttributeName, value: Constants.HDYellowColor, range: NSMakeRange(0, str.characters.count))
            content?.attributedText =  attributed
        }else{
        
            content?.textColor = Constants.HDMainTextColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        
        let model = commentArray[(indexPath as NSIndexPath).row]
        return 60 + model.height
    }
}
