//
//  BaseViewModel.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/27.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class BaseViewModel<Target where Target : TargetType>: NSObject {
    
    let refreshTrigger = PublishSubject<Void>()
    
    let loading = Variable<Bool>(false)
    
    let provider = RxMoyaProvider<Target>(plugins: [NetworkLogger(verbose: false)])
    
    let error = PublishSubject<ErrorType>()
    
    convenience init(token: Target) {
        self.init()
        let request = loading.asObservable()
            .sample(refreshTrigger)
            .flatMap { flag -> Observable<Target> in
                if flag {
                    return Observable.empty()
                } else {
                    return Observable.just(token)
                }
            }.shareReplay(1)
        
        
        let response = request.flatMap { target -> Observable<Response> in
            self.provider
                .request(target)
                .doOnError({ [weak self] errorType in
                    self?.error.onNext(errorType)
                    })
                .catchError({ _ in
                    Observable.empty()
                })
        }.shareReplay(1)
        
        Observable
            .of(
                request.map { _ in true },
                response.map { _ in false },
                error.map { _ in false }
            )
            .merge()
            .bindTo(loading)
            .addDisposableTo(rx_disposeBag)
        
        responseBindTo(response)
    }
    
    func responseBindTo(response: Observable<Response>) {
        
    }

}
