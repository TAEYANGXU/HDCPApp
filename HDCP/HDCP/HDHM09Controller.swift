//
//  HDHM09Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/18.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM09Controller: UIViewController,UIScrollViewDelegate {
    
    var index:Int?
    var steps:Array<HDHM08StepModel>?
    var cancelBtn:UIButton?
    var imageScrollView:UIScrollView?
    var pageFlag:UILabel?
    var context:UILabel?
    
    /**
     *   UIImageView重用
     */
    var centerImageView:UIImageView?
    var leftImageView:UIImageView?
    var rightImageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        setupUI()
    }

    deinit{
    
        HDLog.LogClassDestory("HDHM09Controller")
    }
    
    // MARK: - 创建UI视图
    
    func setupUI(){
        
        createCancelBtn()
        createImageScrollView()
        createTextView()
    }
    
    func createCancelBtn(){
    
        if  cancelBtn == nil {
        
            cancelBtn = UIButton(type: UIButtonType.Custom) as UIButton
            cancelBtn?.setTitle("x", forState: UIControlState.Normal)
            cancelBtn?.layer.cornerRadius = 15
            cancelBtn?.titleLabel?.textAlignment = NSTextAlignment.Center
            cancelBtn?.layer.masksToBounds = true
            cancelBtn?.setTitleColor(Constants.HDMainColor, forState: UIControlState.Normal)
            cancelBtn?.layer.borderWidth = 0.5
            cancelBtn?.addTarget(self, action: #selector(backAction), forControlEvents: UIControlEvents.TouchUpInside)
            cancelBtn?.layer.borderColor = Constants.HDMainColor.CGColor
            self.view.addSubview(cancelBtn!)
            
            unowned let WS = self
            cancelBtn?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.view).offset(50)
                make.right.equalTo(WS.view.snp_right).offset(-30)
                make.width.equalTo(30)
                make.height.equalTo(30)
                
            })
            
        }
        
    }
    
    func createImageScrollView(){
    
        if imageScrollView == nil {
            
            imageScrollView = UIScrollView()
            imageScrollView!.pagingEnabled = true
            imageScrollView!.userInteractionEnabled = true
            imageScrollView!.delegate = self
            imageScrollView!.showsVerticalScrollIndicator = false
            imageScrollView!.showsHorizontalScrollIndicator = false
            self.view.addSubview(imageScrollView!)
            
            unowned let WS = self
            imageScrollView!.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(WS.view).offset(Constants.HDSCREENHEIGHT/2-100)
                make.left.equalTo(WS.view).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(200)
                
                
            })
            
            imageScrollView?.contentSize = CGSizeMake(CGFloat(3)*Constants.HDSCREENWITH, 200)
            imageScrollView!.contentOffset = CGPointMake(Constants.HDSCREENWITH,0)

            
            centerImageView = UIImageView(frame: CGRectMake(Constants.HDSCREENWITH,0,Constants.HDSCREENWITH,200))
            centerImageView!.contentMode = UIViewContentMode.ScaleToFill;
            imageScrollView?.addSubview(centerImageView!)

            
            leftImageView = UIImageView(frame: CGRectMake(0,0,Constants.HDSCREENWITH,200))
            leftImageView!.contentMode = UIViewContentMode.ScaleToFill;
            imageScrollView?.addSubview(leftImageView!)


            rightImageView = UIImageView(frame: CGRectMake(Constants.HDSCREENWITH*2,0,Constants.HDSCREENWITH,200))
            rightImageView!.contentMode = UIViewContentMode.ScaleToFill;
            imageScrollView?.addSubview(rightImageView!)

            
        }

        
    }
    
    func createTextView(){
    
        if pageFlag == nil {
        
            pageFlag = UILabel()
            pageFlag?.textColor = Constants.HDMainTextColor
            
            pageFlag?.font = UIFont.systemFontOfSize(26)
            self.view.addSubview(pageFlag!)
            
            unowned let WS = self
            pageFlag?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-60)
                make.height.equalTo(30)
                make.bottom.equalTo(WS.imageScrollView!.snp_top).offset(-5)
                make.left.equalTo(WS.view).offset(30)
                
            })
            
        }
        
        if context == nil {
            
            context = UILabel()
            context?.numberOfLines = 0
            context?.textColor = Constants.HDMainTextColor
            context?.font = UIFont.systemFontOfSize(18)
            self.view.addSubview(context!)
            
            unowned let WS = self
            context?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-60)
                make.height.equalTo(0)
                make.top.equalTo(WS.imageScrollView!.snp_bottom).offset(20)
                make.left.equalTo(WS.view).offset(30)
                
            })

        }
        
        setInfoByCurrentImageIndex(index!)
        
    }
    
    // MARK: - events
    
    func backAction(){
        
        self.dismissViewControllerAnimated(true) { () -> Void in }
        
    }
    
    func loadImage(){
    
        
        if imageScrollView!.contentOffset.x>Constants.HDSCREENWITH {
            
            //向左滑动
            index = (index!+1+(steps?.count)!)%(steps?.count)!
            
        }else if imageScrollView!.contentOffset.x<Constants.HDSCREENWITH{
            
             //向右滑动
            index = (index!-1+(steps?.count)!)%(steps?.count)!
        }
        
        setInfoByCurrentImageIndex(index!)
        
        
    }
    
    func setInfoByCurrentImageIndex(index:Int){
    
        let cmodel = steps![index]
        
        /// 文本信息
        let str = String(format: "%d/%d", index+1,(steps?.count)!)
        let str2:String =  str.componentsSeparatedByString("/")[0]
        let attributed = NSMutableAttributedString(string: str)
        attributed.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(26), range: NSMakeRange(0, str2.characters.count))
        attributed.addAttribute(NSForegroundColorAttributeName, value: CoreUtils.HDColor(245, g: 161, b: 0, a: 1), range: NSMakeRange(0, str2.characters.count))
        pageFlag?.attributedText =  attributed
        
        centerImageView!.sd_setImageWithURL(NSURL(string: cmodel.stepPhoto!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        let lmodel = steps![((index-1)+(steps?.count)!)%(steps?.count)!]
        leftImageView!.sd_setImageWithURL(NSURL(string: lmodel.stepPhoto!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        let rmodel = steps![((index+1)+(steps?.count)!)%(steps?.count)!]
        rightImageView!.sd_setImageWithURL(NSURL(string: rmodel.stepPhoto!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
        
        context?.text = cmodel.intro
        /// 计算文本高度 重新赋值
        let rect = CoreUtils.getTextRectSize(cmodel.intro!, font: UIFont.systemFontOfSize(18), size: CGSizeMake(Constants.HDSCREENWITH-60, 999))
        context?.snp_updateConstraints(closure: { (make) -> Void in
            make.height.equalTo(rect.size.height+10)
        })
        
        
    }
    
    // MARK: - UIScrollView  Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
    
        loadImage()

        imageScrollView!.contentOffset = CGPointMake(Constants.HDSCREENWITH,0)
        
        
    }
}
