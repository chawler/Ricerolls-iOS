//
//  ComicDetailViewModel.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/28.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class ComicDetailViewModel: BaseViewModel<ComicAPI> {
    
    let comic = Variable<Comic>(Comic())
    let chapters = Variable<[Chapter]>([])
    
    convenience init(comic_id: Int) {
        self.init(token: .Detail(id: comic_id))
    }
    
    override func responseBindTo(response: Observable<Response>) {
        
        response
            .mapObject(Comic)
            .bindTo(comic)
            .addDisposableTo(rx_disposeBag)
        
        response
            .mapObject(Comic)
            .map { comic -> [Chapter] in
                comic.chapters
            }
            .bindTo(chapters)
            .addDisposableTo(rx_disposeBag)
        
    }
    
}
