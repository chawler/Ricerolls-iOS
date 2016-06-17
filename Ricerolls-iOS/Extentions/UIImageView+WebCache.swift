//
//  UIImageView+WebCache.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/17.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import Foundation
import Nuke

extension UIImageView {
    
    func setImageWith(urlString: String) {
        self.nk_setImageWith(NSURL(string: urlString)!)
    }
    
}
