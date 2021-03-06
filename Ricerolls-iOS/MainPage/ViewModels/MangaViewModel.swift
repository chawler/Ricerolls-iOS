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
    
    var secions: Variable<[ChapterSection]>?
    
    var comic: Comic?
    
    var currentChapter: Chapter?
    
    lazy var imageCache: ImageCache = {
        guard let currentChapter = self.currentChapter else {
            return KingfisherManager.sharedManager.cache
        }
        let name = "\(currentChapter.id)"
        let cache: ImageCache = ImageCache(name: name, path: (CACHE_FOLDER as NSString).stringByAppendingPathComponent("chapters"))
        cache.maxMemoryCost = 30
        return cache
    }()
    
    convenience init(comic: Comic) {
        self.init()
        self.comic = comic
        self.secions = Variable<[ChapterSection]>([])
    }
    
    func loadCurrentChapter() {
        
        if let currentChapter = self.currentChapter {
            
            self.loadChapter(currentChapter)
            
            AppContext.downloader.requestModifier = { request in
                request.addValue(currentChapter.origin_url, forHTTPHeaderField: "Referer")
            }
            
        }
        
    }
    
    func loadChapter(chapter: Chapter) {
        
        guard let comic = self.comic else {
            return
        }
        
        guard let secions = self.secions else {
            return
        }
        
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
