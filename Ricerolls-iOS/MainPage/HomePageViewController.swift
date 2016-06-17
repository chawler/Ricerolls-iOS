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
import Nuke
import SwiftDate

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

class HomePageViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var comics = Variable([Comic]())
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(kCollectionViewItemWidth, kCollectionViewItemHeight)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: CGRectZero, collectionViewLayout: self.flowLayout)
        v.dataSource = self
        v.delegate = self
        return v
    }()
    
    override func config() {
        super.config()
        collectionView.backgroundColor = HexRGB(0xf5f4f0)
        collectionView.registerClass(ComicCell.self, forCellWithReuseIdentifier: kComicCellReuseIdentifier)
        collectionView.contentInset = UIEdgeInsetsMake(0, kCollectionViewInsetLeft, 0, kCollectionViewInsetRight)
        comicProvider.request(.List)
            .filterSuccessfulStatusCodes()
            .mapArray(Comic)
            .bindTo(comics)
            .addDisposableTo(rx_disposeBag)
        
        comics.asDriver()
            .driveNext { _ in
                self.collectionView.reloadData()
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.value.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kComicCellReuseIdentifier, forIndexPath: indexPath) as! ComicCell
        if indexPath.row < comics.listCount {
            let comic = comics.value[indexPath.row]
            cell.titleLabel.text = comic.title
            cell.imageView.nk_setImageWith(NSURL(string: comic.cover_url)!)
            cell.timeLabel.text = comic.updated_at?.toString(DateFormat.Custom("yyyy-MM-dd"))
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < comics.listCount {
            let comic = comics.value[indexPath.row]
            let vc = BookDetailViewController(id: comic.id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
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
