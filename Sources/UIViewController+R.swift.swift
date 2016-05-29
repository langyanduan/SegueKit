//
//  UIViewController+R.swift.swift
//  Pods
//
//  Created by WuFan on 16/5/29.
//
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
