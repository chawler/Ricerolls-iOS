//
//  Moya-Response+Extra.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/18.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper

public extension Response {
    
    func mapMessagePackJSON() throws -> AnyObject {
        return data.messagePackParse()
    }
    
    /// Maps data received from the signal into an object which implements the Mappable protocol.
    /// If the conversion fails, the signal errors.
    public func mapObject<T: Mappable>() throws -> T {
        guard let object = Mapper<T>().map(try mapMessagePackJSON()) else {
            throw Error.JSONMapping(self)
        }
        return object
    }
    
    /// Maps data received from the signal into an array of objects which implement the Mappable
    /// protocol.
    /// If the conversion fails, the signal errors.
    public func mapArray<T: Mappable>() throws -> [T] {
        guard let objects = Mapper<T>().mapArray(try mapMessagePackJSON()) else {
            throw Error.JSONMapping(self)
        }
        return objects
    }
    
    
}

/// Extension for processing Responses into Mappable objects through ObjectMapper
public extension ObservableType where E == Response {
    
    public func mapMessagePackJSON() -> Observable<AnyObject> {
        return flatMap { response -> Observable<AnyObject> in
            return Observable.just(try response.mapMessagePackJSON())
        }
    }
    
    /// Maps data received from the signal into an object
    /// which implements the Mappable protocol and returns the result back
    /// If the conversion fails, the signal errors.
    public func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject())
        }
    }
    
    /// Maps data received from the signal into an array of objects
    /// which implement the Mappable protocol and returns the result back
    /// If the conversion fails, the signal errors.
    public func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray())
        }
    }
}

extension Endpoint {
    public var cacheUrlRequest: NSURLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: URL)!, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 15)
        request.HTTPMethod = method.rawValue
        request.allHTTPHeaderFields = httpHeaderFields
        request.addValue("private", forHTTPHeaderField: "Cache-Control")
        
        return parameterEncoding.encode(request, parameters: parameters).0
    }
}

public extension MoyaProvider {
    
    // These functions are default mappings to MoyaProvider's properties: endpoints, requests, manager, etc.
    
    public final class func CacheRequestMapping(endpoint: Endpoint<Target>, closure: NSURLRequest -> Void) {
        return closure(endpoint.cacheUrlRequest)
    }
    
    public final class func CacheAlamofireManager() -> Manager {
        let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
//        configuration.requestCachePolicy = .ReturnCacheDataElseLoad
        
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        return manager
    }
}