//
//  HomePageViewController.swift
//  Ricerolls-iOS
//
//  Created by Chawler on 16/6/15.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import SnapKit
import SwiftDate
import RxDataSources

private let kComicCellReuseIdentifier = "kComicCellReuseIdentifier"
private let kCollectionViewItemHeight = kDeviceWidth/2
private let kCollectionViewItemWidth = kCollectionViewItemHeight * 0.55
private let kCollectionViewInsetLeft = (kDeviceWidth-kCollectionViewItemWidth*3)/4
private let kCollectionViewInsetRight = kCollectionViewInsetLeft

struct ComicSection {
    var header: String
    var items: [Item]
}

extension ComicSection: AnimatableSectionModelType {
    
    typealias Item = Comic
    
    var identity: String {
        return header
    }
    
    init(original: ComicSection, items: [Item]) {
        self = original
        self.items = items
    }
}

extension Comic : IdentifiableType {
    
    internal typealias Identity = Int
    
    internal var identity : Int {
        return self.id
    }
}

class HomePageViewController: BaseViewController, UICollectionViewDelegateFlowLayout {
    
    let viewModel = ComicViewModel(token: .List)
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(kCollectionViewItemWidth, kCollectionViewItemHeight)
        layout.sectionInset.left = kCollectionViewInsetLeft
        layout.sectionInset.right = kCollectionViewInsetRight
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: CGRectZero, collectionViewLayout: self.flowLayout)
        return v
    }()
    
    override func loadView() {
        rx_sentMessage(#selector(UIViewController.viewDidLoad))
            .map { _ in () }
            .bindTo(viewModel.refreshTrigger)
            .addDisposableTo(rx_disposeBag)
        super.loadView()
    }
    
    override func config() {
        super.config()
        
        collectionView.backgroundColor = HexRGB(0xf5f4f0)
        collectionView.registerClass(ComicCell.self, forCellWithReuseIdentifier: kComicCellReuseIdentifier)
        collectionView.rx_setDelegate(self)
        collectionView.rx_refreshHeader
            .bindTo(viewModel.refreshTrigger)
            .addDisposableTo(rx_disposeBag)
        
        collectionView.rx_modelSelected(Comic)
            .subscribeNext { comic in
                let vc = BookDetailViewController()
                vc.viewModel = ComicDetailViewModel(comic_id: comic.id)
                self.pushControllerHideBottomBar(vc)
            }
            .addDisposableTo(rx_disposeBag)
        
        viewModel.elements.asObservable()
            .map { _ in () }
            .bindTo(collectionView.rx_endRefreshing)
            .addDisposableTo(rx_disposeBag)
        
        viewModel.elements.asDriver()
            .drive(collectionView.rx_itemsWithCellIdentifier(kComicCellReuseIdentifier, cellType: ComicCell.self)){ (_, comic, cell) in
                cell.titleLabel.text = comic.title
                cell.imageView.setImageWith(comic.cover_url)
                runAsyncOnBackground({
                    let dateString = comic.updated_at?.toString(DateFormat.Custom("yyyy-MM-dd"))
                    runAsyncOnMain({
                        cell.timeLabel.text = dateString
                    })
                })
            }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
