//
//  UIViewController+Extension.swift
//  SegueKit
//
//  Created by langyanduan on 16/5/24.
//  Copyright © 2016年 seguekit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Rswift

// MARK:- Rx, R.swift

extension Reactive where Base: UIViewController {
    public func performSegue<Segue, Destination>(_ identifier: StoryboardSegueIdentifier<Segue, Base, Destination>)
        -> Observable<TypedStoryboardSegueInfo<Segue, Base, Destination>>
    {
        return performSegue(identifier.identifier).map { TypedStoryboardSegueInfo(segueIdentifier: identifier, segue: $0)! }
    }
    
    public func segue<Segue, Destination>(_ identifier: StoryboardSegueIdentifier<Segue, Base, Destination>)
        -> Observable<(TypedStoryboardSegueInfo<Segue, Base, Destination>, AnyObject?)>
    {
        return segue(identifier.identifier).map { (TypedStoryboardSegueInfo(segueIdentifier: identifier, segue: $0.0)!, $0.1) }
    }
    
    public func segue<Segue, Destination, O: ObservableType>(_ identifier: StoryboardSegueIdentifier<Segue, Base, Destination>)
        -> (_ source: O)
        -> (_ handler: @escaping (TypedStoryboardSegueInfo<Segue, Base, Destination>, O.E) -> Void)
        -> Disposable
    {
        return { source in
            return { handler in
                let handlerWrapper = { (segue: UIStoryboardSegue, element: O.E) in
                    if let segueInfo = TypedStoryboardSegueInfo(segueIdentifier: identifier, segue: segue) {
                        handler(segueInfo, element)
                    } else {
                        assertionFailure()
                    }
                }
                return self.segue(identifier.identifier)(source)(handlerWrapper)
            }
        }
    }
}

