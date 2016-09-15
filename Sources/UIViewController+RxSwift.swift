//
//  UIViewController+Extension.swift
//  SegueKit
//
//  Created by langyanduan on 16/5/29.
//  Copyright © 2016年 seguekit. All rights reserved.
//

import UIKit
import RxSwift

// MARK:- Rx

public extension UIViewController {
    
    public func rx_performSegue(_ identifier: String) -> Observable<UIStoryboardSegue> {
        return Observable.create { [weak self] (observer) -> Disposable in
            self?.performSegue(with: identifier) { (segue) in
                observer.onNext(segue)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
    public func rx_segue(_ identifier: String) -> Observable<(UIStoryboardSegue, AnyObject?)> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            MainScheduler.ensureExecutingOnScheduler()
            guard let `self` = self else {
                return Disposables.create()
            }
            
            self.swz_swizzleSegueIfNeeded()
            let handler = { (segue: UIStoryboardSegue, sender: AnyObject?) in
                observer.onNext((segue, sender))
            }
            let context = self.aop_context.save(identifier, type: type(of: self), handler: handler, removeOnComplete: false)
            return Disposables.create { [weak self] in
                self?.aop_context.removeContext(context)
            }
        })
    }
    
    
    public func rx_segue<O: ObservableType>(_ identifier: String)
        -> (_ source: O)
        -> (_ handler: @escaping (UIStoryboardSegue, O.E) -> Void)
        -> Disposable {
        return { source in
            return { handler in
                return source.subscribe { [weak self] (event) in
                    switch event {
                    case .next(let element):
                        let handlerWrapper: (UIStoryboardSegue) -> Void = { (segue) in
                            handler(segue, element)
                        }
                        self?.performSegue(with: identifier, handler: handlerWrapper)
                    case .error(let error):
                        assertionFailure("Binding error to UI: \(error)")
                    case .completed:
                        break
                    }
                }
            }
        }
    }
}
