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

internal extension Variable {
    
    var listCount: Int {
        get {
            if let list = self.value as? [Comic] {
                return list.count
            }
            return 0
        }
    }
    
}

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

class HomePageViewController: BaseViewController {
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(kCollectionViewItemWidth, kCollectionViewItemHeight)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: CGRectZero, collectionViewLayout: self.flowLayout)
        return v
    }()
    
    override func config() {
        super.config()
        
        collectionView.backgroundColor = HexRGB(0xf5f4f0)
        collectionView.registerClass(ComicCell.self, forCellWithReuseIdentifier: kComicCellReuseIdentifier)
        collectionView.contentInset = UIEdgeInsetsMake(0, kCollectionViewInsetLeft, 0, kCollectionViewInsetRight)
        
        collectionView.rx_modelSelected(Comic)
            .subscribeNext { comic in
                let vc = BookDetailViewController(id: comic.id)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .addDisposableTo(rx_disposeBag)
        
        comicProvider.request(.List)
            .filterSuccessfulStatusCodes()
            .mapArray(Comic)
//            .map({ comics -> [ComicSection] in
//                var secions = [ComicSection]()
//                secions.append(ComicSection(header: "First Section", items: comics))
//                return secions
//            })
            .bindTo(collectionView.rx_itemsWithCellIdentifier(kComicCellReuseIdentifier, cellType: ComicCell.self)) { (_, comic, cell) in
                cell.imageView.setImageWith(comic.cover_url)
                runAsyncOnBackground({
                    let dateString = comic.updated_at?.toString(DateFormat.Custom("yyyy-MM-dd"))
                    runAsyncOnMain({
                        cell.timeLabel.text = dateString
                    })
                })
            }
//            .bindTo(collectionView.rx_itemsWithDataSource(dataSource))
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
