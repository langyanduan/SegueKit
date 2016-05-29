//
//  UIViewController+Extension.swift
//  SegueKit
//
//  Created by langyanduan on 16/5/24.
//  Copyright © 2016年 seguekit. All rights reserved.
//

import UIKit
import RxSwift
import Rswift

// MARK:- Rx, R.swift

public protocol RxSeguePerformerProtocol {
    func rx_performSegue(identifier: String) -> Observable<UIStoryboardSegue>
    func rx_segue(identifier: String) -> Observable<(UIStoryboardSegue, AnyObject?)>
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
        -> Observable<(TypedStoryboardSegueInfo<Segue, Self, Destination>, AnyObject?)> {
        return rx_segue(identifier.identifier).map { (TypedStoryboardSegueInfo(segueIdentifier: identifier, segue: $0.0)!, $0.1) }
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
