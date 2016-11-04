//
//  HDCT10Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/3/14.
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


class DTView: UIView {
    
    var index:Int?
    
}

class HDCT10Controller: UITableViewController {

    var videoPlayerController:HDVideoPlayerController?
    var dataArray:NSMutableArray!
    var offset:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offset = 0
        dataArray  = NSMutableArray()
        setupUI()
        showHud()
        doGetRequestData(10,offset: self.offset)

        
    }
    
    // MARK: - 创建UI视图
    func setupUI(){
        
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        self.tableView.backgroundColor = Constants.HDBGViewColor

        
        //当列表滚动到底端 视图自动刷新
        unowned let WS = self;
        self.tableView?.mj_footer = HDRefreshGifFooter(refreshingBlock: { () -> Void in
            WS.doGetRequestData(10,offset: WS.offset)
        })
    }
    
    
    // MARK: - 提示动画显示和隐藏
    func showHud(){
        
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.view)
    }
    
    
    // MARK: - 计算cell的高度
    func getRowHeight(){
    
        
        if dataArray.count > 0 {
        
            
            for i in 0 ..< dataArray.count {
            
                let model = dataArray[i] as! HDCT10ListModel
                
                let contentStr = String(format: "[%@]%@", model.data!.tagName!,model.data!.content!)
                
                let contentRect = CoreUtils.getTextRectSize(contentStr as NSString, font: UIFont.systemFont(ofSize: 14), size: CGSize(width: Constants.HDSCREENWITH-100, height: 9999))
                model.contentHeight = contentRect.size.height;
                
                let row = Int(contentRect.size.height/16)
                
                if row >= 3 {
                
                    model.contentHeight = 60.0;
                }else if row == 1 {
                
                    model.contentHeight = 20.0;
                }else if row == 2 {
                
                    model.contentHeight = 40.0;
                }
                
                if model.data!.commentList?.count>0 {
                
                    let comment:HDCT10CommentListModel = model.data!.commentList![0]
                    let commentStr = String(format: "%@: %@",comment.userName!,comment.content!)
                    let commentRect = CoreUtils.getTextRectSize(commentStr as NSString, font: UIFont.systemFont(ofSize: 14), size: CGSize(width: Constants.HDSCREENWITH-110, height: 9999))
                    let row = Int(commentRect.size.height/16)
                    model.fcommentRow = row
                    model.rowHeight = 365 + model.contentHeight!
                    
                }else{
                
                    model.rowHeight = 285 + model.contentHeight!
                }
                
                
                
            }
            
            
        }
        
        
    }
    
    deinit{
        
        HDLog.LogOut("HDCT10Controller" as AnyObject)
        videoPlayerController = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "动态"
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
        
    }
    
    // MARK: - events
    func backAction(){
        
        videoPlayerController?.close()
        navigationController!.popViewController(animated: true)
        
    }
    
    func commentAction(_ tap:UITapGestureRecognizer){
    
        
        let view = tap.view as! DTView;
        
        HDLog.LogOut("index" as AnyObject, obj: view.index! as AnyObject)
        
        
    }
    

    // MARK: - 数据加载
    func doGetRequestData(_ limit:Int,offset:Int){
        
        unowned let WS = self;
        HDCT10Service().doGetRequest_HDCT10_URL(0, offset: 0, successBlock: { (hdResponse) -> Void in
            
            WS.offset = WS.offset+10
            
            WS.hidenHud()
            
            WS.dataArray.addObjects(from: (hdResponse.result?.list)!)
            
            WS.getRowHeight();
            
            WS.tableView.mj_footer.endRefreshing()
            
            WS.tableView.reloadData()
            
            }) { (error) -> Void in
                
                WS.tableView.mj_footer.endRefreshing()
                CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }
    
    
    // MARK: - UITableView delegate/datasource
    
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return self.dataArray.count
    }
    
    override func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) ->UITableViewCell
    {
        let cell = tableView .dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.none
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //头像
        var icon = cell.contentView.viewWithTag(1000) as? UIImageView
        
        if icon == nil {
            
            icon = UIImageView()
            icon?.layer.cornerRadius = 25
            icon?.tag = 1000
            icon?.layer.masksToBounds = true
            cell.contentView.addSubview(icon!)
            
            icon?.snp.makeConstraints({ (make) -> Void in
                
                make.left.equalTo(15)
                make.top.equalTo(10)
                make.width.equalTo(50)
                make.height.equalTo(50)
                
            })
            
        }
        
        //名称
        var name = cell.contentView.viewWithTag(2000) as? UILabel
        
        if name == nil {
            
            name = UILabel()
            name?.textColor = Constants.HDMainTextColor
            name?.adjustsFontSizeToFitWidth=true
            name?.tag = 2000
            name?.font = UIFont.systemFont(ofSize: 17)
            cell.contentView.addSubview(name!)
            
            name?.snp.makeConstraints({ (make) -> Void in
                
                make.left.equalTo(icon!.snp.right).offset(10)
                make.top.equalTo(cell.contentView).offset(10)
                make.width.equalTo(60)
                make.height.equalTo(20)
                
            })
        }
        
        //是否是VIP用户
        var vip = cell.contentView.viewWithTag(3000) as? UIImageView
        
        if vip == nil {
            
            vip = UIImageView()
            vip?.tag = 3000
            cell.contentView.addSubview(vip!)
            
            vip?.snp.makeConstraints({ (make) -> Void in
                
                make.top.equalTo(10)
                make.left.equalTo(name!.snp.right).offset(10)
                make.width.equalTo(20)
                make.height.equalTo(20)
                
            })
            
        }
        
        //性别
        var sex = cell.contentView.viewWithTag(4000) as? UIImageView
        
        if sex == nil {
            
            sex = UIImageView()
            sex?.tag = 4000
            cell.contentView.addSubview(sex!)
            
            sex?.snp.makeConstraints({ (make) -> Void in
                
                
                make.top.equalTo(10)
                make.left.equalTo(vip!.snp.right).offset(10)
                make.width.equalTo(20)
                make.height.equalTo(20)
            })
            
        }
        
        //菜谱名称
        var title = cell.contentView.viewWithTag(5000) as? UILabel
        
        if title == nil {
        
            title = UILabel()
            title?.tag = 5000
            title?.textColor = Constants.HDMainTextColor
            title?.font = UIFont.systemFont(ofSize: 15)
            cell.contentView.addSubview(title!)
            
            title?.snp.makeConstraints({ (make) -> Void in
                
                make.top.equalTo(icon!.snp.bottom).offset(5)
                make.left.equalTo(icon!.snp.right).offset(10)
                make.width.equalTo(Constants.HDSCREENWITH - 120)
                make.height.equalTo(20);
                
            })
            
        }
        
        //内容
        
        var content = cell.contentView.viewWithTag(6000) as? UILabel
        
        if content == nil {
        
            content = UILabel()
            content?.tag = 6000
            content?.textColor = Constants.HDMainTextColor
            content?.numberOfLines = 0
            content?.font = UIFont.systemFont(ofSize: 14)
            cell.contentView.addSubview(content!)
            
            content?.snp.makeConstraints({ (make) -> Void in
                
                make.top.equalTo(title!.snp.bottom).offset(5)
                make.left.equalTo(icon!.snp.right).offset(10)
                make.width.equalTo(Constants.HDSCREENWITH - 100)
                make.height.equalTo(20);
                
            })
            
        }
        //图片
        var imageView = cell.contentView.viewWithTag(7000) as? UIImageView
        
        
        if imageView == nil {
        
            imageView = UIImageView()
            imageView?.tag = 7000
            cell.contentView.addSubview(imageView!)
            imageView?.snp.makeConstraints({ (make) -> Void in
                
                make.top.equalTo(content!.snp.bottom).offset(5)
                make.left.equalTo(icon!.snp.right).offset(10)
                make.height.equalTo(120)
                make.width.equalTo(Constants.HDSCREENWITH - 150)
                
            })
        }
        
        //播放图片
        var playView = imageView!.viewWithTag(7100) as? UIImageView
        
        if playView == nil {
            
            playView = UIImageView()
            playView?.tag = 7100
            playView?.image = UIImage(named: "playIcon")
            imageView!.addSubview(playView!)
            playView?.snp.makeConstraints({ (make) -> Void in
                
                make.top.equalTo(120/2-25)
                make.left.equalTo((Constants.HDSCREENWITH - 150)/2-25)
                make.height.equalTo(50)
                make.width.equalTo(50)
                
            })
        }
        
        //时间
        var time = cell.contentView.viewWithTag(8000) as? UILabel
        
        if time == nil {
        
            time = UILabel()
            time?.tag = 8000
            time?.textColor = Constants.HDMainTextColor
            time?.font = UIFont.systemFont(ofSize: 14)
            cell.contentView.addSubview(time!)
            
            time?.snp.makeConstraints({ (make) -> Void in
                
                make.top.equalTo(imageView!.snp.bottom).offset(10)
                make.left.equalTo(icon!.snp.right).offset(10)
                make.width.equalTo(Constants.HDSCREENWITH - 100)
                make.height.equalTo(20);
                
            })
            
        }
        
        //评论视图
        var commentView = cell.contentView.viewWithTag(9000) as? DTView
        
        if commentView == nil {
        
            commentView = DTView()
            commentView?.tag = 9000
            commentView?.layer.cornerRadius = 5
            commentView?.layer.masksToBounds = true
            commentView?.backgroundColor = CoreUtils.HDColor(249, g: 249, b: 249, a: 1)
            cell.contentView.addSubview(commentView!)
            
            commentView?.snp.makeConstraints({ (make) -> Void in
                
                make.top.equalTo(time!.snp.bottom).offset(15)
                make.left.equalTo(icon!.snp.right).offset(10)
                make.width.equalTo(Constants.HDSCREENWITH - 100)
                make.height.equalTo(80);
                
            })
            
        }
        
        //豆友评论
        var comment = commentView?.viewWithTag(10000) as? UILabel
        
        if comment == nil {
        
            comment = UILabel()
            comment?.tag = 10000
            comment?.textColor = Constants.HDMainTextColor
            comment?.numberOfLines = 0
            comment?.font = UIFont.systemFont(ofSize: 14)
            commentView!.addSubview(comment!)
            
            comment?.snp.makeConstraints({ (make) -> Void in
                
                make.top.equalTo(5)
                make.left.equalTo(5)
                make.width.equalTo(Constants.HDSCREENWITH - 110)
                make.height.equalTo(40);
                
            })
            
        }
        
        //评论条数
        var commentCnt = commentView?.viewWithTag(11000) as? UILabel
        
        if commentCnt == nil {
            
            commentCnt = UILabel()
            commentCnt?.tag = 11000
            commentCnt?.textColor = Constants.HDMainTextColor
            commentCnt?.font = UIFont.systemFont(ofSize: 14)
            commentView!.addSubview(commentCnt!)
            
            commentCnt?.snp.makeConstraints({ (make) -> Void in
                
                make.top.equalTo(comment!.snp.bottom).offset(5)
                make.left.equalTo(5)
                make.width.equalTo(Constants.HDSCREENWITH - 110)
                make.height.equalTo(25);
                
            })
            
        }
        
        var spaceView = cell.contentView.viewWithTag(12000)
        
        if spaceView == nil {
        
            spaceView = UIView()
            spaceView?.tag = 12000
            spaceView?.backgroundColor = Constants.HDBGViewColor
            cell.contentView.addSubview(spaceView!)
            spaceView?.snp.makeConstraints({ (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(Constants.HDSpace)
                make.left.equalTo(0)
                make.bottom.equalTo(0)
                
            })
            
        }
        
        let model = dataArray[(indexPath as NSIndexPath).row] as! HDCT10ListModel
        
        name?.text = model.userInfo?.userName
        
        icon?.sd_setImage(with: URL(string: (model.userInfo?.avatar)!), placeholderImage: UIImage(named: "defaultIcon"))
        
        title?.text = model.data?.title
        
        if model.data!.tagName!.characters.count > 0 {
        
            content?.text = String(format: "[%@]%@", model.data!.tagName!,model.data!.content!)
        }else{
            content?.text = String(format: "%@", model.data!.content!)
        }
        
        
        imageView?.sd_setImage(with: URL(string:  (model.data?.img)!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        
        time?.text = model.data?.createTime
        
        
        if model.data!.commentList?.count>0 {
            
            if model.fcommentRow == 1 {
                
                let commentModel:HDCT10CommentListModel = model.data!.commentList![0]
                let commentModel2:HDCT10CommentListModel = model.data!.commentList![1]
                comment?.text = String(format: "%@: %@ \n%@: %@",commentModel.userName!,commentModel.content!,commentModel2.userName!,commentModel2.content!)
                
            }else{
                
                let commentModel:HDCT10CommentListModel = model.data!.commentList![0]
                comment?.text = String(format: "%@: %@",commentModel.userName!,commentModel.content!)
            }
            
            
            //评论数 字体颜色修改
            let str = String(format: "%d", (model.data?.commentCnt)!)
            let comentStr = String(format: "查看全部%d条评论", (model.data?.commentCnt)!)
            let attributed = NSMutableAttributedString(string: comentStr)
            attributed.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, str.characters.count))
            attributed.addAttribute(NSForegroundColorAttributeName, value: Constants.HDYellowColor, range: NSMakeRange(4, str.characters.count))
            commentCnt?.attributedText =  attributed
        
        }else{
        
            commentView?.isHidden = true
        }
        
        
        if model.userInfo?.vip == 1 {
            
            //是vip用户
            vip?.isHidden = false
            vip?.image = UIImage(named: "VIcon")
            
        }else{
            
            vip?.isHidden = true
        }
        
        //0:=女 1:男
        if model.userInfo?.gender == 0 {
            
            sex?.image = UIImage(named: "womanIcon")
        }else{
            
            sex?.image = UIImage(named: "manIcon")
        }
        
        if model.data?.hasVideo == 1 {
        
            //是视频
            playView?.isHidden = false
        }else{
        
            //是图片
            playView?.isHidden = true
        }
        
        content?.snp.updateConstraints({ (make) -> Void in
            
            make.height.equalTo(model.contentHeight!)
        })
        
        imageView?.snp.updateConstraints({ (make) -> Void in
            
            make.top.equalTo(content!.snp.bottom).offset(5)
            
        })

        time?.snp.updateConstraints({ (make) -> Void in
            
            make.top.equalTo(imageView!.snp.bottom).offset(15)
            
        })
        
        commentView?.snp.updateConstraints({ (make) -> Void in
            
            make.top.equalTo(time!.snp.bottom).offset(15)
            
        })

        commentView?.index = (indexPath as NSIndexPath).row
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(HDCT10Controller.commentAction(_:)))
        commentView?.addGestureRecognizer(tapGes)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let model = dataArray[(indexPath as NSIndexPath).row] as! HDCT10ListModel
        
        return model.rowHeight!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
        
        
    }

}


/***




评论
http://api.haodou.com/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&appsign=eba7c612222dde2f1c8c1f98fe48ff78&channel=appstore&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7C65E9FB11-64B3-4B5C-A62C-4B53FD796AC4%7C97F90A81-F659-474D-B27E-BE58CDFF30C0&format=json&loguid=8752979&method=Comment.getList&nonce=1458377630&sessionid=1458376760&signmethod=md5&timestamp=1458377630&uuid=7408f5dd81db1165cd1896e8175a75e4&v=2&vc=46&vn=v6.0.3

limit=10&offset=0&rid=1046273&sign=4864f65f7e5827e7ea50a48bb70f7a2a&type=0&uid=8752979&uuid=7408f5dd81db1165cd1896e8175a75e4


视频地址分析

1.
http://recipe1.hoto.cn/pic/recipe/l/01/f7/1046273_5d6aa3.jpg
http://v.hoto.cn/01/f7/1046273.mp4
2.
http://recipe0.hoto.cn/pic/recipe/l/aa/e6/1042090_ce3b8f.jpg
http://v.hoto.cn/aa/e6/1042090.mp4

3.
http://recipe1.hoto.cn/pic/recipe/l/8f/d8/1038479_e5266c.jpg
http://v.hoto.cn/8f/d8/1038479.mp4
 
4.
http://recipe1.hoto.cn/pic/recipe/l/8b/11/1053067_5717c8.jpg
http://v.hoto.cn/8b/11/1053067.mp4
 
 
HasVideo = 1 为视频

**/
