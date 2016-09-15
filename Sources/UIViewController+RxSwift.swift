//
//  UIViewController+Extension.swift
//  SegueKit
//
//  Created by langyanduan on 16/5/29.
//  Copyright © 2016年 seguekit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK:- Rx

extension Reactive where Base: UIViewController {
    public func performSegue(_ identifier: String) -> Observable<UIStoryboardSegue> {
        return Observable.create { (observer) -> Disposable in
            self.base.performSegue(with: identifier) { (segue) in
                observer.onNext(segue)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    public func segue(_ identifier: String) -> Observable<(UIStoryboardSegue, AnyObject?)> {
        return Observable.create { (observer) -> Disposable in
            MainScheduler.ensureExecutingOnScheduler()
            
            self.base.swz_swizzleSegueIfNeeded()
            let handler = { (segue: UIStoryboardSegue, sender: AnyObject?) in
                observer.onNext((segue, sender))
            }
            let context = self.base.aop_context.save(identifier, type: type(of: self.base), handler: handler, removeOnComplete: false)
            return Disposables.create {
                self.base.aop_context.removeContext(context)
            }
        }
    }
    
    public func segue<O: ObservableType>(_ identifier: String)
        -> (_ source: O)
        -> (_ handler: @escaping (UIStoryboardSegue, O.E) -> Void)
        -> Disposable
    {
        return { source in
            return { handler in
                return source.subscribe { (event) in
                    switch event {
                    case .next(let element):
                        let handlerWrapper: (UIStoryboardSegue) -> Void = { (segue) in
                            handler(segue, element)
                        }
                        self.base.performSegue(with: identifier, handler: handlerWrapper)
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

