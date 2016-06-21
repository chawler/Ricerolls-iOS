//
//  MangaViewModel.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/20.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import RxSwift

class MangaViewModel {
    
    static var comic = Variable(Comic())
    static var selectedIndex = 0
    
    static var comicId: Int {
        return comic.value.id
    }
    
    static var chapters: [Chapter] {
        if let chapters = comic.value.chapters {
            return chapters
        }
        return [Chapter]()
    }
    
    static var selectedChapter: Chapter? {
        if selectedIndex < chapters.count {
            return chapters[selectedIndex]
        }
        return nil
    }

}
