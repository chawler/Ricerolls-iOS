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
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        updated_at <- (map["updated_at"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"))
        cover_url <- map["cover_url"]
        title <- map["title"]
    }

}
