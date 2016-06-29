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
import RxDataSources

struct ChapterSection {
    var header: String
    var items: [Item]
}

extension ChapterSection: AnimatableSectionModelType {
    
    typealias Item = MangaItem
    
    var identity: String {
        return header
    }
    
    init(original: ChapterSection, items: [Item]) {
        self = original
        self.items = items
    }
}

class MangaViewController: BaseViewController, UIScrollViewDelegate {
    
    var mangaBrowser: MangaBrowser?
    var viewModel: MangaViewModel!
    
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
    
    override func config() {
        super.config()
        
        collectionView.registerClass(MangaCollectionViewCell.self, forCellWithReuseIdentifier: kMangaCollectionViewCell)
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<ChapterSection>()
        dataSource.cellFactory = { (ds, cv, ip, item: MangaItem) in
            let cell = cv.dequeueReusableCellWithReuseIdentifier(kMangaCollectionViewCell, forIndexPath: ip) as! MangaCollectionViewCell
            cell.imageView.setImageWith(item.url, cacheTarget: self.viewModel.imageCache)
            return cell
        }
        
        viewModel.secions
            .asDriver()
            .drive(collectionView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(rx_disposeBag)
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(collectionView)
    }
    
    override func autolayout() {
        super.autolayout()
        collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.loadCurrentChapter()
        self.viewModel.refreshTrigger.onNext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {

        print("deinit")
        
    }

}
