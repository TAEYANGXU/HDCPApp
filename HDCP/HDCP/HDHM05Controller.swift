//
//  HDHM05Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

private let reuseIdentifier = "myCell"

class HDHM05Controller: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView?

    var cid: Int!
    var name: String?
    var dataArray: NSMutableArray!
    var offset: Int!

    override func viewDidLoad() {


        super.viewDidLoad()

        self.title = name

        offset = 0
        dataArray = NSMutableArray()

        setupUI()
        showHud()

        doGetRequestData(cid, limit: 10, offset: self.offset)
    }


    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CoreUtils.HDBackBarButtonItem(#selector(backAction), taget: self)
    }

    deinit {

        HDLog.LogClassDestory("HDHM05Controller")

    }

    // MARK: - 创建UI视图

    func setupUI() {

        //网格的位置和大小
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: Constants.HDSCREENWITH / 2 - 20, height: Constants.HDSCREENWITH / 2 - 20)


        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.view.addSubview(collectionView!)

        unowned let WS = self;

        collectionView?.snp.makeConstraints( { (make) -> Void in

            make.top.equalTo(WS.view).offset(0)
            make.left.equalTo(WS.view).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.bottom.equalTo(WS.view).offset(0)

        })


        //注册cell
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.collectionView!.backgroundColor = Constants.HDBGViewColor

        //当列表滚动到底端 视图自动刷新
        self.collectionView?.mj_footer = HDRefreshGifFooter(refreshingBlock: { () -> Void in
            WS.doGetRequestData(WS.cid, limit: 10, offset: WS.offset)
        })
        
    }

    // MARK: - 提示动画显示和隐藏
    func showHud() {

        CoreUtils.showProgressHUD(self.view)

    }

    func hidenHud() {

        CoreUtils.hidProgressHUD(self.view)
    }

    // MARK: - 数据加载
    func doGetRequestData(_ cid: Int, limit: Int, offset: Int) {

        unowned let WS = self;
        HDHM05Service().doGetRequest_HDHM05_URL(cid, limit: limit, offset: offset, successBlock: { (hm05Response) -> Void in

            WS.offset = WS.offset + 10

            WS.hidenHud()

            WS.dataArray.addObjects(from: (hm05Response.result?.list)!)

            WS.collectionView!.mj_footer.endRefreshing()

            WS.collectionView!.reloadData()

        }) { (error) -> Void in

            WS.collectionView!.mj_footer.endRefreshing()
            CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
        }

    }

    // MARK: - events

    @objc func backAction() {

        navigationController!.popViewController(animated: true)

    }

    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        var imageView = cell.contentView.viewWithTag(1000) as? UIImageView

        if imageView == nil {

            imageView = UIImageView()
            cell.contentView.addSubview(imageView!)
            imageView?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(cell.contentView).offset(0)
                make.left.equalTo(cell.contentView).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH / 2 - 20)
                make.height.equalTo(Constants.HDSCREENWITH / 2 - 20)

            })

        }

        var title = cell.contentView.viewWithTag(2000) as? UILabel

        if title == nil {

            title = UILabel()
            title?.backgroundColor = CoreUtils.HDColor(105, g: 149, b: 0, a: 0.5)
            title?.textColor = UIColor.white
            title?.font = UIFont.systemFont(ofSize: 15)
            title?.textAlignment = NSTextAlignment.center
            cell.contentView.addSubview(title!)

            title?.snp.makeConstraints( { (make) -> Void in

                make.left.equalTo(cell.contentView).offset(0)
                make.bottom.equalTo(cell.contentView.snp.bottom).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH / 2 - 20)
                make.height.equalTo(20)

            })

        }

        let model = dataArray[(indexPath as NSIndexPath).row] as! HDHM05ListModel
        imageView?.kf.setImage(with: URL(string: model.cover!), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

        title?.text = model.title

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {


        let model = dataArray[(indexPath as NSIndexPath).row] as! HDHM05ListModel
        let hdHM08VC = HDHM08Controller()
        hdHM08VC.rid = model.rid
        hdHM08VC.name = model.title
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(hdHM08VC, animated: true)
    }

}
