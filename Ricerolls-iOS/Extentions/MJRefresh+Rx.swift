//
//  MJRefresh+Rx.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/26.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import Foundation
import MJRefresh
import RxSwift

private var refreshingBlockKey: Void?

typealias RxMJRefreshClosure = @convention(block) () -> ()

extension UIScrollView {
    
    private var refreshingBlock: RxMJRefreshClosure? {
        get {
            if let closureObject = objc_getAssociatedObject(self, &refreshingBlockKey) {
                return unsafeBitCast(closureObject, RxMJRefreshClosure.self)
            }
            return nil
        }
        set (closure) {
            let dealObject: AnyObject = unsafeBitCast(closure, AnyObject.self)
            objc_setAssociatedObject(self, &refreshingBlockKey, dealObject, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var rx_refreshHeader: Observable<Void> {
        
        self.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshing))
        
        return Observable.create({ observer -> Disposable in
            
            self.refreshingBlock = { _ in
                observer.onNext(())
            }
            
            let cancel = AnonymousDisposable {
                
                self.mj_header = nil
                
            }
            return cancel
        })
    }
    
    var rx_endRefreshing: AnyObserver<Void> {
        
        return AnyObserver { [weak self] event in
            MainScheduler.ensureExecutingOnScheduler()
            
            switch event {
            case .Next():
                guard let sSelf = self else {
                    break
                }
                if let header = sSelf.mj_header {
                    if header.isRefreshing() {
                        header.endRefreshing()
                    }
                }
                if let footer = sSelf.mj_footer {
                    if footer.isRefreshing() {
                        footer.endRefreshing()
                    }
                }
                break
            case .Error(let error):
                print(error)
                break
            case .Completed:
                break
            }
        }
    }
    
    @objc private func refreshing() {
        if let refreshingBlock = self.refreshingBlock {
            refreshingBlock()
        }
    }
    
}