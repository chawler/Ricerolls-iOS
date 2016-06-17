//
//  ComicCell.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/17.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit

class ComicCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let v = UIImageView(image: UIImage.imageWithColor(UIColor.lightGrayColor()))
        return v
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13)
        label.textColor = HexRGB(0x6c6c6c)
        label.textAlignment = .Center
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(12)
        label.textColor = HexRGB(0xdcdcdc)
        label.textAlignment = .Center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        
        imageView.snp_makeConstraints { (make) in
            make.top.left.equalTo(contentView)
            make.width.equalTo(contentView)
            make.height.equalTo(contentView).multipliedBy(0.75)
        }
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(imageView.snp_bottom).offset(5)
            make.height.equalTo(20)
            make.left.width.equalTo(contentView)
        }
        timeLabel.snp_makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(2)
            make.height.equalTo(15)
            make.left.width.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
