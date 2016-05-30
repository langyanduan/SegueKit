//
//  UIViewController+Extension.swift
//  SegueKit
//
//  Created by langyanduan on 16/5/29.
//  Copyright © 2016年 seguekit. All rights reserved.
//

import UIKit
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
            if let segueInfo = TypedStoryboardSegueInfo(segueIdentifier: identifier, segue: segue) {
                handler(segueInfo)
            } else {
                assertionFailure()
            }
        }
    }
}
