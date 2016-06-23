//
//  Networking.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/17.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import Foundation
import Moya
import Result

private struct CancellableWrapper: Cancellable {
    
    private var isCancelled = false
    
    func cancel() {
        
    }
}

class MyMoyaProvider<Target where Target : TargetType> : RxMoyaProvider<Target> {
    
    override init(endpointClosure: EndpointClosure = MoyaProvider.DefaultEndpointMapping,
                         requestClosure: RequestClosure = MoyaProvider.DefaultRequestMapping,
                         stubClosure: StubClosure = MoyaProvider.NeverStub,
                         manager: Manager = RxMoyaProvider<Target>.DefaultAlamofireManager(),
                         plugins: [PluginType] = []) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins)
    }
    
    override func request(target: Target, completion: Completion) -> Cancellable {
        if let cacheResponse = NSURLCache.sharedURLCache().cachedResponseForRequest(self.endpoint(target).urlRequest) {
            if let urlResponse = cacheResponse.response as? NSHTTPURLResponse {
                let result = convertResponseToResult(urlResponse, data: cacheResponse.data, error: nil)
                completion(result: result)
                return CancellableWrapper()
            }
            
        }
        return super.request(target, completion: completion)
    }
    
}

let comicProvider = RxMoyaProvider<ComicAPI>(
    plugins: [NetworkLogger(verbose: false)]
)

