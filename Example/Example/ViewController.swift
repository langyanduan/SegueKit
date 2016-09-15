//
//  ViewController.swift
//  Example
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

    @IBAction func onBtnA(_ sender: AnyObject) {
        performSegue(with: "A") { (segue) in
            segue.destination.view.backgroundColor = UIColor.yellow
        }
    }

    @IBAction func onBtnB(_ sender: AnyObject) {
        performSegue(with: R.segue.viewController.b) { (segue) in
            segue.destination.view.backgroundColor = UIColor.green
        }
    }
    
    @IBAction func onBtnC(_ sender: AnyObject) {
        rx_performSegue("C")
            .subscribeNext { (segue) in
                segue.destination.view.backgroundColor = UIColor.red
            }
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func onBtnD(_ sender: AnyObject) {
        rx_performSegue(R.segue.viewController.d)
            .subscribeNext { (segue) in
                segue.destination.view.backgroundColor = UIColor.blue
            }
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func onBtnVC(_ sender: AnyObject) {
        rx_performSegue(R.segue.viewController.viewController)
            .subscribeNext { [unowned self] (segue) in
                for view in segue.destination.view.subviews {
                    if let button = view as? UIButton {
                        button.rx.tap
                            .bindTo(segue.destination.rx_segue(R.segue.uIViewController.viewController)) { (segue, _) in
                                segue.destination.view.backgroundColor = UIColor.red
                            }
                            .addDisposableTo(self.disposeBag)
                        break
                    }
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
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
            .subscribeNext { (segue, sender) in
                segue.destination.view.backgroundColor = UIColor.cyan
            }
            .addDisposableTo(baseDisposeBag)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
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
        
        button.rx.tap.bindTo(rx_segue("A"))  { (segue, _) in
            segue.destination.view.backgroundColor = UIColor.black
        }.addDisposableTo(disposeBag)
    }
    
    deinit {
        print("deinit A")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
}

class B: BaseViewController {
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.rx.tap.bindTo(rx_segue(R.segue.b.b))  { (segue, _) in
            segue.destination.view.backgroundColor = UIColor.brown
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
        
        rx_segue("C").subscribeNext { (segue, sender) in
            segue.destination.view.backgroundColor = UIColor.purple
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
        
        rx_segue(R.segue.d.d).subscribeNext { (segue, sender) in
            segue.destination.view.backgroundColor = UIColor.orange
        }.addDisposableTo(disposeBag)
    }
    
    deinit {
        print("deinit D")
    }
}
