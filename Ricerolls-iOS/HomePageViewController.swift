//
//  HomePageViewController.swift
//  Ricerolls-iOS
//
//  Created by Chawler on 16/6/15.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import NSObject_Rx
import Moya_ObjectMapper

class HomePageViewController: BaseViewController {
    
    let provider = RxMoyaProvider<ComicAPI>()
    lazy var collectionView: UICollectionView = {
        let v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        provider.request(.List)
            .filterSuccessfulStatusCodes()
            .mapArray(Comic)
            .subscribeNext { comics in
                print(comics)
            }
            .addDisposableTo(rx_disposeBag)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
