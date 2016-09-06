//
//  MangaManager.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/25.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit

private let kChinaNet = "http://idx2.hamreus.com:8080"
private let kChinaUnicom = ""

typealias MangaObject = [Chapter: Array<MangaItem>]

let mangaManager = MangaManager()

class MangaManager {
    
    private(set) var dataSource = MangaObject()
    
    var currentItem: MangaItem?
    
    func generateItems(chapter: Chapter) {
        
        var items = Array<MangaItem>()
        chapter.files?.forEach({ file in
            
            let lastItem = items.last
            let item = MangaItem(url: "\(kChinaNet)\(chapter.path)\(file)", index: items.count)
            lastItem?.nextItem = item
            item.preItem = lastItem
            items.append(item)
            
        })
        currentItem = items.first
        dataSource[chapter] = items
    }

}
