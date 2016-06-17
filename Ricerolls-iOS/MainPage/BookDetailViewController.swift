//
//  BookDetailViewController.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/17.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import RxSwift

class BookDetailViewController: BaseViewController {
    
    var id: Int = 0
    var comic = Variable(Comic())
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(id: Int) {
        self.init(nibName: nil, bundle: nil)
        self.id = id
    }
    
    override func config() {
        super.config()
        comicProvider.request(.Detail(id: self.id))
            .filterSuccessfulStatusCodes()
            .mapObject(Comic)
            .bindTo(comic)
            .addDisposableTo(rx_disposeBag)
        
        comic.asDriver()
            .filter({ comic -> Bool in
                return comic.id != 0
            })
            .driveNext { comic in
                print(comic)
            }
            .addDisposableTo(rx_disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
