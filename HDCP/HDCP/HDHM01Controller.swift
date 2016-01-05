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

class HDHM01Controller: BaseViewController,UIScrollViewDelegate {
    
    var baseView:UIScrollView!
    var hdHM01Response:HDHM01Response?
    
    var headView:UIView!
    var headerSView:UIScrollView!
    var pageControl:UIPageControl!
    var headerTitle:UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        doGetRequestData()
        
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
    
        baseView = UIScrollView()
        self.view.addSubview(baseView)
        
        
        baseView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(0)
            make.left.equalTo(self.view).offset(0)
            make.right.equalTo(self.view).offset(0)
            
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
            headView = UIView(frame: CGRectMake(0,64,Constants.kSCREENWITH,HeadViewHeight))
            baseView.addSubview(headView)
            
            headerSView = UIScrollView(frame: headView.bounds)
            headerSView.pagingEnabled = true
            headerSView.userInteractionEnabled = true;
            headerSView.delegate = self;
            headerSView.showsVerticalScrollIndicator = false;
            headerSView.showsHorizontalScrollIndicator = false;
            
            headerSView.contentSize = CGSizeMake(Constants.kSCREENWITH*CGFloat((self.hdHM01Response?.result?.recipeList?.count)!), HeadViewHeight)
            headView.addSubview(headerSView)
            
            /**
            *  显示图片
            */
            for var i=0;i<self.hdHM01Response?.result?.recipeList?.count;i++ {
                
                let recopeMddel:RecipeListModel = (self.hdHM01Response?.result?.recipeList![i])!
                let imageView = UIImageView(frame: CGRectMake(Constants.kSCREENWITH*CGFloat(i),0,Constants.kSCREENWITH,HeadViewHeight))
                headerSView.addSubview(imageView)
                imageView.setImageWithURL(NSURL(string: recopeMddel.cover!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
                
            }
            
            /**
            *  分页栏
            */
            pageControl = UIPageControl(frame: CGRectMake(Constants.kSCREENWITH-100,HeadViewHeight-40,100,40))
            pageControl?.addTarget(self, action: "pageAction:", forControlEvents: UIControlEvents.TouchUpInside)
            pageControl?.numberOfPages = 3;
            pageControl?.currentPage = 0;
            pageControl?.pageIndicatorTintColor = Constants.HDMainColor
            headView.addSubview(pageControl!)
            
            /**
            *  菜粕名称
            */
            headerTitle = UILabel(frame: CGRectMake(20,HeadViewHeight-40,Constants.kSCREENWITH-150,40))
            headerTitle.font = UIFont.systemFontOfSize(18)
            headerTitle.textColor = Constants.HDMainColor
            headView.addSubview(headerTitle)
            
            /**
             *  默认初始给第一个的名称
             */
            let recopeMddel:RecipeListModel = (self.hdHM01Response?.result?.recipeList![0])!
            headerTitle.text = recopeMddel.title
            
        }
        
    }
    
    // MARK: - 数据加载
    /**
     *  加载数据
     */
    func doGetRequestData(){
    
        CoreUtils.showProgressHUD(self.view)
        
        HDHM01Service().doGetRequest_HDHM01_URL({ (hdResponse) -> Void in
            
            CoreUtils.hidProgressHUD(self.view)
            
            self.hdHM01Response = hdResponse
            
            self.setupUI()
            
            }) { (error) -> Void in
                
                CoreUtils.showProgressHUD(self.view, title: Constants.HD_NO_NET_MSG)
                
        }

        
    }
    
    // MARK: - events 
    func pageAction(sender:AnyObject){
        
        headerSView.contentOffset = CGPointMake(Constants.kSCREENWITH*CGFloat((pageControl?.currentPage)!),0)
        
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


