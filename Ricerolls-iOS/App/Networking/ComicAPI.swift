//
//  ComicAPI.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/15.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import Foundation
import Moya

enum ComicAPI {
    case List
}

extension ComicAPI: TargetType {
    
    var baseURL: NSURL { return NSURL(string: "http://evertrip.me:3000/api/v1")! }
    
    var path: String {
        switch self {
        default:
            return "/comic"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .GET
        }
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .List:
            return [:]
        }
    }
    
    var sampleData: NSData {
        switch self {
        default:
            return NSData()
        }
    }
    
}