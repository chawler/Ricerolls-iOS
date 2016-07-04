//
//  MangaCollectionViewCell.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/29.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit

class MangaCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.rx_setDelegate(self)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        imageView.snp_makeConstraints { (make) in
            make.center.equalTo(scrollView)
            make.width.height.equalTo(scrollView)
        }
    }
    
    func reset(){
        scrollView.setZoomScale(1, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
