# SegueKit

[![CI Status](http://img.shields.io/travis/langyanduan/SegueKit.svg?style=flat)](https://travis-ci.org/langyanduan/SegueKit)
[![Version](https://img.shields.io/cocoapods/v/SegueKit.svg?style=flat)](http://cocoapods.org/pods/SegueKit)
[![License](https://img.shields.io/cocoapods/l/SegueKit.svg?style=flat)](http://cocoapods.org/pods/SegueKit)
[![Platform](https://img.shields.io/cocoapods/p/SegueKit.svg?style=flat)](http://cocoapods.org/pods/SegueKit)

⚠️ This readme describes SegueKit 3.0 version that requires Swift 3.0.  
⚠️ If you are looking for Swift 2.3 compatible version, please take a look at SegueKit ~> 2.0 versions and swift2.3 branch.

## About me

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
            segue.destination.view.backgroundColor = UIColor.yellow
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
            segue.destination.view.backgroundColor = UIColor.green
        }
    }
    
    // with Rx
    @IBAction func onBtnC(sender: AnyObject) {
        rx.performSegue("C")
            .subscribeNext { (segue) in
                segue.destination.view.backgroundColor = UIColor.red
            }
            .addDisposableTo(disposeBag)
    }
    
    // with Rx + R.swift
    @IBAction func onBtnD(sender: AnyObject) {
        rx.performSegue(R.segue.viewController.d)
            .subscribeNext { (segue) in
                segue.destination.view.backgroundColor = UIColor.blue
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
        button.rx.tap.bindTo(rx.segue("A")) { (segue, _) in
            segue.destination.view.backgroundColor = UIColor.black
        }.addDisposableTo(disposeBag)
    }
}

class B: UIViewController {
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // with Rx + R.swift
        button.rx.tap.bindTo(rx.segue(R.segue.b.b)) { (segue, _) in
            segue.destination.view.backgroundColor = UIColor.brown
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
        rx.segue("C").subscribeNext { (segue, sender) in
            segue.destination.view.backgroundColor = UIColor.purple
        }.addDisposableTo(disposeBag)
    }
}

class D: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // with Rx + R.swift
        rx.segue(R.segue.d.d).subscribeNext { (segue, sender) in
            segue.destination.view.backgroundColor = UIColor.orange
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
    pod "SegueKit", '~> 3.0.0-beta.1'
    ```

* RxSwift

    ```ruby
    pod "SegueKit/RxSwift", '~> 3.0.0-beta.1'
    ```

* RxSwift

    ```ruby
    pod "SegueKit/R.swift", '~> 3.0.0-beta.1'
    ```

* RxSwift + R.swift

    ```ruby
    pod "SegueKit/Extension", '~> 3.0.0-beta.1'
    ```


⚠️ If you want to use CocoaPods with Xcode 8.0 and Swift 3.0, you might need to add the following lines to your podfile:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
    end
  end
end
```

### Carthage

Because `R.swift` unsupport carthage, so `SegueKit` can only work with `RxSwift` if you install by `crathage`.

Carthage users can point to this repository and use whichever generated framework they'd like, `SegueKit` or `RxSegueKit`. The `SegueKit` framework is bundled in each of those frameworks; importing more than one framework in a single file will result in ambiguous lookups at compile time.

```
github "langyanduan/SegueKit"
```

## License

SegueKit are created by langyanduan and released under a MIT License.
