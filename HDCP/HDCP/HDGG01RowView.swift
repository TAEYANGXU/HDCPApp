//
//  GG01RowView.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/8.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

public protocol HDGG01RowViewProtocol {

    func didSelectHDGG01RowView(_ indexPath: IndexPath, index: Int) -> Void;

}

class HDGG01RowView: UIView {

    var imageView: UIImageView!
    var title: UILabel!

    var delegate: HDGG01RowViewProtocol?

    var indexPath: IndexPath!
    var index: Int!

    override init(frame: CGRect) {

        super.init(frame: frame)

        createSubviews()

    }

    func createSubviews() {

        if imageView == nil {

            imageView = UIImageView()
            imageView.layer.cornerRadius = 1
            imageView.layer.masksToBounds = true
            self.addSubview(imageView)

            imageView.snp.makeConstraints { (make) -> Void in

                make.top.equalTo(self).offset(0)
                make.left.equalTo(self).offset(0)
                make.bottom.equalTo(self).offset(0)
                make.right.equalTo(self).offset(0)
            }

        }

        if title == nil {

            title = UILabel()
            title.font = UIFont.boldSystemFont(ofSize: 15)
            title.textColor = UIColor.white
            title.backgroundColor = CoreUtils.HDColor(105, g: 149, b: 0, a: 0.5)
            title.textAlignment = NSTextAlignment.center
            self.addSubview(title)

            title.snp.makeConstraints( { (make) -> Void in

                make.bottom.equalTo(self).offset(0)
                make.left.equalTo(self).offset(0)
                make.right.equalTo(self).offset(0)
                make.height.equalTo(20)

            })

        }

        let tapGes = UITapGestureRecognizer(target: self, action: #selector(onClickAction))
        self.addGestureRecognizer(tapGes)

    }

    func onClickAction() {

        if (self.delegate != nil) {

            self.delegate?.didSelectHDGG01RowView(self.indexPath, index: self.index)

        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
