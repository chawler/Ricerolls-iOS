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

class MangaViewController: BaseViewController, UICollectionViewDelegateFlowLayout {
    
    var viewModel: MangaViewModel?
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsZero
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(kDeviceWidth, kDeviceHeight)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.flowLayout)
        collectionView.pagingEnabled = true
        return collectionView
    }()
    
    override func config() {
        super.config()
        
        automaticallyAdjustsScrollViewInsets = false
        collectionView.registerClass(MangaCollectionViewCell.self, forCellWithReuseIdentifier: kMangaCollectionViewCell)
        
        if let viewModel = self.viewModel {
            let dataSource = RxCollectionViewSectionedAnimatedDataSource<ChapterSection>()
            dataSource.cellFactory = { (ds, cv, ip, item: MangaItem) in
                let cell = cv.dequeueReusableCellWithReuseIdentifier(kMangaCollectionViewCell, forIndexPath: ip) as! MangaCollectionViewCell
                cell.imageView.setImageWith(item.url, cacheTarget: viewModel.imageCache)
                cell.reset()
                return cell
            }
            
            viewModel.secions!
                .asDriver()
                .drive(collectionView.rx_itemsWithDataSource(dataSource))
                .addDisposableTo(rx_disposeBag)
        }
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
        if let viewModel = self.viewModel {
            viewModel.loadCurrentChapter()
            viewModel.refreshTrigger.onNext()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {

        print("deinit \(self)")
        self.viewModel?.rx_disposeBag = DisposeBag()
        
    }

}
