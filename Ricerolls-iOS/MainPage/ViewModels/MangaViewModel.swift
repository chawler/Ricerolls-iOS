//
//  MangaViewModel.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/20.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class MangaViewModel: BaseViewModel<ComicAPI> {
    
    static var comic = Variable(Comic())
    static var selectedIndex = 0
    
    let element = Variable<Comic>(Comic())
    
    convenience init(comic_id: Int) {
        self.init(token: .Detail(id: comic_id))
    }
    
    override func responseBindTo(response: Observable<Response>) {
        
        response
            .mapObject(Comic)
            .bindTo(element)
            .addDisposableTo(rx_disposeBag)
        
    }
    
    static var comicId: Int {
        return comic.value.id
    }
    
    static var chapters: [Chapter] {
        return comic.value.chapters
    }
    
    static var selectedChapter: Chapter? {
        if selectedIndex < chapters.count {
            return chapters[selectedIndex]
        }
        return nil
    }

}
