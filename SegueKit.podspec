Pod::Spec.new do |spec|
  spec.name             = 'SegueKit'
  spec.version          = '0.1.1'
  spec.summary          = 'Perform storyboard segues with closures, support RxSwift and R.swift.'
  
  spec.description      = <<-DESC
    # SegueKit

    Perform storyboard segues with closures, support RxSwift and R.swift.

    ## Why use this?

    balabala...

    ## Usage

    * basic
    * with R.swfit
    * with Rx
    * with Rx + R.swift
                       DESC

  spec.homepage         = 'https://github.com/langyanduan/SegueKit'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'langyanduan' => 'langyanduan@qq.com' }
  spec.source           = { :git => 'https://github.com/langyanduan/SegueKit.git', :tag => spec.version.to_s }
  spec.social_media_url = 'https://twitter.com/langyanduan'

  spec.ios.deployment_target = '8.0'
  spec.default_subspec = 'Core'

  # Subspecs
  spec.subspec 'Core' do |core|
    core.source_files = [
      'Sources/UIViewController+SegueSwizzle.h',
      'Sources/UIViewController+SegueSwizzle.m',
      'Sources/UIViewController+Segue.swift'
    ]
  end
  
  spec.subspec 'Extension' do |extension|
    extension.source_files = [
      'Sources/UIViewController+SegueExt.swift'
    ]
    extension.dependency 'SegueKit/Core'
    extension.dependency 'R.swift'
    extension.dependency 'RxSwift'
  end
  
end
