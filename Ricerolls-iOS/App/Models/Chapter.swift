//
//  Chapter.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/19.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import ObjectMapper

public class kFilesTransform: TransformType {
    public typealias Object = [String]
    public typealias JSON = String
    
//    public init(dateFormatter: NSDateFormatter) {
//        self.dateFormatter = dateFormatter
//    }
    
    public func transformFromJSON(value: AnyObject?) -> [String]? {
        if let filesString = value as? NSString {
            let data = filesString.dataUsingEncoding(NSUTF8StringEncoding)
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String] {
                    return json
                }
            } catch {
                return [String]()
            }
        }
        return nil
    }
    
    public func transformToJSON(value: [String]?) -> String? {
//        if let date = value {
//            
//        }
        return nil
    }
}

class Chapter: Mappable {
    
    var id = 0
    var index = 0
    var pages = 0
    var name = ""
    var path = ""
    var origin_url = ""
    var files: [String]?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        pages <- map["pages"]
        index <- map["index"]
        name <- map["name"]
        path <- map["path"]
        origin_url <- map["origin_url"]
        files <- (map["files"], kFilesTransform())
    }

}
