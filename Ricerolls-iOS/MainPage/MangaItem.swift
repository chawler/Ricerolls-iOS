//
//  MangaItem.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/25.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import RxSwift

class MangaItem {
    
    private(set) var index = 0
    private(set) var url = ""
    
    var preItem: MangaItem?
    var nextItem: MangaItem?
    
    init(url: String, index: Int) {
        self.url = url
        self.index = index
    }
    
//    func request() -> Observable<UIImage> {
//        return Observable.create { observer -> Disposable in
//            
//            
//            
//        }
//    }

}
