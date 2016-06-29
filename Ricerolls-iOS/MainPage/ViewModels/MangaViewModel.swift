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
import ObjectMapper
import Kingfisher

class MangaViewModel: BaseViewModel<ComicAPI> {
    
    let secions = Variable<[ChapterSection]>([])
    
    var comic: Comic!
    
    var currentChapter: Chapter!
    
    lazy var imageCache: ImageCache = {
        let name = "\(self.currentChapter.id)"
        let cache: ImageCache = ImageCache(name: name, path: (CACHE_FOLDER as NSString).stringByAppendingPathComponent("chapters"))
        cache.maxMemoryCost = 30
        return cache
    }()
    
    convenience init(comic: Comic) {
        self.init()
        self.comic = comic
    }
    
    func loadCurrentChapter() {
        
        self.loadChapter(currentChapter)
        
    }
    
    func loadChapter(chapter: Chapter) {
        
        let resposne = requestTarget(.Chapter(comicId: comic.id, id: chapter.id))
        
        let element = resposne
            .mapMessagePackJSON()
            .map({ json -> ChapterSection in
                let map = Map(mappingType: .FromJSON, JSONDictionary: json as! [String : AnyObject])
                chapter.mapping(map)
                mangaManager.generateItems(chapter)
                return ChapterSection(header: chapter.name, items: mangaManager.dataSource[chapter]!)
            })
        
        Observable
            .combineLatest(element, secions.asObservable()) { secion, secions in
                return secions + [secion]
            }
            .sample(resposne)
            .bindTo(secions)
            .addDisposableTo(rx_disposeBag)
    }
    
    deinit {
        
        self.imageCache.clearMemoryCache()
        
    }

}
