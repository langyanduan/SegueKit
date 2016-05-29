//
//  UIViewController+RxSwift.swift
//  Pods
//
//  Created by WuFan on 16/5/29.
//
//

import UIKit
import RxSwift

// MARK:- Rx

public extension UIViewController {
    public func rx_performSegue(identifier: String) -> Observable<UIStoryboardSegue> {
        return Observable.create { [weak self] (observer) -> Disposable in
            self?.performSegue(with: identifier) { (segue) in
                observer.onNext(segue)
                observer.onCompleted()
            }
            return NopDisposable.instance
        }
    }
    
    public func rx_segue(identifier: String) -> Observable<(UIStoryboardSegue, AnyObject?)> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            MainScheduler.ensureExecutingOnScheduler()
            guard let `self` = self else {
                return NopDisposable.instance
            }
            
            self.swz_swizzleSegueIfNeeded()
            let handler = { (segue: UIStoryboardSegue, sender: AnyObject?) in
                observer.onNext((segue, sender))
            }
            let context = self.aop_context.save(identifier, type: self.dynamicType, handler: handler, removeOnComplete: false)
            return AnonymousDisposable { [weak self] in
                self?.aop_context.removeContext(context)
            }
        })
    }
    
    public func rx_segue<O: ObservableType>(identifier: String)
        -> (source: O)
        -> (handler: (UIStoryboardSegue, O.E) -> Void)
        -> Disposable {
        return { source in
            return { handler in
                return source.subscribe { [weak self] (event) in
                    switch event {
                    case .Next(let element):
                        let handlerWrapper: UIStoryboardSegue -> Void = { (segue) in
                            handler(segue, element)
                        }
                        self?.performSegue(with: identifier, handler: handlerWrapper)
                    case .Error(let error):
                        assertionFailure("Binding error to UI: \(error)")
                    case .Completed:
                        break
                    }
                }
            }
        }
    }
}
