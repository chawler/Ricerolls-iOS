//
//  UIImageView+WebCache.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/17.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import Foundation
import Kingfisher

private var lastURLKey: Void?

extension UIImageView {
    
    public var rr_webURL: NSURL? {
        return objc_getAssociatedObject(self, &lastURLKey) as? NSURL
    }
    
    private func rr_setWebURL(URL: NSURL) {
        objc_setAssociatedObject(self, &lastURLKey, URL, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func setImageWith(urlString: String, cacheTarget: ImageCache? = nil) {
        
        if let url = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            
            var optionsInfo = [KingfisherOptionsInfoItem]()
            if let cacheTarget = cacheTarget {
                optionsInfo.append(.Downloader(AppContext.downloader))
                optionsInfo.append(.TargetCache(cacheTarget))
            }
            
            image = nil
            
            rr_setWebURL(NSURL(string: url)!)
            
            KingfisherManager.sharedManager.retrieveImageWithURL(rr_webURL!, optionsInfo: optionsInfo, progressBlock: nil, completionHandler: { [weak self] (image, error, cacheType, imageURL) in
                
                dispatch_async(dispatch_get_main_queue(), { 
                    
                    guard let sSelf = self where imageURL == sSelf.rr_webURL else {
                        return
                    }
                    
                    if let cacheTarget = cacheTarget {
                        if cacheType == .None {
                            if let image = image {
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { 
                                    let data = sSelf.compressionImage(image, maxLength: 102400)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        if sSelf.rr_webURL == imageURL {
                                            let newImage = UIImage(data: data)!
                                            sSelf.image = newImage
                                            cacheTarget.storeImage(newImage, originalData: data, forKey: sSelf.rr_webURL!.absoluteString)
                                        }
                                    })
                                })
                                return
                            }
                        }
                    }
                    
                    sSelf.image = image
                    
                })
                
            })
//            self.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: nil, optionsInfo: optionsInfo, progressBlock: nil, completionHandler: nil)
        }
        
    }
    
    private func compressionImage(image: UIImage, maxLength: Int) -> NSData {
        var compression: CGFloat = 0.8
        let amplitude: CGFloat = 0.1
        var data = UIImageJPEGRepresentation(image, compression)
        while data?.length > maxLength {
            if compression <= amplitude {
                break
            }
            compression -= amplitude
            data = UIImageJPEGRepresentation(image, compression)
        }
        return data!
    }
    
}
