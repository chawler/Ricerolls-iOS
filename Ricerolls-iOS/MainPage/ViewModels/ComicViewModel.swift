//
//  ComicViewModel.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/26.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import RxSwift
import Moya


class ComicViewModel: NSObject {
    
    let elements = Variable<[Comic]>([])
    let refreshTrigger = PublishSubject<Void>()
    
    convenience init(token: ComicAPI) {
        self.init()
        comicProvider.request(.List)
            .filterSuccessfulStatusCodes()
            .mapArray(Comic)
        

    }

}
