//
//  ADBlurImageView.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/17.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit

class ADBlurImageView: CustomView {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .Light)
        return UIVisualEffectView(effect: effect)
    }()
    
    override func setupViews() {
        self.addSubviews(
            [
                imageView, blurView
            ]
        )
    }
    
    override func autolayout() {
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        blurView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func setImageWith(urlString: String) {
        imageView.setImageWith(urlString)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
