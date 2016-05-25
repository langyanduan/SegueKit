//
//  ViewController.swift
//  SegueKit
//
//  Created by langyanduan on 16/5/24.
//  Copyright © 2016年 langyanduan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SegueKit

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onBtnA(sender: AnyObject) {
        performSegue(with: "A") { (segue) in
            segue.destinationViewController.view.backgroundColor = UIColor.yellowColor()
        }
    }

    @IBAction func onBtnB(sender: AnyObject) {
        performSegue(with: R.segue.viewController.b) { (segue) in
            segue.destinationViewController.view.backgroundColor = UIColor.greenColor()
        }
    }
    
    @IBAction func onBtnC(sender: AnyObject) {
        rx_performSegue("C")
            .subscribeNext { (segue) in
                segue.destinationViewController.view.backgroundColor = UIColor.redColor()
            }
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func onBtnD(sender: AnyObject) {
        rx_performSegue(R.segue.viewController.d)
            .subscribeNext { (segue) in
                segue.destinationViewController.view.backgroundColor = UIColor.blueColor()
            }
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func onBtnVC(sender: AnyObject) {
        rx_performSegue(R.segue.viewController.viewController)
            .subscribeNext { [unowned self] (segue) in
                for view in segue.destinationViewController.view.subviews {
                    if let button = view as? UIButton {
                        button.rx_tap
                            .bindTo(segue.destinationViewController.rx_segue(R.segue.uIViewController.viewController)) { (segue, _) in
                                segue.destinationViewController.view.backgroundColor = UIColor.redColor()
                            }
                            .addDisposableTo(self.disposeBag)
                        break
                    }
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    deinit {
        print("deinit ViewController")
    }
}

class BaseViewController: UIViewController {
    let baseDisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx_segue(R.segue.baseViewController.base)
            .subscribeNext { (segue) in
                segue.destinationViewController.view.backgroundColor = UIColor.cyanColor()
            }
            .addDisposableTo(baseDisposeBag)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
    }
    
    deinit {
        print("deinit BaseViewController")
    }
}

class A: BaseViewController {
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.rx_tap.bindTo(rx_segue("A"))  { (segue, _) in
            segue.destinationViewController.view.backgroundColor = UIColor.blackColor()
        }.addDisposableTo(disposeBag)
    }
    
    deinit {
        print("deinit A")
    }
}

class B: BaseViewController {
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.rx_tap.bindTo(rx_segue(R.segue.b.b))  { (segue, _) in
            segue.destinationViewController.view.backgroundColor = UIColor.brownColor()
        }.addDisposableTo(disposeBag)
    }

    
    deinit {
        print("deinit B")
    }
}

class C: BaseViewController {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx_segue("C").subscribeNext { (segue) in
            segue.destinationViewController.view.backgroundColor = UIColor.purpleColor()
        }.addDisposableTo(disposeBag)
    }
    
    deinit {
        print("deinit C")
    }
}

class D: BaseViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx_segue(R.segue.d.d).subscribeNext { (segue) in
            segue.destinationViewController.view.backgroundColor = UIColor.orangeColor()
        }.addDisposableTo(disposeBag)
    }
    
    deinit {
        print("deinit D")
    }
}
