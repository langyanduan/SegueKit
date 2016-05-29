# SegueKit

[![CI Status](http://img.shields.io/travis/langyanduan/SegueKit.svg?style=flat)](https://travis-ci.org/langyanduan/SegueKit)
[![Version](https://img.shields.io/cocoapods/v/SegueKit.svg?style=flat)](http://cocoapods.org/pods/SegueKit)
[![License](https://img.shields.io/cocoapods/l/SegueKit.svg?style=flat)](http://cocoapods.org/pods/SegueKit)
[![Platform](https://img.shields.io/cocoapods/p/SegueKit.svg?style=flat)](http://cocoapods.org/pods/SegueKit)

Perform storyboard segues with closures.

## Why use this?

If you want to pass some parameters to destination view controller which created by segue in storyboard, usual should override `prepareForSegue:sender:`. But if work with `SegueKit`, you can do it in closure.

## Usage

If you create a segue in storyboard named "A", you can perfrom the segue like this: 

```swift
import SegueKit

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    // basic
    @IBAction func onBtnA(sender: AnyObject) {
        performSegue(with: "A") { (segue) in
            segue.destinationViewController.view.backgroundColor = UIColor.yellowColor()
        }
    }
}
```

## Extension Usage

* with R.swfit
* with Rx
* with Rx + R.swift

### Perform a segue with Extension

```swift
import SegueKit

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    // with R.swift
    @IBAction func onBtnB(sender: AnyObject) {
        performSegue(with: R.segue.viewController.b) { (segue) in
            segue.destinationViewController.view.backgroundColor = UIColor.greenColor()
        }
    }
    
    // with Rx
    @IBAction func onBtnC(sender: AnyObject) {
        rx_performSegue("C")
            .subscribeNext { (segue) in
                segue.destinationViewController.view.backgroundColor = UIColor.redColor()
            }
            .addDisposableTo(disposeBag)
    }
    
    // with Rx + R.swift
    @IBAction func onBtnD(sender: AnyObject) {
        rx_performSegue(R.segue.viewController.d)
            .subscribeNext { (segue) in
                segue.destinationViewController.view.backgroundColor = UIColor.blueColor()
            }
            .addDisposableTo(disposeBag)
    }
}

```

### Rx binding

```swift
class A: UIViewController {
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // with Rx
        button.rx_tap.bindTo(rx_segue("A")) { (segue, _) in
            segue.destinationViewController.view.backgroundColor = UIColor.blackColor()
        }.addDisposableTo(disposeBag)
    }
}

class B: UIViewController {
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // with Rx + R.swift
        button.rx_tap.bindTo(rx_segue(R.segue.b.b)) { (segue, _) in
            segue.destinationViewController.view.backgroundColor = UIColor.brownColor()
        }.addDisposableTo(disposeBag)
    }

}
```

### Rx subscribe

```swift

import SegueKit

class C: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // with Rx
        rx_segue("C").subscribeNext { (segue, sender) in
            segue.destinationViewController.view.backgroundColor = UIColor.purpleColor()
        }.addDisposableTo(disposeBag)
    }
}

class D: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // with Rx + R.swift
        rx_segue(R.segue.d.d).subscribeNext { (segue, sender) in
            segue.destinationViewController.view.backgroundColor = UIColor.orangeColor()
        }.addDisposableTo(disposeBag)
    }
}

```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Install

### Cocoapods

SegueKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

* Basic Functions

    ```ruby
    pod "SegueKit"
    ```

* RxSwift

    ```ruby
    pod "SegueKit/RxSwift"
    ```

* RxSwift

    ```ruby
    pod "SegueKit/R.swift"
    ```

* RxSwift + R.swift

    ```ruby
    pod "SegueKit/Extension"
    ```

### ~~Carthage~~


## License

SegueKit are created by langyanduan and released under a MIT License.