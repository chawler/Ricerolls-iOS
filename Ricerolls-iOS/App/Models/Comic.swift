//
//  Comic.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/15.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import ObjectMapper

class Comic: Mappable {
    
    var id = 0
    var updated_at: NSDate?
    var cover_url = ""
    var title = ""
    var author = ""
    var intro = ""
    var tags: [String] = []
    var updated_info = ""
    var chapters: [Chapter]?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        updated_at <- (map["updated_at"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"))
        cover_url <- map["cover_url"]
        title <- map["title"]
        author <- map["author"]
        intro <- map["intro"]
        tags <- map["tags"]
        chapters <- map["chapters"]
        updated_info <- map["updated_info"]
    }

}

extension Comic: Hashable {
    
    var hashValue: Int {
        return self.id
    }
    
}

func ==(lhs: Comic, rhs: Comic) -> Bool {
    return lhs.id == lhs.id
}