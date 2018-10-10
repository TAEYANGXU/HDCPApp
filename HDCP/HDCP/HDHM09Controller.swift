//
//  HDHM09Controller.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/18.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM09Controller: UIViewController, UIScrollViewDelegate {

    var index: Int?
    var steps: Array<HDHM08StepModel>?
    var cancelBtn: UIButton?
    var imageScrollView: UIScrollView?
    var pageFlag: UILabel?
    var context: UILabel?

    /**
     *   UIImageView重用
     */
    var centerImageView: UIImageView?
    var leftImageView: UIImageView?
    var rightImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        setupUI()
    }

    deinit {

        HDLog.LogClassDestory("HDHM09Controller")
    }

    // MARK: - 创建UI视图

    func setupUI() {

        createCancelBtn()
        createImageScrollView()
        createTextView()
    }

    func createCancelBtn() {

        if cancelBtn == nil {

            cancelBtn = UIButton(type: UIButton.ButtonType.custom) as UIButton
            cancelBtn?.setTitle("x", for: UIControl.State())
            cancelBtn?.layer.cornerRadius = 15
            cancelBtn?.titleLabel?.textAlignment = NSTextAlignment.center
            cancelBtn?.layer.masksToBounds = true
            cancelBtn?.setTitleColor(Constants.HDMainColor, for: UIControl.State.normal)
            cancelBtn?.layer.borderWidth = 0.5
            cancelBtn?.addTarget(self, action: #selector(backAction), for: UIControl.Event.touchUpInside)
            cancelBtn?.layer.borderColor = Constants.HDMainColor.cgColor
            self.view.addSubview(cancelBtn!)

            unowned let WS = self
            cancelBtn?.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.view).offset(50)
                make.right.equalTo(WS.view.snp.right).offset(-30)
                make.width.equalTo(30)
                make.height.equalTo(30)

            })

        }

    }

    func createImageScrollView() {

        if imageScrollView == nil {

            imageScrollView = UIScrollView()
            imageScrollView!.isPagingEnabled = true
            imageScrollView!.isUserInteractionEnabled = true
            imageScrollView!.delegate = self
            imageScrollView!.showsVerticalScrollIndicator = false
            imageScrollView!.showsHorizontalScrollIndicator = false
            self.view.addSubview(imageScrollView!)

            unowned let WS = self
            imageScrollView!.snp.makeConstraints( { (make) -> Void in

                make.top.equalTo(WS.view).offset(Constants.HDSCREENHEIGHT / 2 - 100)
                make.left.equalTo(WS.view).offset(0)
                make.width.equalTo(Constants.HDSCREENWITH)
                make.height.equalTo(200)


            })

            imageScrollView?.contentSize = CGSize(width: CGFloat(3) * Constants.HDSCREENWITH, height: 200)
            imageScrollView!.contentOffset = CGPoint(x: Constants.HDSCREENWITH, y: 0)


            centerImageView = UIImageView(frame: CGRect(x: Constants.HDSCREENWITH, y: 0, width: Constants.HDSCREENWITH, height: 200))
            centerImageView!.contentMode = UIView.ContentMode.scaleToFill;
            imageScrollView?.addSubview(centerImageView!)


            leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.HDSCREENWITH, height: 200))
            leftImageView!.contentMode = UIView.ContentMode.scaleToFill;
            imageScrollView?.addSubview(leftImageView!)


            rightImageView = UIImageView(frame: CGRect(x: Constants.HDSCREENWITH * 2, y: 0, width: Constants.HDSCREENWITH, height: 200))
            rightImageView!.contentMode = UIView.ContentMode.scaleToFill;
            imageScrollView?.addSubview(rightImageView!)


        }


    }

    func createTextView() {

        if pageFlag == nil {

            pageFlag = UILabel()
            pageFlag?.textColor = Constants.HDMainTextColor

            pageFlag?.font = UIFont.systemFont(ofSize: 26)
            self.view.addSubview(pageFlag!)

            unowned let WS = self
            pageFlag?.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 60)
                make.height.equalTo(30)
                make.bottom.equalTo(WS.imageScrollView!.snp.top).offset(-5)
                make.left.equalTo(WS.view).offset(30)

            })

        }

        if context == nil {

            context = UILabel()
            context?.numberOfLines = 0
            context?.textColor = Constants.HDMainTextColor
            context?.font = UIFont.systemFont(ofSize: 18)
            self.view.addSubview(context!)

            unowned let WS = self
            context?.snp.makeConstraints( { (make) -> Void in

                make.width.equalTo(Constants.HDSCREENWITH - 60)
                make.height.equalTo(0)
                make.top.equalTo(WS.imageScrollView!.snp.bottom).offset(20)
                make.left.equalTo(WS.view).offset(30)

            })

        }

        setInfoByCurrentImageIndex(index!)

    }

    // MARK: - events

    @objc func backAction() {

        self.dismiss(animated: true) { () -> Void in }

    }

    func loadImage() {


        if imageScrollView!.contentOffset.x > Constants.HDSCREENWITH {

            //向左滑动
            index = (index! + 1 + (steps?.count)!) % (steps?.count)!

        } else if imageScrollView!.contentOffset.x < Constants.HDSCREENWITH {

            //向右滑动
            index = (index! - 1 + (steps?.count)!) % (steps?.count)!
        }

        setInfoByCurrentImageIndex(index!)


    }

    func setInfoByCurrentImageIndex(_ index: Int) {

        let cmodel = steps![index]

        /// 文本信息
        let str = String(format: "%d/%d", index + 1, (steps?.count)!)
        let str2: String = str.components(separatedBy: "/")[0]
        let attributed = NSMutableAttributedString(string: str)
        attributed.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 26), range: NSMakeRange(0, str2.characters.count))
        attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: Constants.HDYellowColor, range: NSMakeRange(0, str2.characters.count))
        pageFlag?.attributedText = attributed

        centerImageView!.kf.setImage(with: URL(string: cmodel.stepPhoto!), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

        let lmodel = steps![((index - 1) + (steps?.count)!) % (steps?.count)!]
        leftImageView!.kf.setImage(with: URL(string: lmodel.stepPhoto!), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

        let rmodel = steps![((index + 1) + (steps?.count)!) % (steps?.count)!]
        rightImageView!.kf.setImage(with: URL(string: rmodel.stepPhoto!), placeholder: UIImage(named: "noDataDefaultIcon"), options: nil, progressBlock: nil, completionHandler: nil)

        context?.text = cmodel.intro
        /// 计算文本高度 重新赋值
        let rect = CoreUtils.getTextRectSize(cmodel.intro! as NSString, font: UIFont.systemFont(ofSize: 18), size: CGSize(width: Constants.HDSCREENWITH - 60, height: 999))
        context?.snp.updateConstraints({ (make) -> Void in
            make.height.equalTo(rect.size.height + 10)
        })


    }

    // MARK: - UIScrollView  Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        loadImage()

        imageScrollView!.contentOffset = CGPoint(x: Constants.HDSCREENWITH, y: 0)


    }
}
