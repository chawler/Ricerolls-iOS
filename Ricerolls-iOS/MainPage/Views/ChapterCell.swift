//
//  ChapterCell.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/19.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit

class ChapterCell: BaseCollectionCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(14)
        label.textColor = HexRGB(0x6c6c6c)
        label.textAlignment = .Center
        label.backgroundColor = UIColor.whiteColor()
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        self.contentView.addSubview(titleLabel)
    }
    
    override func autolayout() {
        super.autolayout()
        titleLabel.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
}
