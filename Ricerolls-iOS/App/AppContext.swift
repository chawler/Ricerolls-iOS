//
//  AppContext.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/21.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import Kingfisher

class AppContext {
    
    static let mangaManager: KingfisherManager = {
        let downloader = ImageDownloader(name: "manga")
        let cache = ImageCache(name: "manga")
        let manager = KingfisherManager()
        manager.downloader = downloader
        manager.cache = cache
        return manager
    }()

}
