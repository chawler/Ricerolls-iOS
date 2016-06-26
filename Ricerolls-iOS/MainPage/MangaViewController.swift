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
    
    var mangaBrowser: MangaBrowser?
    
    override func setupViews() {
        super.setupViews()
//        self.view.addSubview(scrollView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let variable = Variable(Chapter())
        UITextField().rx_text
        comicProvider.request(.Chapter(comicId: MangaViewModel.comicId,
                                            id: MangaViewModel.selectedChapter!.id))
            .filterSuccessfulStatusCodes()
            .mapObject(Chapter)
//            .asObservable()
//            .bindTo(self.mangaBrowser!.collectionView.rx_itemsWithCellIdentifier(kMangaCollectionViewCell, cellType: MangaCollectionViewCell.self))  { (row, element, cell) in
//                cell.textLabel?.text = "\(element) @ row \(row)"
//            }
            .bindTo(variable)
            .addDisposableTo(rx_disposeBag)
        
        _ = variable.asObservable()
//        chapter.asDriver()
            .filter({ chapter -> Bool in
                chapter.id > 0
            })
            .subscribe(onNext: { chapter in
                
                print(chapter)
                
                mangaManager.generateItems(chapter)
                
                self.mangaBrowser = MangaBrowser(chapter: chapter)
                self.view.addSubview(self.mangaBrowser!.collectionView)
                self.mangaBrowser!.collectionView.snp_makeConstraints(closure: { (make) in
                    make.edges.equalTo(self.view)
                })
                
            }, onCompleted: {
                
                print("onCompleted:\(variable)")
                    
            })
//            .subscribeNext({ chapter in
//                
//                
//                
//            })
//            .drive(onNext: { chapter in
//                
//                
//                
//                }, onCompleted: nil, onDisposed: {
//                
//            })
//            .addDisposableTo(rx_disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {

        print("deinit")
        
    }

}
