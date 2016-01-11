//
//  HDHM01ViewController.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/4.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SnapKit

let HeadViewHeight:CGFloat = 200.0

let TagHeight:Int = 40

class HDHM01Controller: BaseViewController,UIScrollViewDelegate {
    
    enum HDHM01MenuTag: Int {
        case PHB, YYCZ, FBCP, SYS
    }

    let resourceArray = [["title":"排行榜","image":"PHBIcon"],
        ["title":"营养餐桌","image":"HYYCZIcon"],
        ["title":"发布菜谱","image":"FBCPIcon"],
        ["title":"晒一晒","image":"SYSIcon"]]
    
    var baseView:UIScrollView!
    var hdHM01Response:HDHM01Response?
    
    var headView:UIView!
    var headerSView:UIScrollView!
    var pageControl:UIPageControl!
    var headerTitle:UILabel!
    
    var menuView:UIView!
    
    var tagListView:UIView!
    
    /// 菜谱专辑
    var collectListView:UIView!
    
    /// 厨房宝典
    var wikiListView:UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        self.edgesForExtendedLayout = UIRectEdge.None;
        self.navigationController?.navigationBar.translucent = false
        
        showHud()
        doGetRequestData()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if self.hdHM01Response?.result?.tagList?.count>0 {
            let height:Int = (self.hdHM01Response?.result?.tagList?.count)!/4*TagHeight
            baseView.contentSize = CGSizeMake(Constants.kSCREENWITH, HeadViewHeight+Constants.kSCREENWITH/4+5+CGFloat(height)+300+300+CGFloat(Constants.HDSpace*4))
        }
        
        
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        if baseView == nil {
        
            baseView = UIScrollView()
            
            self.view.addSubview(baseView)
            
            baseView.snp_makeConstraints { (make) -> Void in
                
                make.top.equalTo(self.view).offset(0)
                make.left.equalTo(self.view).offset(0)
                make.width.equalTo(Constants.kSCREENWITH)
                make.bottom.equalTo(self.view).offset(0)
            }
            
            createHeaderView()
            
            createMenuView()
            
            createTagListView()
            
            createCollectListView()
            
            createWikiListView()
            
            baseView.mj_header = HDRefreshGifHeader(refreshingBlock: { () -> Void in
                
                self.doGetRequestData()
                
                
            })
        }
 
    }
    
    /**
     *  创建头部滚动视图
     */
    func createHeaderView(){
    
        
        
        if self.hdHM01Response?.result?.recipeList?.count > 0 {
            
            /**
            *  创建容器
            */
            
            if headView == nil {
            
                headView = UIView()
                baseView.addSubview(headView)
                
                headView.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.top.equalTo(baseView).offset(0)
                    make.left.equalTo(baseView).offset(0)
                    make.width.equalTo(Constants.kSCREENWITH)
                    make.height.equalTo(HeadViewHeight)
                    
                })
                
            }
            
            if headerSView == nil {
            
                headerSView = UIScrollView()
                headerSView.pagingEnabled = true
                headerSView.userInteractionEnabled = true;
                headerSView.delegate = self;
                headerSView.showsVerticalScrollIndicator = false;
                headerSView.showsHorizontalScrollIndicator = false;
                headView.addSubview(headerSView)
                
                headerSView.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.top.equalTo(headView).offset(0)
                    make.left.equalTo(headView).offset(0)
                    make.width.equalTo(Constants.kSCREENWITH)
                    make.height.equalTo(HeadViewHeight)
                    
                    
                })
            }
            
            headerSView.contentSize = CGSizeMake(Constants.kSCREENWITH*CGFloat((self.hdHM01Response?.result?.recipeList?.count)!), HeadViewHeight)
            
            
            /**
            *  显示图片
            */
            for var i=0;i<self.hdHM01Response?.result?.recipeList?.count;i++ {
                
                let recopeMddel:RecipeListModel = (self.hdHM01Response?.result?.recipeList![i])!
                
                var imageView:UIImageView?
                
                imageView = headerSView.viewWithTag(i+200) as? UIImageView
                
                if imageView == nil {
                
                    imageView = UIImageView()
                    imageView!.tag = i+200
                    headerSView.addSubview(imageView!)
                    imageView!.snp_makeConstraints(closure: { (make) -> Void in
                        
                        make.top.equalTo(headerSView).offset(0)
                        make.left.equalTo(headerSView).offset(Constants.kSCREENWITH*CGFloat(i))
                        make.width.equalTo(Constants.kSCREENWITH)
                        make.height.equalTo(HeadViewHeight)
                    })
                    
                }
                
                imageView!.sd_setImageWithURL(NSURL(string: recopeMddel.cover!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
                
            }
            
            /**
            *  分页栏
            */
            
            if pageControl == nil {
            
                pageControl = UIPageControl()
                pageControl?.addTarget(self, action: "pageAction:", forControlEvents: UIControlEvents.TouchUpInside)
                pageControl?.numberOfPages = 3;
                pageControl?.currentPage = 0;
                pageControl?.pageIndicatorTintColor = Constants.HDMainColor
                headView.addSubview(pageControl!)
                
                pageControl.snp_makeConstraints(closure: { (make) -> Void in
                    
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
                headerTitle.font = UIFont.systemFontOfSize(18)
                headerTitle.textColor = Constants.HDMainColor
                headView.addSubview(headerTitle)
                
                headerTitle.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.bottom.equalTo(0)
                    make.left.equalTo(20)
                    make.width.equalTo(Constants.kSCREENWITH-150)
                    make.height.equalTo(40)
                    
                })

                
            }
            
            
            /**
             *  默认初始给第一个的名称
             */
            let recopeMddel:RecipeListModel = (self.hdHM01Response?.result?.recipeList![0])!
            headerTitle.text = recopeMddel.title
            
        }
        
    }
    
    func createMenuView(){
        
        
        if menuView == nil {
        
            menuView = UIView()
            menuView.backgroundColor = UIColor.whiteColor()
            baseView.addSubview(menuView)
            
            menuView.snp_makeConstraints { (make) -> Void in
                
                make.top.equalTo(headView.snp_bottom).offset(0)
                make.left.equalTo(baseView).offset(0)
                make.width.equalTo(Constants.kSCREENWITH)
                make.height.equalTo(Constants.kSCREENWITH/4+5)
                
            }
            
        }
        
        
        for  var i=0;i<resourceArray.count;i++ {
        
            
            var btn:HDHM01Button?
            
            btn = menuView.viewWithTag(i+300) as? HDHM01Button
            
            if btn == nil {
            
                btn = HDHM01Button()
                btn!.tag = i+300
                btn!.setImage(UIImage(named: resourceArray[i]["image"]!), forState: UIControlState.Normal)
                btn!.setTitle(resourceArray[i]["title"]!, forState: UIControlState.Normal)
                btn!.titleLabel?.font = UIFont.systemFontOfSize(15)
                btn!.titleLabel?.textAlignment = NSTextAlignment.Center
                btn!.setTitleColor(Constants.HDMainTextColor, forState: UIControlState.Normal)
                btn!.addTarget(self, action: "menuBtnOnclick:", forControlEvents: UIControlEvents.TouchUpInside)
                menuView.addSubview(btn!)
                
                btn!.snp_makeConstraints { (make) -> Void in
                    
                    make.left.equalTo(menuView).offset(CGFloat(i)*Constants.kSCREENWITH/4)
                    make.top.equalTo(menuView).offset(0)
                    make.width.equalTo(Constants.kSCREENWITH/4)
                    make.height.equalTo(Constants.kSCREENWITH/4)
                    
                }
                
            }
            
        }

    }
    
    
    
    func createTagListView(){
    
        if tagListView == nil {
        
            tagListView = UIView()
            tagListView.backgroundColor = UIColor.whiteColor()
            baseView.addSubview(tagListView)
            
            tagListView.snp_makeConstraints { (make) -> Void in
                
                make.top.equalTo(menuView.snp_bottom).offset(Constants.HDSpace)
                make.left.equalTo(baseView).offset(0)
                make.width.equalTo(Constants.kSCREENWITH)
                make.height.equalTo((self.hdHM01Response?.result?.tagList?.count)!/4*TagHeight)
                
            }
            
        }
        
        /**
        *  几行4列
        */
        
        var index = 0
        for var i=0;i<(self.hdHM01Response?.result?.tagList?.count)!/4;i++ {
        
            for var j=0;j<4;j++ {
            
                let model:TagListModel = (self.hdHM01Response?.result?.tagList![index])!
                
                var btn:UIButton?
                
                btn = tagListView.viewWithTag(index) as? UIButton
                
                if btn == nil {
                
                    btn = UIButton()
                    btn!.backgroundColor = UIColor.whiteColor()
                    btn!.setTitleColor(Constants.HDMainTextColor, forState: UIControlState.Normal)
                    btn!.tag = index;
                    btn!.titleLabel?.font = UIFont.systemFontOfSize(16)
                    btn!.setTitle(model.name, forState: UIControlState.Normal)
                    btn!.layer.borderWidth = 0.5
                    btn!.layer.borderColor = Constants.HDBGViewColor.CGColor
                    btn!.addTarget(self, action: "tagBtnOnclick:", forControlEvents: UIControlEvents.TouchUpInside)
                    tagListView.addSubview(btn!)
                    
                    btn!.snp_makeConstraints(closure: { (make) -> Void in
                        
                        make.width.equalTo(Constants.kSCREENWITH/4)
                        make.height.equalTo(TagHeight)
                        make.left.equalTo(CGFloat(j)*Constants.kSCREENWITH/4)
                        make.top.equalTo(i*TagHeight)
                        
                    })

                }
                
                index++;
            }
            
        }
        
    }
    
    /**
     *  菜谱专辑
     */
    func createCollectListView(){
    
        
        if  collectListView == nil {
        
            collectListView = UIView()
            collectListView.backgroundColor = UIColor.whiteColor()
            baseView.addSubview(collectListView)
            
            collectListView.snp_makeConstraints { (make) -> Void in
                
                make.top.equalTo(tagListView.snp_bottom).offset(Constants.HDSpace)
                make.left.equalTo(baseView).offset(0)
                make.width.equalTo(Constants.kSCREENWITH)
                make.height.equalTo(300)
                
            }
            
            let title = UILabel()
            title.backgroundColor = UIColor.clearColor()
            title.textColor = Constants.HDMainColor
            title.text = "菜谱专辑"
            collectListView.addSubview(title)
            
            title.snp_makeConstraints { (make) -> Void in
                
                make.left.equalTo(collectListView).offset(16)
                make.top.equalTo(collectListView).offset(0)
                make.width.equalTo(Constants.kSCREENWITH-16)
                make.height.equalTo(40)
                
            }
            
            
            let line = UILabel()
            line.backgroundColor = Constants.HDBGViewColor
            collectListView.addSubview(line)
            
            line.snp_makeConstraints { (make) -> Void in
                
                
                make.left.equalTo(collectListView).offset(16)
                make.top.equalTo(collectListView).offset(260)
                make.width.equalTo(Constants.kSCREENWITH-16)
                make.height.equalTo(1)
                
            }
            
            let collectmore = UILabel()
            collectmore.backgroundColor = UIColor.clearColor()
            collectmore.textColor = Constants.HDMainTextColor
            collectmore.font = UIFont.systemFontOfSize(16)
            collectmore.text = "查看全部菜谱"
            collectListView.addSubview(collectmore)
            
            collectmore.snp_makeConstraints { (make) -> Void in
                
                make.left.equalTo(collectListView).offset(16)
                make.top.equalTo(line).offset(0)
                make.width.equalTo(Constants.kSCREENWITH-16)
                make.height.equalTo(40)
                
            }
            
            let moreArrow = UIImageView()
            moreArrow.image = UIImage(named: "moreArrowIcon")
            collectListView.addSubview(moreArrow)
            moreArrow.snp_makeConstraints(closure: { (make) -> Void in
                
                make.right.equalTo(collectListView).offset(-16)
                make.top.equalTo(line).offset(10)
                make.width.equalTo(20)
                make.height.equalTo(20)
                
            })
            

        }
        
        for var i=0;i<self.hdHM01Response?.result?.collectList?.count;i++ {
        
            let model = self.hdHM01Response?.result?.collectList?[i]
            
            var rowView:HDHM01RowView?
            rowView = collectListView.viewWithTag(i) as? HDHM01RowView
            
            if  rowView == nil {
            
                rowView = HDHM01RowView()
                rowView!.tag = i;
                collectListView.addSubview(rowView!)
                
                
                rowView!.title.text = model?.title
                rowView!.userName.text = String(format: "by %@",(model?.userName)!)
                rowView!.detail.text = model?.content
                
                rowView!.snp_makeConstraints { (make) -> Void in
                    
                    make.left.equalTo(collectListView).offset(16)
                    make.top.equalTo(collectListView).offset(i*110+40)
                    make.width.equalTo(Constants.kSCREENWITH-36)
                    make.height.equalTo(100)
                }

                
            }
            
            rowView!.imageView.sd_setImageWithURL(NSURL(string: model!.cover!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
            
        }
        
    }
    
    /**
     *  厨房宝典
     */
    func createWikiListView(){
    
        if wikiListView == nil {
        
            wikiListView = UIView()
            wikiListView.backgroundColor = UIColor.whiteColor()
            baseView.addSubview(wikiListView)
            
            wikiListView.snp_makeConstraints { (make) -> Void in
                
                make.top.equalTo(collectListView.snp_bottom).offset(Constants.HDSpace)
                make.left.equalTo(baseView).offset(0)
                make.width.equalTo(Constants.kSCREENWITH)
                make.height.equalTo(300)
                
            }
            
            let title = UILabel()
            title.backgroundColor = UIColor.clearColor()
            title.textColor = Constants.HDMainColor
            title.text = "厨房宝典"
            wikiListView.addSubview(title)
            
            title.snp_makeConstraints { (make) -> Void in
                
                make.left.equalTo(wikiListView).offset(16)
                make.top.equalTo(wikiListView).offset(0)
                make.width.equalTo(Constants.kSCREENWITH-16)
                make.height.equalTo(40)
                
            }
            
            let line = UILabel()
            line.backgroundColor = Constants.HDBGViewColor
            wikiListView.addSubview(line)
            
            line.snp_makeConstraints { (make) -> Void in
                
                
                make.left.equalTo(wikiListView).offset(16)
                make.top.equalTo(wikiListView).offset(260)
                make.width.equalTo(Constants.kSCREENWITH-16)
                make.height.equalTo(1)
                
            }
            
            
            let wikimore = UILabel()
            wikimore.backgroundColor = UIColor.clearColor()
            wikimore.textColor = Constants.HDMainTextColor
            wikimore.font = UIFont.systemFontOfSize(16)
            wikimore.text = "查看全部宝典"
            wikiListView.addSubview(wikimore)
            
            wikimore.snp_makeConstraints { (make) -> Void in
                
                make.left.equalTo(wikiListView).offset(16)
                make.top.equalTo(line).offset(0)
                make.width.equalTo(Constants.kSCREENWITH-16)
                make.height.equalTo(40)
                
            }
            
            let moreArrow = UIImageView()
            moreArrow.image = UIImage(named: "moreArrowIcon")
            wikiListView.addSubview(moreArrow)
            moreArrow.snp_makeConstraints(closure: { (make) -> Void in
                
                make.right.equalTo(collectListView).offset(-16)
                make.top.equalTo(line).offset(10)
                make.width.equalTo(20)
                make.height.equalTo(20)
                
            })

        }
        
        
        for var i=0;i<self.hdHM01Response?.result?.wikiList?.count;i++ {
            
            let model = self.hdHM01Response?.result?.wikiList?[i]
            
            var rowView:HDHM01RowView?
            rowView = wikiListView.viewWithTag(i) as? HDHM01RowView
            
            if  rowView == nil {
                
                rowView = HDHM01RowView()
                rowView!.tag = i;
                wikiListView.addSubview(rowView!)
                
                
                rowView!.title.text = model?.title
                rowView!.userName.text = String(format: "by %@",(model?.userName)!)
                rowView!.detail.text = model?.content
                
                rowView!.snp_makeConstraints { (make) -> Void in
                    
                    make.left.equalTo(wikiListView).offset(16)
                    make.top.equalTo(wikiListView).offset(i*110+40)
                    make.width.equalTo(Constants.kSCREENWITH-36)
                    make.height.equalTo(100)
                }
                
                
            }
            
            rowView!.imageView.sd_setImageWithURL(NSURL(string: model!.cover!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
            
        }
        
        
    }
    
    func showHud(){
    
        CoreUtils.showProgressHUD(self.view)
        
    }
    
    func hidenHud(){
    
        CoreUtils.hidProgressHUD(self.view)
    }
    
    // MARK: - 数据加载
    
    func doGetRequestData(){

        HDHM01Service().doGetRequest_HDHM01_URL({ (hdResponse) -> Void in
            
            self.hidenHud()
            
            self.hdHM01Response = hdResponse
            
            /**
            *  刷新UI
            */
            self.setupUI()
            
            /**
            *  结束刷新
            */
            self.baseView.mj_header.endRefreshing()
            
            }) { (error) -> Void in
                
                /**
                *  结束刷新
                */
                self.baseView.mj_header.endRefreshing()
                
                CoreUtils.showProgressHUD(self.view, title: Constants.HD_NO_NET_MSG)
        }

        
    }
    
    // MARK: - events 
    
    func menuBtnOnclick(btn:UIButton){
    
        let tag:Int = btn.tag - 300
        switch tag {
            
        case 0:
            /**
            *   排行榜
            */
            print("排行榜")
            break
        case 1:
            /**
            *   营养餐桌
            */
            print("营养餐桌")
            break
            
        case 2:
            /**
            *   发布菜谱
            */
            print("发布菜谱")
            break
            
        case 3:
            /**
            *   晒一晒
            */
            print("晒一晒")
            break
        default:
            "default"
        }
        
        
    }
    
    func tagBtnOnclick(btn:UIButton){
    
        
        let model:TagListModel = (self.hdHM01Response?.result?.tagList![btn.tag])!
        print("点击了 \(model.name)")
        
    }
    
    func pageAction(sender:AnyObject){
        
        headerSView.contentOffset = CGPointMake(Constants.kSCREENWITH*CGFloat((pageControl?.currentPage)!),0)
        /**
         *  更新菜谱名称
         */
        let recopeMddel:RecipeListModel = (self.hdHM01Response?.result?.recipeList![(pageControl?.currentPage)!])!
        headerTitle.text = recopeMddel.title
    }
    
    // MARK: - UIScrollView delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = NSInteger(scrollView.contentOffset.x/Constants.kSCREENWITH)
        
        if index<0 || index>3 {
        
            return
        }
        
        pageControl?.currentPage = index
        /**
         *  更新菜谱名称
         */
        let recopeMddel:RecipeListModel = (self.hdHM01Response?.result?.recipeList![index])!
        headerTitle.text = recopeMddel.title
    }

}


/**
*  原生态 自动布局


menuView.translatesAutoresizingMaskIntoConstraints = false;
let leftConstraint = NSLayoutConstraint(item: menuView,attribute: .Left,relatedBy: .Equal,toItem: baseView,attribute: .Left,multiplier: 1.0,constant: 0.0);
baseView.addConstraint(leftConstraint)
let rightConstraint = NSLayoutConstraint(item: menuView,attribute: .Width,relatedBy: .Equal,toItem: baseView,attribute: .Width,multiplier: 1.0,constant: Constants.kSCREENWITH);
baseView.addConstraint(rightConstraint)
let topConstraint = NSLayoutConstraint(item: menuView,attribute: .Top,relatedBy: .Equal,toItem: headView,attribute: .Bottom,multiplier: 1.0,constant: 0.0);
baseView.addConstraint(topConstraint)
let heightConstraint = NSLayoutConstraint(item: menuView,attribute: .Height,relatedBy: .Equal,toItem: baseView,attribute: .Height,multiplier: 0.0,constant: 100.0);
baseView.addConstraint(heightConstraint)

*/



