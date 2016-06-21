//
//  UINavigation+Custom.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/22.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import Foundation
import UIKit

private var kCustomBackButtonKey: Void?

extension UINavigationItem {
    
    public override class func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        if self !== UINavigationItem.self {
            return
        }
        
        dispatch_once(&Static.token) {
            
            let originalSelector = Selector("backBarButtonItem")
            let swizzledSelector = Selector("my_backBarButtonItem")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
        
    }
    
    var my_backBarButtonItem: UIBarButtonItem? {
        var item = self.my_backBarButtonItem
        if item != nil {
            return item
        }
        item = objc_getAssociatedObject(self, &kCustomBackButtonKey) as? UIBarButtonItem
        if item == nil {
            item = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
            item?.setBackgroundVerticalPositionAdjustment(10, forBarMetrics: .Default)
            objc_setAssociatedObject(self, &kCustomBackButtonKey, item, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return item
    }
    
}