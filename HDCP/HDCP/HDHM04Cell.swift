//
//  HDHM04Cell.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/14.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM04Cell: UITableViewCell {

    //图片
    var coverImageV: UIImageView?
    //名称
    var title: UILabel?
    //收藏/浏览
    var count: UILabel?
    //介绍
    var stuff: UILabel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        createSubviews()

    }

    func createSubviews() {


        if coverImageV == nil {

            coverImageV = UIImageView()
            coverImageV?.layer.cornerRadius = 2
            coverImageV?.layer.masksToBounds = true
            self.contentView.addSubview(coverImageV!)

            coverImageV?.snp.makeConstraints( { (make) -> Void in

                make.left.equalTo(self.contentView).offset(16)
                make.top.equalTo(self.contentView).offset(10)
                make.width.equalTo(80)
                make.height.equalTo(60)

            })

        }

        if title == nil {


            title = UILabel()
            title?.font = UIFont.systemFont(ofSize: 16)
            title?.textColor = Constants.HDMainTextColor
            self.contentView.addSubview(title!)

            title?.snp.makeConstraints( { (make) -> Void in

                make.left.equalTo(coverImageV!.snp.right).offset(5)
                make.right.equalTo(self.contentView).offset(-20)
                make.top.equalTo(self.contentView).offset(10)
                make.height.equalTo(25)

            })

        }

        if count == nil {

            count = UILabel()
            count?.font = UIFont.systemFont(ofSize: 13)
            count?.textColor = UIColor.lightGray
            self.contentView.addSubview(count!)

            count?.snp.makeConstraints( { (make) -> Void in

                make.left.equalTo(coverImageV!.snp.right).offset(5)
                make.right.equalTo(self.contentView).offset(-20)
                make.top.equalTo(title!.snp.bottom).offset(0)
                make.height.equalTo(17)

            })


        }


        if stuff == nil {

            stuff = UILabel()
            stuff?.font = UIFont.systemFont(ofSize: 13)
            stuff?.textColor = UIColor.lightGray
            self.contentView.addSubview(stuff!)

            stuff?.snp.makeConstraints( { (make) -> Void in

                make.left.equalTo(coverImageV!.snp.right).offset(5)
                make.right.equalTo(self.contentView).offset(-20)
                make.top.equalTo(count!.snp.bottom).offset(3)
                make.height.equalTo(17)

            })


        }


    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }



}
