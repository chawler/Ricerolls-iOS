//
//  BaseCollectionCell.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/19.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
        setupViews()
        autolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config() {
        
    }
    
    func setupViews() {
        
    }
    
    func autolayout() {
        
    }
    
}
