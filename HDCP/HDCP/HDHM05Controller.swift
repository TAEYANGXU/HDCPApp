//
//  HDHM05Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let reuseIdentifier = "myCell"

class HDHM05Controller: BaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource{

    var collectionView:UICollectionView?
    
    var cid:Int!
    var name:String?
    var dataArray:NSMutableArray!
    var offset:Int!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        self.title = name
        
        offset = 0
        dataArray  = NSMutableArray()
        
        setupUI()
        showHud()
        
        doGetRequestData(cid,limit: 20,offset: self.offset)
        
        print("\(name)     \(cid!)")
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem("backAction", taget: self)
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        //网格的位置和大小
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.itemSize = CGSize(width: Constants.HDSCREENWITH/2-20, height: Constants.HDSCREENWITH/2-20)
        
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.view.addSubview(collectionView!)
        
        collectionView?.snp_makeConstraints(closure: { (make) -> Void in
            
            make.top.equalTo(self.view).offset(0)
            make.left.equalTo(self.view).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.bottom.equalTo(self.view).offset(0)
            
        })
        
        
        //注册cell
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.backgroundColor = Constants.HDBGViewColor
        
        //当列表滚动到底端 视图自动刷新
        self.collectionView?.mj_footer = HDRefreshGifFooter(refreshingBlock: { () -> Void in
            self.doGetRequestData(self.cid,limit: 10,offset: self.offset)
        })
        
    }
    
    // MARK: - 提示动画显示和隐藏
    func showHud(){
        
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
        
        CoreUtils.hidProgressHUD(self.view)
    }
    
    // MARK: - 数据加载
    func doGetRequestData(cid:Int,limit:Int,offset:Int){
        
        HDHM05Service().doGetRequest_HDHM05_URL(cid, limit: limit, offset: offset, successBlock: { (hm05Response) -> Void in
            
            self.offset = self.offset+1
            
            self.hidenHud()
            
            self.dataArray.addObjectsFromArray((hm05Response.result?.list)!)
            
            self.collectionView!.mj_footer.endRefreshing()
            
            self.collectionView!.reloadData()
            
            }) { (error) -> Void in
                
                self.collectionView!.mj_footer.endRefreshing()
                CoreUtils.showProgressHUD(self.view, title: Constants.HD_NO_NET_MSG)
        }
        
    }
    
    // MARK: - events
    
    func backAction(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    // MARK: UICollectionViewDataSource
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    
        return 1
    }


     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArray.count
    }

     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        var imageView = cell.contentView.viewWithTag(1000) as?  UIImageView
        
        if imageView == nil {
        
            imageView = UIImageView()
            cell.contentView.addSubview(imageView!)
            imageView?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(cell.contentView).offset(0)
                make.left.equalTo(cell.contentView).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH/2-20)
                make.height.equalTo(Constants.HDSCREENWITH/2-20)
                
            })
            
        }
        
        var title = cell.contentView.viewWithTag(2000) as?  UILabel
        
        if title == nil {
            
            title = UILabel()
            title?.backgroundColor = Constants.HDColor(105, g: 149, b: 0, a: 0.5)
            title?.textColor = UIColor.whiteColor()
            title?.font = UIFont.systemFontOfSize(15)
            title?.textAlignment = NSTextAlignment.Center
            cell.contentView.addSubview(title!)
            
            title?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.left.equalTo(cell.contentView).offset(0)
                make.bottom.equalTo(cell.contentView.snp_bottom).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH/2-20)
                make.height.equalTo(20)
                
            })
            
        }
        
        let model = dataArray[indexPath.row] as! HDHM05ListModel
        
        imageView?.sd_setImageWithURL(NSURL(string: model.cover!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        title?.text = model.title
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        let model = dataArray[indexPath.row] as! HDHM05ListModel
        let hdHM08VC = HDHM08Controller()
        hdHM08VC.rid = model.rid
        hdHM08VC.name = model.title
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdHM08VC, animated: true)
    }

}
