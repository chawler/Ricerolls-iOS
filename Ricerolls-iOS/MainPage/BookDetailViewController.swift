//
//  BookDetailViewController.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/17.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import RxSwift
import Nuke

class BookDetailViewController: BaseViewController {
    
    var id: Int = 0
    var comic = Variable(Comic())
    
    let headerBackground = ADBlurImageView()
    lazy var coverImageView: UIImageView = {
        let civ = UIImageView()
        civ.clipsToBounds = true
        civ.contentMode = .ScaleAspectFill
        return civ
    }()
    let headerView = ComicHeaderView()
    
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
        navBarHidden = true
        comicProvider.request(.Detail(id: self.id))
            .filterSuccessfulStatusCodes()
            .mapObject(Comic)
            .bindTo(comic)
            .addDisposableTo(rx_disposeBag)
        
        comic.asDriver()
            .filter({ comic -> Bool in
                return comic.id != 0
            })
            .driveNext { [weak self] comic in
                print(comic)
                self?.headerView.background.setImageWith(comic.cover_url)
                self?.headerView.coverView.setImageWith(comic.cover_url)
                self?.headerView.setupTags(comic.tags)
                self?.headerView.titleLabel.text = comic.title
                self?.headerView.authorLabel.text = comic.author
            }
            .addDisposableTo(rx_disposeBag)
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubviews(
            [
                headerView
            ]
        )
    }
    
    override func autolayout() {
        super.autolayout()
        headerView.snp_makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(self.view).multipliedBy(0.35)
        }
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
