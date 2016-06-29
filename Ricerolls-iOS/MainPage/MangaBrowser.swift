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

class MangaBrowser: NSObject {
    
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
        collectionView.pagingEnabled = true
        return collectionView
    }()
    
//    init(chapter: Chapter) {
//        self.chapter = chapter
//        super.init()
//        self.collectionView.registerClass(MangaCollectionViewCell.self, forCellWithReuseIdentifier: kMangaCollectionViewCell)
//        AppContext.downloader.requestModifier = { request in
//            request.addValue(chapter.origin_url, forHTTPHeaderField: "Referer")
//        }
//    }
    
    override init() {
        super.init()
        self.collectionView.registerClass(MangaCollectionViewCell.self, forCellWithReuseIdentifier: kMangaCollectionViewCell)
    }
    
    deinit {
        
    }
    
}

//extension MangaBrowser: UICollectionViewDataSource {
//    
//    var dataSource: Array<MangaItem>? {
//        return mangaManager.dataSource[chapter]
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let obj = dataSource {
//            return obj.count
//        }
//        return 0
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kMangaCollectionViewCell, forIndexPath: indexPath) as! MangaCollectionViewCell
//        if let obj = dataSource {
//            let item = obj[indexPath.row]
//            cell.imageView.setImageWith(item.url, cacheTarget: imageCache)
//        }
//        return cell
//    }
//    
//}
//
//extension MangaBrowser: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSizeMake(kDeviceWidth, kDeviceHeight)
//    }
//}
