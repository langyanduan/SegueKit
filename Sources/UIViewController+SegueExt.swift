//
//  UIViewController+SegueExt.swift
//  SegueKit
//
//  Created by langyanduan on 16/5/24.
//  Copyright © 2016年 seguekit. All rights reserved.
//

import UIKit
import RxSwift
import Rswift

// MARK:- R.swift

public protocol SeguePerformerProtocol {
    func performSegue(with identifier: String, handler: UIStoryboardSegue -> Void)
}

extension UIViewController: SeguePerformerProtocol { }

public extension SeguePerformerProtocol where Self: UIViewController {
    public func performSegue<Segue, Destination>(with identifier: StoryboardSegueIdentifier<Segue, Self, Destination>,
                      handler: (TypedStoryboardSegueInfo<Segue, Self, Destination>) -> Void)
    {
        performSegue(with: identifier.identifier) { (segue) in
            let source = segue.sourceViewController as! Self
            let destination = segue.destinationViewController as! Destination
            if let segueInfo = TypedStoryboardSegueInfo(segueIdentifier: identifier, segue: segue) {
                handler(segueInfo)
            } else {
                assertionFailure()
            }
        }
    }
}

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

    public func rx_segue(identifier: String) -> Observable<UIStoryboardSegue> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            MainScheduler.ensureExecutingOnScheduler()
            guard let `self` = self else {
                return NopDisposable.instance
            }
            
            self.swz_swizzleIfNeeded()
            let handler = { (segue: UIStoryboardSegue) in
                observer.onNext(segue)
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

// MARK:- Rx, R.swift

public protocol RxSeguePerformerProtocol {
    func rx_performSegue(identifier: String) -> Observable<UIStoryboardSegue>
    func rx_segue(identifier: String) -> Observable<UIStoryboardSegue>
    func rx_segue<O: ObservableType>(identifier: String)
        -> (source: O)
        -> (handler: (UIStoryboardSegue, O.E) -> Void)
        -> Disposable
}

extension UIViewController: RxSeguePerformerProtocol { }

public extension RxSeguePerformerProtocol where Self: UIViewController {
    
    public func rx_performSegue<Segue, Destination>(identifier: StoryboardSegueIdentifier<Segue, Self, Destination>)
        -> Observable<TypedStoryboardSegueInfo<Segue, Self, Destination>> {
        return rx_performSegue(identifier.identifier).map { TypedStoryboardSegueInfo(segueIdentifier: identifier, segue: $0)! }
    }
    
    public func rx_segue<Segue, Destination>(identifier: StoryboardSegueIdentifier<Segue, Self, Destination>)
        -> Observable<TypedStoryboardSegueInfo<Segue, Self, Destination>> {
        return rx_segue(identifier.identifier).map { TypedStoryboardSegueInfo(segueIdentifier: identifier, segue: $0)! }
    }

    public func rx_segue<Segue, Destination, O: ObservableType>(identifier: StoryboardSegueIdentifier<Segue, Self, Destination>)
        -> (source: O)
        -> (handler: (TypedStoryboardSegueInfo<Segue, Self, Destination>, O.E) -> Void)
        -> Disposable {
        return { source in
            return { [weak self] handler in
                let handlerWrapper = { (segue: UIStoryboardSegue, element: O.E) in
                    if let segueInfo = TypedStoryboardSegueInfo(segueIdentifier: identifier, segue: segue) {
                        handler(segueInfo, element)
                    } else {
                        assertionFailure()
                    }
                }
                return self?.rx_segue(identifier.identifier)(source: source)(handler: handlerWrapper) ?? NopDisposable.instance
            }
        }
    }
}
