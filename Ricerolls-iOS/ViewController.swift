//
//  ViewController.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/15.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {
    
    let provider = MoyaProvider<ComicAPI>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        provider.request(.List) { result in
            switch result {
            case let .Success(moyaResponse):
                do {
                    let json = try moyaResponse.mapJSON()
                    print(json)
                } catch {
                    print("error")
                }
            case .Failure(let error):
                print(error)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

