//
//  HDHM07Cell.swift
//  HDCP
//
//  Created by 徐琰璋 on 16/1/17.
//  Copyright © 2016年 batonsoft. All rights reserved.
//

import UIKit

class HDHM07Cell: UITableViewCell {

    //图片
    var coverImageV:UIImageView?
    //名称
    var title:UILabel?
    //介绍
    var content:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createSubviews()
        
    }
    
    func createSubviews(){
        
        
        if coverImageV == nil {
            
            coverImageV = UIImageView()
            coverImageV?.layer.cornerRadius = 2
            coverImageV?.layer.masksToBounds = true
            self.contentView.addSubview(coverImageV!)
            
            coverImageV?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.left.equalTo(self.contentView).offset(16)
                make.top.equalTo(self.contentView).offset(10)
                make.width.equalTo(80)
                make.height.equalTo(60)
                
            })
            
        }
        
        if title == nil {
            
            
            title = UILabel()
            title?.font = UIFont.systemFontOfSize(16)
            title?.textColor = Constants.HDMainTextColor
            self.contentView.addSubview(title!)
            
            title?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.left.equalTo(coverImageV!.snp_right).offset(5)
                make.right.equalTo(self.contentView).offset(-20)
                make.top.equalTo(self.contentView).offset(10)
                make.height.equalTo(25)
                
            })
            
        }
        
        if content == nil {
            
            content = UILabel()
            content?.numberOfLines = 2 
            content?.font = UIFont.systemFontOfSize(13)
            content?.textColor = UIColor.lightGrayColor()
            self.contentView.addSubview(content!)
            
            content?.snp_makeConstraints(closure: { (make) -> Void in
                
                make.left.equalTo(coverImageV!.snp_right).offset(5)
                make.right.equalTo(self.contentView).offset(-20)
                make.top.equalTo(title!.snp_bottom).offset(0)
                make.height.equalTo(35)
                
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
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
