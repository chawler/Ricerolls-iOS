//
//  TabBarController.swift
//  Ricerolls-iOS
//
//  Created by Chawler on 16/6/15.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import UIKit
import CYLTabBarController

class TabBarController: CYLTabBarController {
    
    let firstViewController: UINavigationController = {
        return UINavigationController(rootViewController: HomePageViewController())
    }()
    
    let secondViewController: UINavigationController = {
        return UINavigationController(rootViewController: BookShelfViewController())
    }()
    
    let itemAttrs: [[NSObject:AnyObject]] = [
        [
            CYLTabBarItemTitle: R.string.genernal.homePage()
        ],
        [
            CYLTabBarItemTitle: R.string.genernal.bookShelf()
        ]
    ]
    
    override func loadView() {
        self.tabBarItemsAttributes = itemAttrs
        self.viewControllers = [firstViewController, secondViewController]
        super.loadView()
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
