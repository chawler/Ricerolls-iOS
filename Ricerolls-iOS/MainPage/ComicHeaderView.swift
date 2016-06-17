//
//  ComicHeaderView.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/17.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit

private let kCoverRightInset = 20

class ComicHeaderView: CustomView {
    
    let background = ADBlurImageView()
    lazy var coverView: UIImageView = {
        let civ = UIImageView()
        civ.clipsToBounds = true
        civ.contentMode = .ScaleAspectFill
        return civ
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.font = kFont(15)
        return label
    }()
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.font = kFont(13)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubviews(
            [
                background,
                coverView,
                authorLabel,
                titleLabel,
            ]
        )
    }
    
    override func autolayout() {
        super.autolayout()
        background.snp_makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(self)
        }
        coverView.snp_makeConstraints { (make) in
            make.width.equalTo(self).multipliedBy(0.35)
            make.height.equalTo(self.snp_width).multipliedBy(0.48)
            make.left.equalTo(16)
            make.bottom.equalTo(background.snp_bottom)
        }
        authorLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(coverView)
            make.width.lessThanOrEqualTo(kDeviceWidth/2)
            make.height.equalTo(20)
            make.left.equalTo(coverView.snp_right).offset(kCoverRightInset)
        }
        titleLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(authorLabel.snp_top)
            make.size.equalTo(authorLabel)
            make.left.equalTo(authorLabel)
        }
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.font = kFont(12)
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = getRandomColor()
        label.textAlignment = .Center
        label.layer.cornerRadius = 3.0
        label.layer.masksToBounds = true
        return label
    }
    
    func setupTags(tags: [String]) {
        var lastView: UIView?
        for tag in tags {
            let label = createLabel()
            label.text = tag
            self.addSubview(label)
            label.snp_makeConstraints(closure: { (make) in
                let v = lastView ?? self.coverView
                make.left.equalTo(v.snp_right).offset(lastView != nil ? 8 : 20)
                make.top.equalTo(coverView).offset(kCoverRightInset)
                make.width.equalTo(32)
                make.height.equalTo(18)
            })
            lastView = label
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
