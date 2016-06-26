//
//  ComicViewModel.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/26.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import RxSwift
import Moya


class ComicViewModel: NSObject {
    
    let elements = Variable<[Comic]>([])
    
    let refreshTrigger = PublishSubject<Void>()
    let loadNextPageTrigger = PublishSubject<Void>()
    
    let loading = Variable<Bool>(false)
    let hasNextPage = Variable<Bool>(false)
    let lastLoadedPage = Variable<Int?>(nil)
    
    let error = PublishSubject<ErrorType>()
    
    convenience init(token: ComicAPI) {
        self.init()
        
        let requestRefresh = loading.asObservable()
            .sample(refreshTrigger)
            .flatMap { loading -> Observable<ComicAPI> in
                if loading {
                    return Observable.empty()
                } else {
                    return Observable.just(token)
                }
            }
        
        let nextPageRequest = Observable
            .combineLatest(loading.asObservable(), hasNextPage.asObservable(), lastLoadedPage.asObservable()) { $0 }
            .sample(loadNextPageTrigger)
            .flatMap { loading, hasNextPage, lastLoadedPage -> Observable<ComicAPI> in
                if let page = lastLoadedPage where !loading && hasNextPage {
                    return Observable.just(token.page(page))
                } else {
                    return Observable.empty()
                }
        }
        
        let request = Observable
            .of(requestRefresh, nextPageRequest)
            .merge()
            .shareReplay(1)
        
        let response = request.flatMap { token in
            comicProvider
                .request(token)
                .doOnError({ [weak self] errorType in
                    self?.error.onNext(errorType)
                })
                .catchError({ _ in
                    Observable.empty()
                })
        }
        .shareReplay(1)
        
        Observable
            .of(
                request.map { _ in false },
                response.map { _ in false },
                error.map { _ in false }
            )
            .merge()
            .bindTo(loading)
            .addDisposableTo(rx_disposeBag)
        
        response
            .mapArray(Comic)
            .bindTo(self.elements)
            .addDisposableTo(rx_disposeBag)
        
    }

}
