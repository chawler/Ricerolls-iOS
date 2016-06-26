//
//  UIView+Utils.swift
//  Shepherd-iOS
//
//  Created by Chawler on 16/5/16.
//  Copyright © 2016年 tentchong. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

private var JhwActionHandlerTargetBlockKey: UInt8 = 0
private var JhwActionHandlerTapGestureKey: UInt8 = 1

typealias JhwViewUIButtonClosure = @convention(block) (UIButton) -> ()
typealias JhwViewGestureClosure = @convention(block) (UIGestureRecognizer) -> ()

extension UIView {
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set (newX) {
            var rect = self.frame
            rect.origin.x = newX
            self.frame = rect
        }
    }
    
    var xWidth: CGFloat {
        get {
            return self.x + self.width
        }
    }
    
    var yHeight: CGFloat {
        get {
            return self.y + self.height
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set (newY) {
            var rect = self.frame
            rect.origin.y = newY
            self.frame = rect
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set (newWidth) {
            var rect = self.frame
            rect.size.width = newWidth
            self.frame = rect
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set (newHeight) {
            var rect = self.frame
            rect.size.height = newHeight
            self.frame = rect
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set (newSize) {
            var rect = self.frame
            rect.size.width = newSize.width
            rect.size.height = newSize.height
            self.frame = rect
        }
    }
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set (newOrigin) {
            var rect = self.frame
            rect.origin.x = newOrigin.x
            rect.origin.y = newOrigin.y
            self.frame = rect
        }
    }
    
    var gesture: UIGestureRecognizer {
        get {
            if let ges = objc_getAssociatedObject(self, &JhwActionHandlerTapGestureKey) as? UIGestureRecognizer {
                return ges
            }
            return UIGestureRecognizer()
        }
    }
    
    func addSubviews(views: NSArray) {
        for v in views {
            self.addSubview(v as! UIView)
        }
    }
    
    func addTargetActionWithClosure(closure: JhwViewUIButtonClosure) {
        
        if let btn = self as? UIButton {
            
            btn.addTarget(self, action: #selector(__handleActionForTarget(_:)), forControlEvents: .TouchUpInside)
            
            let dealObject: AnyObject = unsafeBitCast(closure, AnyObject.self)
            
            objc_setAssociatedObject(self, &JhwActionHandlerTargetBlockKey, dealObject, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    func __handleActionForTarget(sender: UIButton) {
        if let closureObject: AnyObject = objc_getAssociatedObject(self, &JhwActionHandlerTargetBlockKey) {
            let closure = unsafeBitCast(closureObject, JhwViewUIButtonClosure.self)
            closure(sender)
        }
    }
    
    func addTapActionWithClosure(closure: JhwViewGestureClosure) {
        self.userInteractionEnabled = true
        if let gesture = objc_getAssociatedObject(self, &JhwActionHandlerTapGestureKey) as? UITapGestureRecognizer {
            objc_setAssociatedObject(self, &JhwActionHandlerTapGestureKey, gesture, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } else {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(__handleActionForTapGesture(_:)))
            gesture.numberOfTapsRequired = 1
            gesture.numberOfTouchesRequired = 1
            self.addGestureRecognizer(gesture)
            objc_setAssociatedObject(self, &JhwActionHandlerTapGestureKey, gesture, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        let dealObject: AnyObject = unsafeBitCast(closure, AnyObject.self)
        objc_setAssociatedObject(self, &JhwActionHandlerTargetBlockKey, dealObject, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    func __handleActionForTapGesture(gesture: UIGestureRecognizer) {
        if gesture.state == .Ended {
            if let closureObject = objc_getAssociatedObject(self, &JhwActionHandlerTargetBlockKey) {
                let closure = unsafeBitCast(closureObject, JhwViewGestureClosure.self)
                closure(gesture)
            }
        }
    }
    
    func firstAvailableViewController() -> UIViewController {
        return traverseResponderChainForUIViewController() as! UIViewController
    }
    
    func distributeSpacingHorizontallyWith(views: NSArray) {
        
        let spaces = NSMutableArray.init(capacity: views.count+1)
        
        for _ in 0 ..< views.count+1 {
            let v = UIView()
            spaces.addObject(v)
            self.addSubview(v)
            
            v.snp_makeConstraints(closure: { (make) in
                make.width.equalTo(v.snp_height)
            })
        }
        
        let v0: UIView = views[0] as! UIView
        let space0: UIView = spaces[0] as! UIView
        
        space0.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self.snp_left)
            make.centerY.equalTo(v0.snp_centerY)
        })
        
        var lastSpace = space0
        for i in 0 ..< views.count {
            let obj: UIView = views[i] as! UIView
            let space: UIView = spaces[i+1] as! UIView
            
            obj.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(self)
                make.left.equalTo(lastSpace.snp_right)
            })
            
            space.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(obj.snp_right);
                make.centerY.equalTo(obj.snp_centerY);
                make.width.equalTo(space0);
            })
            lastSpace = space
        }
        lastSpace.snp_makeConstraints { (make) in
            make.right.equalTo(self.snp_right);
        }
        
    }
    
    private func traverseResponderChainForUIViewController() -> AnyObject {
        let nextReponder = self.nextResponder() as! AnyObject
        if nextReponder.isKindOfClass(UIViewController) {
            return nextReponder as! UIViewController
        } else if nextReponder.isKindOfClass(UIView) {
            let v = nextReponder as! UIView
            return v.traverseResponderChainForUIViewController()
        } else {
            return NSNull.init()
        }
    }
    
    
}