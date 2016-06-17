//
//  Networking.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/17.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import Foundation
import Moya
import Moya_ObjectMapper

let comicProvider = RxMoyaProvider<ComicAPI>(plugins: [NetworkLogger(verbose: false)])