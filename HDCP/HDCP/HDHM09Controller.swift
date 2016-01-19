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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        setupUI()
    }

    // MARK: - 创建UI视图 245 161 0
    
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
            cancelBtn?.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
            cancelBtn?.layer.borderColor = Constants.HDMainColor.CGColor
            self.view.addSubview(cancelBtn!)
            
            cancelBtn?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(self.view).offset(50)
                make.right.equalTo(self.view.snp_right).offset(-30)
                make.width.equalTo(30)
                make.height.equalTo(30)
                
            })
            
        }
        
    }
    
    func createImageScrollView(){
    
        if imageScrollView == nil {
            
            imageScrollView = UIScrollView()
            imageScrollView!.pagingEnabled = true
            imageScrollView!.userInteractionEnabled = true;
            imageScrollView!.delegate = self;
            imageScrollView?.bounces = false
            imageScrollView!.showsVerticalScrollIndicator = false;
            imageScrollView!.showsHorizontalScrollIndicator = false;
            self.view.addSubview(imageScrollView!)
            
            imageScrollView!.snp_makeConstraints(closure: { (make) -> Void in
                
                make.top.equalTo(self.view).offset(Constants.HDSCREENHEIGHT/2-100)
                make.left.equalTo(self.view).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(200)
                
                
            })
            
            imageScrollView!.contentOffset = CGPointMake(Constants.HDSCREENWITH*CGFloat(index!),0)
            
            imageScrollView?.contentSize = CGSizeMake(CGFloat((steps?.count)!)*Constants.HDSCREENWITH, 200)
            
            for var i=0;i<steps?.count;i++ {
            
                let model = steps![i]
                let imageView = UIImageView()
                imageView.sd_setImageWithURL(NSURL(string: model.stepPhoto!), placeholderImage: UIImage(named: "noDataDefaultIcon"))
                imageScrollView?.addSubview(imageView)
                
                imageView.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.top.equalTo(imageScrollView!).offset(0)
                    make.left.equalTo(imageScrollView!).offset(CGFloat(i)*Constants.HDSCREENWITH)
                    make.width.equalTo(Constants.HDSCREENWITH)
                    make.height.equalTo(200)
                })
                
            }
            
        }

        
    }
    
    func createTextView(){
    
        if pageFlag == nil {
        
            pageFlag = UILabel()
            pageFlag?.textColor = Constants.HDMainTextColor
            
            let str = String(format: "%d/%d", index!+1,(steps?.count)!)
            let str2:String =  str.componentsSeparatedByString("/")[0]
            let attributed = NSMutableAttributedString(string: str)
            attributed.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(26), range: NSMakeRange(0, str2.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
            attributed.addAttribute(NSForegroundColorAttributeName, value: Constants.HDColor(245, g: 161, b: 0, a: 1), range: NSMakeRange(0, str2.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
            pageFlag?.attributedText =  attributed
            pageFlag?.font = UIFont.systemFontOfSize(26)
            self.view.addSubview(pageFlag!)
            
            pageFlag?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-60)
                make.height.equalTo(30)
                make.bottom.equalTo(imageScrollView!.snp_top).offset(-5)
                make.left.equalTo(self.view).offset(30)
                
            })
            
        }
        
        if context == nil {
        
            let model = steps![index!]
            let rect = CoreUtils.getTextRectSize(model.intro!, font: UIFont.systemFontOfSize(18), size: CGSizeMake(Constants.HDSCREENWITH-60, 999))
            
            context = UILabel()
            context?.text = model.intro
            context?.numberOfLines = 0
            context?.textColor = Constants.HDMainTextColor
            context?.font = UIFont.systemFontOfSize(18)
            self.view.addSubview(context!)
            
            context?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(Constants.HDSCREENWITH-60)
                make.height.equalTo(rect.size.height+10)
                make.top.equalTo(imageScrollView!.snp_bottom).offset(20)
                make.left.equalTo(self.view).offset(30)
                
            })

        }
        
    }
    
    // MARK: - events
    
    func backAction(){
        
        self.dismissViewControllerAnimated(true) { () -> Void in }
        
    }
    
    // MARK: - UIScrollView  Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
    
        index = NSInteger(scrollView.contentOffset.x/Constants.HDSCREENWITH)
        
        if index<0 || index>=steps?.count {
            
            return
        }

        
        let model = steps![index!]
        context?.text = model.intro
        
        let str = String(format: "%d/%d", index!+1,(steps?.count)!)
        let str2:String =  str.componentsSeparatedByString("/")[0]
        let attributed = NSMutableAttributedString(string: str)
        attributed.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(26), range: NSMakeRange(0, str2.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
        attributed.addAttribute(NSForegroundColorAttributeName, value: Constants.HDColor(245, g: 161, b: 0, a: 1), range: NSMakeRange(0, str2.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
        pageFlag?.attributedText =  attributed
        
    }
}
