//
//  Chapter.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/19.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import ObjectMapper

class Chapter: Mappable {
    
    var id = 0
    var index = 0
    var name = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
//        updated_at <- (map["updated_at"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"))
        index <- map["index"]
        name <- map["name"]
    }

}
