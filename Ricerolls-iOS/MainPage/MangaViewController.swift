//
//  MangaViewController.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/20.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class MangaViewController: BaseViewController, UIScrollViewDelegate {
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView(frame: CGRectMake(0, 0, kDeviceWidth, kDeviceHeight))
        v.backgroundColor = UIColor.blackColor()
        v.pagingEnabled = true
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.delegate = self
        return v
    }()
    
    lazy var visibleImageViews = Set<UIImageView>()
    lazy var reusedImageViews = Set<UIImageView>()
    
    lazy var imageCache: ImageCache = {
        let name = "\(self.chapter.value.id)"
        let cache: ImageCache = ImageCache(name: name, path: (CACHE_FOLDER as NSString).stringByAppendingPathComponent("chapters"))
        cache.maxMemoryCost = 30
        return cache
    }()
    
    var pages: Int {
        return chapter.value.pages
    }
    
    var chapter = Variable(Chapter())
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(scrollView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        comicProvider.request(.Chapter(comicId: MangaViewModel.comicId,
                                            id: MangaViewModel.selectedChapter!.id))
        .filterSuccessfulStatusCodes()
        .mapObject(Chapter)
        .bindTo(chapter)
        .addDisposableTo(rx_disposeBag)
        
        chapter.asDriver()
            .driveNext { chapter in
                self.scrollView.contentSize = CGSizeMake(CGFloat(self.pages)*kDeviceWidth, 0)
                self.showImageViewAtIndex(0)
            }
            .addDisposableTo(rx_disposeBag)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.imageCache.clearMemoryCache()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.imageCache.clearMemoryCache()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        showImages()
//        for (var index = firstIndex; index <= lastIndex; index += 1) {
//            
//        }
        
    }
    
    func showImages() {
        
        // 获取当前处于显示范围内的图片的索引
        let visibleBounds = self.scrollView.bounds
        let minX = visibleBounds.minX
        let maxX = visibleBounds.maxX
        let width = visibleBounds.width
        
        
        var firstIndex = Int(floorf(Float(minX / width)))
        var lastIndex = Int(floorf(Float(maxX / width)))
        
        if firstIndex < 0 {
            firstIndex = 0
        }
        
        if lastIndex >= pages {
            lastIndex = max(pages-1, 0)
        }
        
        var imageViewIndex = 0
        visibleImageViews.forEach { imageView in
            imageViewIndex = imageView.tag
            if imageViewIndex < firstIndex ||
                imageViewIndex > lastIndex {
                reusedImageViews.insert(imageView)
                imageView.removeFromSuperview()
            }
        }
        
        visibleImageViews = visibleImageViews.exclusiveOr(reusedImageViews)
        
        for index in firstIndex...lastIndex {
            var isShow = false
            
            visibleImageViews.forEach({ imageView in
                if imageView.tag == index {
                    isShow = true
                }
            })
            
            if !isShow {
                showImageViewAtIndex(index)
            }
        }
    }

    func showImageViewAtIndex(index: Int) {
        var imageView = self.reusedImageViews.first
        
        if let imageView = imageView {
            reusedImageViews.remove(imageView)
        } else {
            imageView = UIImageView()
            imageView?.contentMode = .ScaleAspectFit
            imageView?.clipsToBounds = true
        }
        
        let bounds = scrollView.bounds
        var imageViewFrame = bounds
        imageViewFrame.origin.x = bounds.width * CGFloat(index)
        imageView?.tag = index
        imageView?.frame = imageViewFrame
        
        if let file = chapter.value.files?[index] {
            let url = "http://idx1.hamreus.com:8080\(chapter.value.path)\(file)"
            AppContext.downloader.requestModifier = { request in
                request.addValue(self.chapter.value.origin_url, forHTTPHeaderField: "Referer")
            }
            print(url)
            imageView?.setImageWith(url, cacheTarget: self.imageCache)
        }
        
        visibleImageViews.insert(imageView!)
        scrollView.addSubview(imageView!)
    }
    
    deinit {
        self.imageCache.clearMemoryCache()
    }

}
