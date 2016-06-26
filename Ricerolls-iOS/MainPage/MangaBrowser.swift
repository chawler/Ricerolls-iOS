//
//  MangaBrowser.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/25.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import Kingfisher
import RxDataSources

let kMangaCollectionViewCell = "MangaCollectionViewCell"

class MangaCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
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
        self.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MangaBrowser: NSObject {
    
    var chapter: Chapter
    
    lazy var imageCache: ImageCache = {
        let name = "\(self.chapter.id)"
        let cache: ImageCache = ImageCache(name: name, path: (CACHE_FOLDER as NSString).stringByAppendingPathComponent("chapters"))
        cache.maxMemoryCost = 30
        return cache
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsZero
        layout.scrollDirection = .Horizontal
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.pagingEnabled = true
        return collectionView
    }()
    
    init(chapter: Chapter) {
        self.chapter = chapter
        super.init()
        self.collectionView.registerClass(MangaCollectionViewCell.self, forCellWithReuseIdentifier: kMangaCollectionViewCell)
        AppContext.downloader.requestModifier = { request in
            request.addValue(chapter.origin_url, forHTTPHeaderField: "Referer")
        }
    }
    
    deinit {
        
        self.imageCache.clearMemoryCache()
        
    }
    
}

extension MangaBrowser: UICollectionViewDataSource {
    
    var dataSource: Array<MangaItem>? {
        return mangaManager.dataSource[chapter]
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let obj = dataSource {
            return obj.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kMangaCollectionViewCell, forIndexPath: indexPath) as! MangaCollectionViewCell
        if let obj = dataSource {
            let item = obj[indexPath.row]
            cell.imageView.setImageWith(item.url, cacheTarget: imageCache)
        }
        return cell
    }
    
}

extension MangaBrowser: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(kDeviceWidth, kDeviceHeight)
    }
}
