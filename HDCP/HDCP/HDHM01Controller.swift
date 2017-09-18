//
//  HDHM01ViewController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

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


private let HeadViewHeight: CGFloat = 200.0

private let TagHeight: Int = 40

/**
*  resource/数据源
*/
private let resourceArray = [["title": "排行榜", "image": "HPHBIcon"],
   ["title": "营养餐桌", "image": "HYYCZIcon"],
   ["title": "热门分类", "image": "HFBCPIcon"],
   ["title": "晒一晒", "image": "HSYSIcon"]]

class HDHM01Controller: BaseViewController, UIScrollViewDelegate {

   fileprivate enum HDHM01MenuTag: Int {
      case phb = 0, yycz, fbcp, sys
   }

   var baseView: UIScrollView!

   /**
     
     *  数据请求结果集
     */
   var hdHM01Response: HDHM01Response?

   /**
     *  头部滚动视图
     */
   var headView: UIView!
   var headerSView: UIScrollView!

   /**
     *  分页栏
     */
   var pageControl: UIPageControl!
   var headerTitle: UILabel!

   /**
     *  标签栏
     */
   var menuView: UIView!

   var tagListView: UIView!

   /**
     *  菜谱专辑
     */
   var collectListView: UIView!

   /**
     *  厨房宝典
     */
   var wikiListView: UIView!


   /**
     *   UIImageView重用
     */
   var index: Int?
   var centerImageView: UIImageView?
   var leftImageView: UIImageView?
   var rightImageView: UIImageView?

   /**
    * 网络变化
    */
   var netStatusView: UILabel?

   override func viewDidLoad() {

      super.viewDidLoad()

      self.edgesForExtendedLayout = UIRectEdge();
      self.navigationController?.navigationBar.isTranslucent = false

      //双击TabItem通知
      NotificationCenter.default.addObserver(self, selector: #selector(hm01Notification(_:)), name: NSNotification.Name(rawValue: Constants.HDREFRESHHDHM01), object: nil)

      if HDHM01Service().isExistEntity() {

         /**
            *  读取本地数据
            */
         self.hdHM01Response = HDHM01Service().getAllResponseEntity()
         setupUI()
         doGetRequestData()

      } else {

         if CoreUtils.networkIsReachable() {

            showHud()
            doGetRequestData()

         }

      }

   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

   }

   override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      hidenHud()
   }

   override func viewDidLayoutSubviews() {

      super.viewDidLayoutSubviews()
      
      if self.hdHM01Response?.result?.tagList?.count > 0 {
         let height: Int = (self.hdHM01Response?.result?.tagList?.count)! / 4 * TagHeight
         baseView.contentSize = CGSize(width: Constants.HDSCREENWITH, height: HeadViewHeight + Constants.HDSCREENWITH / 4 + 5 + CGFloat(height) + 300 + 300 + CGFloat(Constants.HDSpace * 4))
      }

   }

   deinit {

      baseView.delegate = nil
      HDLog.LogClassDestory("HDHM01Controller" as AnyObject)
   }

   // MARK: - 创建UI视图

   func setupUI() {

      createBaseView()

      createHeaderView()

      createMenuView()

      createTagListView()

      createCollectListView()

      createWikiListView()

      createNetStatusView()

   }

   func createNetStatusView() {

      if netStatusView == nil {

         netStatusView = UILabel()
         netStatusView?.backgroundColor = UIColor(red: 0.88, green: 0.27, blue: 0.28, alpha: 0.8)
         netStatusView?.textColor = UIColor.white
         netStatusView?.text = "当前网络不可以，请检查网络设置"
         netStatusView?.font = UIFont.systemFont(ofSize: 15)
         netStatusView?.textAlignment = NSTextAlignment.center
         netStatusView?.isHidden = true
         self.view.addSubview(netStatusView!)

         netStatusView?.snp.makeConstraints( { (make) in

            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(40);

         })

      }

   }

   /**
     *  创建滚动容器
     */
   func createBaseView() {

      unowned let WS = self;

      if baseView == nil {

         baseView = UIScrollView()

         self.view.addSubview(baseView)

         baseView.snp.makeConstraints { (make) -> Void in

            make.top.equalTo(WS.view).offset(0)
            make.left.equalTo(WS.view).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.bottom.equalTo(WS.view).offset(0)
         }
         //兼容IOS11
         if #available(iOS 11.0, *) {
            baseView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never;
         }
         /**
            *  添加下拉刷新
            */

         baseView.mj_header = HDRefreshGifHeader(refreshingBlock: { () -> Void in

            WS.doGetRequestData()


         })
         
      }

   }

   /**
     *  创建头部滚动视图
     */
   func createHeaderView() {


      /**
        *  创建容器
        */

      if headView == nil {

         headView = UIView()
         baseView.addSubview(headView)

         headView.snp.makeConstraints( { (make) -> Void in

            make.top.equalTo(baseView).offset(0)
            make.left.equalTo(baseView).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(HeadViewHeight)

         })

      }


      if (self.hdHM01Response?.result?.recipeList?.count)! >= 0 {

         if headerSView == nil {

            headerSView = UIScrollView()
            headerSView.isPagingEnabled = true
            headerSView.isUserInteractionEnabled = true;
            headerSView.delegate = self;
            headerSView.bounces = false
            headerSView.showsVerticalScrollIndicator = false;
            headerSView.showsHorizontalScrollIndicator = false;
            headView.addSubview(headerSView)

            headerSView.snp.makeConstraints( { (make) -> Void in

               make.top.equalTo(headView).offset(0)
               make.left.equalTo(headView).offset(0)
               make.width.equalTo(Constants.HDSCREENWITH)
               make.height.equalTo(HeadViewHeight)


            })
         }

         headerSView?.contentSize = CGSize(width: CGFloat(3) * Constants.HDSCREENWITH, height: HeadViewHeight)
         headerSView!.contentOffset = CGPoint(x: Constants.HDSCREENWITH, y: 0)


         centerImageView = UIImageView(frame: CGRect(x: Constants.HDSCREENWITH, y: 0, width: Constants.HDSCREENWITH, height: HeadViewHeight))
         centerImageView!.contentMode = UIViewContentMode.scaleToFill;
         centerImageView?.isUserInteractionEnabled = true
         headerSView?.addSubview(centerImageView!)
         let ctapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headGesAction(_:)))
         centerImageView?.addGestureRecognizer(ctapGes)
         centerImageView!.kf.setImage(with: URL(string: "http://img1.hoto.cn/haodou/recipev4/wiki/1d5ff0c46.jpg"), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

         leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.HDSCREENWITH, height: HeadViewHeight))
         leftImageView!.contentMode = UIViewContentMode.scaleToFill;
         leftImageView?.isUserInteractionEnabled = true
         headerSView?.addSubview(leftImageView!)
         let ltapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headGesAction(_:)))
         centerImageView?.addGestureRecognizer(ltapGes)
         leftImageView!.kf.setImage(with: URL(string: "http://img1.hoto.cn/haodou/recipev4/wiki/1d5ff0c46.jpg"), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)
         
         rightImageView = UIImageView(frame: CGRect(x: Constants.HDSCREENWITH * 2, y: 0, width: Constants.HDSCREENWITH, height: HeadViewHeight))
         rightImageView!.contentMode = UIViewContentMode.scaleToFill;
         rightImageView?.isUserInteractionEnabled = true
         headerSView?.addSubview(rightImageView!)
         let rtapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headGesAction(_:)))
         centerImageView?.addGestureRecognizer(rtapGes)
         rightImageView!.kf.setImage(with: URL(string: "http://img1.hoto.cn/haodou/recipev4/wiki/1d5ff0c46.jpg"), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

         /**
            *  分页栏
            */

         if pageControl == nil {

            pageControl = UIPageControl()
            pageControl?.addTarget(self, action: #selector(pageAction(_:)), for: UIControlEvents.touchUpInside)
            pageControl?.numberOfPages = 3;
            pageControl?.currentPage = 0;
            pageControl?.pageIndicatorTintColor = Constants.HDMainColor
            headView.addSubview(pageControl!)

            pageControl.snp.makeConstraints( { (make) -> Void in

               make.bottom.equalTo(0)
               make.right.equalTo(0)
               make.width.equalTo(100)
               make.height.equalTo(40)

            })

         }



         /**
            *  菜粕名称
            */

         if headerTitle == nil {

            headerTitle = UILabel()
            headerTitle.font = UIFont.systemFont(ofSize: 18)
            headerTitle.textColor = Constants.HDMainColor
            headView.addSubview(headerTitle)

            headerTitle.snp.makeConstraints( { (make) -> Void in

               make.bottom.equalTo(0)
               make.left.equalTo(20)
               make.width.equalTo(Constants.HDSCREENWITH - 150)
               make.height.equalTo(40)

            })


         }


         index = 0;
//         setInfoByCurrentImageIndex(index!)

      }

   }

   /**
     *  标签
     */
   func createMenuView() {


      if menuView == nil {

         menuView = UIView()
         menuView.backgroundColor = UIColor.white
         baseView.addSubview(menuView)

         menuView.snp.makeConstraints { (make) -> Void in

            make.top.equalTo(headView.snp.bottom).offset(0)
            make.left.equalTo(baseView).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(Constants.HDSCREENWITH / 4 + 5)

         }

      }


      for i in 0 ..< resourceArray.count {

         var btn: HDHM01Button?

         btn = menuView.viewWithTag(i + 300) as? HDHM01Button

         if btn == nil {

            btn = HDHM01Button()
            btn!.tag = i + 300
            btn!.setImage(UIImage(named: resourceArray[i]["image"]!), for: UIControlState())
            btn!.setTitle(resourceArray[i]["title"]!, for: UIControlState())
            btn!.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn!.titleLabel?.textAlignment = NSTextAlignment.center
            btn!.setTitleColor(Constants.HDMainTextColor, for: UIControlState.normal)
            btn!.addTarget(self, action: #selector(menuBtnOnclick(_:)), for: UIControlEvents.touchUpInside)
            menuView.addSubview(btn!)

            btn!.snp.makeConstraints { (make) -> Void in

               make.left.equalTo(menuView).offset(CGFloat(i) * Constants.HDSCREENWITH / 4)
               make.top.equalTo(menuView).offset(0)
               make.width.equalTo(Constants.HDSCREENWITH / 4)
               make.height.equalTo(Constants.HDSCREENWITH / 4)

            }

         }

      }

   }


   /**
     *  按钮
     */
   func createTagListView() {

      if tagListView == nil {

         tagListView = UIView()
         tagListView.backgroundColor = UIColor.white
         baseView.addSubview(tagListView)

         tagListView.snp.makeConstraints { (make) -> Void in

            make.top.equalTo(menuView.snp.bottom).offset(Constants.HDSpace)
            make.left.equalTo(baseView).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo((self.hdHM01Response?.result?.tagList?.count)! / 4 * TagHeight)

         }

      }

      /**
         *  几行4列
         */

      var index = 0
      for i in 0 ..< (self.hdHM01Response?.result?.tagList?.count)! / 4 {

         for j in 0 ..< 4 {

            let model: TagListModel = (self.hdHM01Response?.result?.tagList![index])!

            var btn: UIButton?

            btn = tagListView.viewWithTag(index) as? UIButton

            if btn == nil {

               btn = UIButton()
               btn!.backgroundColor = UIColor.white
               btn!.setTitleColor(Constants.HDMainTextColor, for: UIControlState.normal)
               btn!.tag = index + 1000;
               btn!.titleLabel?.font = UIFont.systemFont(ofSize: 15)
               btn!.setTitle(model.name, for: UIControlState())
               btn!.layer.borderWidth = 0.5
               btn!.layer.borderColor = Constants.HDBGViewColor.cgColor
               btn!.addTarget(self, action: #selector(tagBtnOnclick(_:)), for: UIControlEvents.touchUpInside)
               tagListView.addSubview(btn!)

               btn!.snp.makeConstraints( { (make) -> Void in

                  make.width.equalTo(Constants.HDSCREENWITH / 4)
                  make.height.equalTo(TagHeight)
                  make.left.equalTo(CGFloat(j) * Constants.HDSCREENWITH / 4)
                  make.top.equalTo(i * TagHeight)

               })

            }

            index += 1;
         }

      }

   }

   /**
     *  菜谱专辑
     */
   func createCollectListView() {


      if collectListView == nil {

         collectListView = UIView()
         collectListView.backgroundColor = UIColor.white
         baseView.addSubview(collectListView)

         collectListView.snp.makeConstraints { (make) -> Void in

            make.top.equalTo(tagListView.snp.bottom).offset(Constants.HDSpace)
            make.left.equalTo(baseView).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(300)

         }

         let title = UILabel()
         title.backgroundColor = UIColor.clear
         title.textColor = Constants.HDMainColor
         title.text = "菜谱专辑"
         collectListView.addSubview(title)

         title.snp.makeConstraints { (make) -> Void in

            make.left.equalTo(collectListView).offset(16)
            make.top.equalTo(collectListView).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH - 16)
            make.height.equalTo(40)

         }


         let line = UILabel()
         line.backgroundColor = Constants.HDBGViewColor
         collectListView.addSubview(line)

         line.snp.makeConstraints { (make) -> Void in


            make.left.equalTo(collectListView).offset(16)
            make.top.equalTo(collectListView).offset(260)
            make.width.equalTo(Constants.HDSCREENWITH - 16)
            make.height.equalTo(1)

         }

         let collectmore = UILabel()
         collectmore.backgroundColor = UIColor.clear
         collectmore.textColor = Constants.HDMainTextColor
         collectmore.font = UIFont.systemFont(ofSize: 16)
         collectmore.text = "查看全部菜谱"
         collectListView.addSubview(collectmore)

         collectmore.snp.makeConstraints { (make) -> Void in

            make.left.equalTo(collectListView).offset(16)
            make.top.equalTo(line).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH - 16)
            make.height.equalTo(40)

         }

         let moreArrow = UIImageView()
         moreArrow.image = UIImage(named: "moreArrowIcon")
         collectListView.addSubview(moreArrow)
         moreArrow.snp.makeConstraints( { (make) -> Void in

            make.right.equalTo(collectListView).offset(-16)
            make.top.equalTo(line).offset(10)
            make.width.equalTo(20)
            make.height.equalTo(20)

         })

         //添加点击Button
         let onclickBtn = UIButton()
         onclickBtn.tag = 10000
         onclickBtn.backgroundColor = UIColor.clear
         collectListView.addSubview(onclickBtn)
         onclickBtn.addTarget(self, action: #selector(moreAction(_:)), for: UIControlEvents.touchUpInside)

         onclickBtn.snp.makeConstraints( { (make) -> Void in

            make.left.equalTo(collectListView).offset(0)
            make.top.equalTo(line).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(40)

         })


      }

      for i in 0 ..< (self.hdHM01Response?.result?.collectList?.count)! {

         let model = self.hdHM01Response?.result?.collectList?[i]

         var rowView: HDHM01RowView?
         rowView = collectListView.viewWithTag(i + 100) as? HDHM01RowView

         if rowView == nil {

            rowView = HDHM01RowView()
            rowView!.tag = i + 100;
            collectListView.addSubview(rowView!)

            let collectGes = UITapGestureRecognizer(target: self, action: #selector(collectGesAction(_:)))
            rowView!.addGestureRecognizer(collectGes)

            rowView!.title.text = model?.title
            rowView?.title.textColor = Constants.HDMainTextColor
            rowView!.userName.text = String(format: "by %@", (model?.userName)!)
            rowView!.detail.text = model?.content

            rowView!.snp.makeConstraints { (make) -> Void in

               make.left.equalTo(collectListView).offset(16)
               make.top.equalTo(collectListView).offset(i * 110 + 40)
               make.width.equalTo(Constants.HDSCREENWITH - 36)
               make.height.equalTo(100)
            }


         }

         rowView!.imageView.kf.setImage(with: URL(string: model!.cover!), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

      }

   }

   /**
     *  厨房宝典
     */
   func createWikiListView() {

      if wikiListView == nil {

         wikiListView = UIView()
         wikiListView.backgroundColor = UIColor.white
         baseView.addSubview(wikiListView)

         wikiListView.snp.makeConstraints { (make) -> Void in

            make.top.equalTo(collectListView.snp.bottom).offset(Constants.HDSpace)
            make.left.equalTo(baseView).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(300)

         }

         let title = UILabel()
         title.backgroundColor = UIColor.clear
         title.textColor = Constants.HDMainColor
         title.text = "厨房宝典"
         wikiListView.addSubview(title)

         title.snp.makeConstraints { (make) -> Void in

            make.left.equalTo(wikiListView).offset(16)
            make.top.equalTo(wikiListView).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH - 16)
            make.height.equalTo(40)

         }

         let line = UILabel()
         line.backgroundColor = Constants.HDBGViewColor
         wikiListView.addSubview(line)

         line.snp.makeConstraints { (make) -> Void in


            make.left.equalTo(wikiListView).offset(16)
            make.top.equalTo(wikiListView).offset(260)
            make.width.equalTo(Constants.HDSCREENWITH - 16)
            make.height.equalTo(1)

         }


         let wikimore = UILabel()
         wikimore.backgroundColor = UIColor.clear
         wikimore.textColor = Constants.HDMainTextColor
         wikimore.font = UIFont.systemFont(ofSize: 16)
         wikimore.text = "查看全部宝典"
         wikiListView.addSubview(wikimore)

         wikimore.snp.makeConstraints { (make) -> Void in

            make.left.equalTo(wikiListView).offset(16)
            make.top.equalTo(line).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH - 16)
            make.height.equalTo(40)

         }

         let moreArrow = UIImageView()
         moreArrow.image = UIImage(named: "moreArrowIcon")
         wikiListView.addSubview(moreArrow)
         moreArrow.snp.makeConstraints( { (make) -> Void in

            make.right.equalTo(collectListView).offset(-16)
            make.top.equalTo(line).offset(10)
            make.width.equalTo(20)
            make.height.equalTo(20)

         })

         //添加点击Button
         let onclickBtn = UIButton()
         onclickBtn.tag = 20000
         onclickBtn.backgroundColor = UIColor.clear
         wikiListView.addSubview(onclickBtn)
         onclickBtn.addTarget(self, action: #selector(moreAction(_:)), for: UIControlEvents.touchUpInside)

         onclickBtn.snp.makeConstraints( { (make) -> Void in

            make.left.equalTo(collectListView).offset(0)
            make.top.equalTo(line).offset(0)
            make.width.equalTo(Constants.HDSCREENWITH)
            make.height.equalTo(40)

         })

      }


      for i in 0 ..< (self.hdHM01Response?.result?.wikiList?.count)! {

         let model = self.hdHM01Response?.result?.wikiList?[i]

         var rowView: HDHM01RowView?
         rowView = wikiListView.viewWithTag(i + 100) as? HDHM01RowView

         if rowView == nil {

            rowView = HDHM01RowView()
            rowView!.tag = i + 100;
            wikiListView.addSubview(rowView!)

            let wikiGes = UITapGestureRecognizer(target: self, action: #selector(wikiGesAction(_:)))
            rowView!.addGestureRecognizer(wikiGes)

            rowView!.title.text = model?.title
            rowView!.title.textColor = Constants.HDMainTextColor

            if model?.userName != nil {
               rowView!.userName.text = String(format: "by %@", (model?.userName)!)
            }

            rowView!.detail.text = model?.content

            rowView!.snp.makeConstraints { (make) -> Void in

               make.left.equalTo(wikiListView).offset(16)
               make.top.equalTo(wikiListView).offset(i * 110 + 40)
               make.width.equalTo(Constants.HDSCREENWITH - 36)
               make.height.equalTo(100)
            }

         }

         rowView!.imageView.kf.setImage(with: URL(string: model!.cover!), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)
      }

   }
   // MARK: - 通知事件

   func hm01Notification(_ noti: Notification) {

      let flag = (noti as NSNotification).userInfo!["FLAG"] as? String

      if flag == Constants.HDREFRESHHDHM01 {

         /**
         *  开始刷新 获取最新数据
         */
         self.baseView.mj_header.beginRefreshing()

      }

      if flag == "NETCHANGE" {

         self.showNetView()

         self.perform(#selector(hideNetView), with: self, afterDelay: 2.5)

      }

   }

   // MARK: - 图片循环滚动
   func loadImage() {


//      if headerSView!.contentOffset.x > Constants.HDSCREENWITH {
//
//         //向左滑动
//         index = (index! + 1 + (self.hdHM01Response?.result?.recipeList?.count)!) % (self.hdHM01Response?.result?.recipeList?.count)!
//
//      } else if headerSView!.contentOffset.x < Constants.HDSCREENWITH {
//
//         //向右滑动
//         index = (index! - 1 + (self.hdHM01Response?.result?.recipeList?.count)!) % (self.hdHM01Response?.result?.recipeList?.count)!
//      }

//      setInfoByCurrentImageIndex(index!)


   }

   func setInfoByCurrentImageIndex(_ index: Int) {

      let cmodel = self.hdHM01Response?.result?.recipeList?[index]

      /// 文本信息
      pageControl?.currentPage = index
      /**
        *  更新菜谱名称
        */
      headerTitle.text = cmodel!.title

      centerImageView!.kf.setImage(with: URL(string: "http://img1.hoto.cn/haodou/recipev4/wiki/1d5ff0c46.jpg"), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

//      let lmodel = self.hdHM01Response?.result?.recipeList![((index - 1) + (self.hdHM01Response?.result?.recipeList?.count)!) % (self.hdHM01Response?.result?.recipeList?.count)!]

      leftImageView!.kf.setImage(with: URL(string: "http://img1.hoto.cn/haodou/recipev4/wiki/1d5ff0c46.jpg"), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

//      let rmodel = self.hdHM01Response?.result?.recipeList![((index + 1) + (self.hdHM01Response?.result?.recipeList?.count)!) % (self.hdHM01Response?.result?.recipeList?.count)!]

      rightImageView!.kf.setImage(with: URL(string: "http://img1.hoto.cn/haodou/recipev4/wiki/1d5ff0c46.jpg"), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

   }

   // MARK: - 提示动画显示和隐藏
   func showHud() {

      CoreUtils.showProgressHUD(self.view)

   }

   func hidenHud() {

      CoreUtils.hidProgressHUD(self.view)
   }

   func showNetView() {

      netStatusView?.isHidden = false

   }
   func hideNetView() {

      netStatusView?.isHidden = true
   }

   // MARK: - 数据加载

   func doGetRequestData() {

      unowned let WS = self;
      HDHM01Service().doGetRequest_HDHM01_URL({ (hdResponse) -> Void in

         WS.hidenHud()

         WS.hdHM01Response = hdResponse

         /**
            *  刷新UI
            */
         WS.setupUI()

         /**
            *  结束刷新
            */
         WS.baseView.mj_header.endRefreshing()

      }) { (error) -> Void in

         /**
                *  结束刷新
                */
         if (WS.baseView != nil) {

            WS.baseView.mj_header.endRefreshing()

         }


         CoreUtils.showWarningHUD(WS.view, title: Constants.HD_NO_NET_MSG)
      }


   }

   // MARK: - events

   /**
    *   菜谱列表
    */
   func collectGesAction(_ ges: UITapGestureRecognizer) {

      let view = ges.view as! HDHM01RowView
      let model = self.hdHM01Response?.result?.collectList?[view.tag - 100]

      let hdhm05VC = HDHM05Controller()
      hdhm05VC.name = model?.title
      hdhm05VC.cid = model?.cid
      self.hidesBottomBarWhenPushed = true;
      self.navigationController?.pushViewController(hdhm05VC, animated: true)
      self.hidesBottomBarWhenPushed = false;

   }


   /**
     *   厨房宝典详情
     */
   func wikiGesAction(_ ges: UITapGestureRecognizer) {

      let view = ges.view as! HDHM01RowView
      let model = self.hdHM01Response?.result?.wikiList?[view.tag - 100]

      let hdWebVC = HDWebController()
      self.hidesBottomBarWhenPushed = true;
      hdWebVC.name = model!.title
      hdWebVC.url = model!.url
      self.navigationController?.pushViewController(hdWebVC, animated: true)
      self.hidesBottomBarWhenPushed = false;

   }

   /**
     *   菜谱详情
     */
   func headGesAction(_ ges: UITapGestureRecognizer) {
      
      return
      let recopeMddel: RecipeListModel = (self.hdHM01Response?.result?.recipeList![index!])!
      let hdHM08VC = HDHM08Controller()
      hdHM08VC.rid = recopeMddel.rid
      hdHM08VC.name = recopeMddel.title
      self.hidesBottomBarWhenPushed = true;
      self.navigationController?.pushViewController(hdHM08VC, animated: true)
      self.hidesBottomBarWhenPushed = false;

   }

   func menuBtnOnclick(_ btn: UIButton) {

      let tag: Int = btn.tag - 300
      switch tag {

      case 0:
         /**
            *   排行榜
            */

         let hdHM02VC = HDHM02Controller()
         self.hidesBottomBarWhenPushed = true;
         self.navigationController?.pushViewController(hdHM02VC, animated: true)
         self.hidesBottomBarWhenPushed = false;
         HDLog.LogOut("排行榜")
         break
      case 1:
         /**
            *   营养餐桌
            */

         let hdHM03VC = HDHM03Controller()
         self.hidesBottomBarWhenPushed = true;
         self.navigationController?.pushViewController(hdHM03VC, animated: true)
         self.hidesBottomBarWhenPushed = false;
         HDLog.LogOut("营养餐桌")
         break

      case 2:
         /**
            *  热门分类
            */

         let hdcg02VC = HDCG02Controller()
         hdcg02VC.name = "热门分类"
         self.hidesBottomBarWhenPushed = true;
         self.navigationController?.pushViewController(hdcg02VC, animated: true)
         self.hidesBottomBarWhenPushed = false;
         HDLog.LogOut("热门分类")
         break

      case 3:
         /**
            *   晒一晒
            */
         HDLog.LogOut("晒一晒")
         break
      default:
         break
      }


   }

   //更多

   func moreAction(_ btn: UIButton) {

      switch(btn.tag) {

      case 10000:

         let hdHM06VC = HDHM06Controller()
         self.hidesBottomBarWhenPushed = true;
         self.navigationController?.pushViewController(hdHM06VC, animated: true)
         self.hidesBottomBarWhenPushed = false;
         HDLog.LogOut("全部菜谱"as AnyObject)
         break
      case 20000:

         let hdHM07VC = HDHM07Controller()
         self.hidesBottomBarWhenPushed = true;
         self.navigationController?.pushViewController(hdHM07VC, animated: true)
         self.hidesBottomBarWhenPushed = false;
         HDLog.LogOut("全部宝典" as AnyObject)
         break
      default:
         break
      }

   }

   //分类
   func tagBtnOnclick(_ btn: UIButton) {

      let model: TagListModel = (self.hdHM01Response?.result?.tagList![btn.tag - 1000])!
      let hdHM04VC = HDHM04Controller()
      hdHM04VC.tagModel = model;
      self.hidesBottomBarWhenPushed = true;
      self.navigationController?.pushViewController(hdHM04VC, animated: true)
      self.hidesBottomBarWhenPushed = false;

   }

   func pageAction(_ sender: AnyObject) {


      headerSView!.contentOffset = CGPoint(x: Constants.HDSCREENWITH, y: 0)
      index = pageControl?.currentPage
      loadImage()
   }

   // MARK: - UIScrollView delegate
   func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

      loadImage()
      headerSView!.contentOffset = CGPoint(x: Constants.HDSCREENWITH, y: 0)

      //        pageControl?.currentPage = index
   }

}
