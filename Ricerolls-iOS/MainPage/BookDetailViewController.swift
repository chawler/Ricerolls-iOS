//
//  BookDetailViewController.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/17.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

private let kCollectionViewItemWidth = kDeviceWidth * 0.27
private let kCollectionViewItemHeight: CGFloat = 44
private let kComicHeaderReuseIdentifier = "kComicHeaderReuseIdentifier"
private let kChapterCellReuseIdentifier = "kChapterCellReuseIdentifier"

class BookDetailViewController: BaseViewController {
    
    var id: Int = 0
    
    var viewModel: ComicDetailViewModel?
    
    var topConstraint: Constraint? = nil
    var heightConstraint: Constraint? = nil
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(kCollectionViewItemWidth, kCollectionViewItemHeight)
        layout.headerReferenceSize = CGSizeMake(kDeviceWidth, kDeviceHeight*0.35)
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16)
        return layout
    }()
    
    let headerView = ComicHeaderView()
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: CGRectZero, collectionViewLayout: self.flowLayout)
        return v
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(id: Int) {
        self.init(nibName: nil, bundle: nil)
        self.id = id
    }
    
    override func config() {
        super.config()
        navBarHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        collectionView.backgroundColor = HexRGB(0xf5f4f0)
        collectionView.registerClass(ChapterCell.self, forCellWithReuseIdentifier: kChapterCellReuseIdentifier)
        
        if let viewModel = self.viewModel {
            
            viewModel.comic
                .asDriver()
                .drive(headerView.rx_data)
                .addDisposableTo(rx_disposeBag)
            
            viewModel.chapters
                .asDriver()
                .drive(collectionView.rx_itemsWithCellIdentifier(kChapterCellReuseIdentifier, cellType: ChapterCell.self)) {(row, chapter, cell) in
                    
                    if chapter.index == 0 {
                        cell.titleLabel.text = chapter.name
                    } else {
                        cell.titleLabel.text = "\(chapter.index)"
                    }
                    
                }.addDisposableTo(rx_disposeBag)
            
        }
        
        collectionView.rx_modelSelected(Chapter)
            .subscribeNext { [weak self] chapter in
                
                self?.pushControllerHideBottomBar(MangaViewController())
                
            }
            .addDisposableTo(rx_disposeBag)
        
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubviews(
            [
                collectionView
            ]
        )
        collectionView.addSubview(headerView)
    }
    
    override func autolayout() {
        super.autolayout()
        collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        headerView.snp_makeConstraints { (make) in
            self.topConstraint = make.top.equalTo(collectionView).constraint
            make.left.equalTo(collectionView)
            make.width.equalTo(collectionView)
            self.heightConstraint = make.height.equalTo(collectionView).multipliedBy(0.35).constraint
        }
    }
    
    override func loadView() {
        super.loadView()
        rx_sentMessage(#selector(UIViewController.viewDidLoad))
            .map { _ in () }
            .bindTo(viewModel!.refreshTrigger)
            .addDisposableTo(rx_disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 {
            if let constraint = self.topConstraint {
                constraint.updateOffset(offsetY)
            }
            if let constraint = self.heightConstraint {
                constraint.updateOffset(-offsetY)
            }
        }
    }

    deinit {
        
        print("deinit: \(self)")
        
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
