//
//  MangaItem.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/25.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import RxDataSources

class MangaItem: NSObject {
    
    private(set) var index = 0
    private(set) var url = ""
    
    var preItem: MangaItem?
    var nextItem: MangaItem?
    
    init(url: String, index: Int) {
        self.url = url
        self.index = index
    }

}


extension MangaItem : IdentifiableType {
    
    internal typealias Identity = Int
    
    internal var identity : Int {
        return self.index
    }
}