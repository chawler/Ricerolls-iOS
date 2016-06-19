//
//  UIImageView+WebCache.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/17.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import Foundation
import Kingfisher

private var kUIImageViewURLCacheKey: UInt8 = 0
private var sharedURLCache = [Int: String]()

extension UIImageView {
    
    func setImageWith(urlString: String) {
        
        let imageViewKey = self.hashValue
        sharedURLCache[imageViewKey] = urlString
        
        self.kf_setImageWithURL(NSURL(string: urlString)!)
        
//        ImageDownloader.defaultDownloader.downloadImageWithURL(NSURL(string: urlString)!, progressBlock: nil) { (image, error, imageURL, originalData) in
//            
//            if error != nil {
//                
//            } else {
//                if let url = sharedURLCache[imageViewKey] {
//                    if url == imageURL?.absoluteString {
//                        self.image = image
//                        sharedURLCache.removeValueForKey(imageViewKey)
//                    }
//                }
//            }
//            
//        }
    }
    
}
