# KKFloatingActionButton


[![Version](https://img.shields.io/cocoapods/v/KKFloatingActionButton.svg?style=flat)](http://cocoapods.org/pods/KKFloatingActionButton)
[![License](https://img.shields.io/cocoapods/l/KKFloatingActionButton.svg?style=flat)](http://cocoapods.org/pods/KKFloatingActionButton)
[![Platform](https://img.shields.io/cocoapods/p/KKFloatingActionButton.svg?style=flat)](http://cocoapods.org/pods/KKFloatingActionButton)

<p align="center">
<img style="-webkit-user-select: none;" src="http://i.imgur.com/Bsms9e1.gif" width="365" height="568">
</p>

KKFloatingActionButton is very customizable Google Material Design-like menu. The menu is driven by a table view, and the control allows you to pass your own custom cells. 

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MyLibrary is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KKFloatingActionButton"
```

## Setup 

Refer to the example project for more guidance. 

1. Add the import statement to your view controller. 
  ````swift
  import KKFloatingActionButton
  ````

2. Create a UIView(prefrably a perfect square) in IB and assign the custom class to `KKFloatingMaterialButton`, then connect it to an outlet in your view controller: 
  ````swift
  @IBOutlet weak var menuButton: KKFloatingMaterialButton!
  ````

3.  Conform to the `KKFloatingMaterialButtonDataSource` and `KKFloatingMaterialButtonDelegate`

4. Inside your view controllers `viewDidLoad()` call the `configureViews()` method on the `KKFloatingMaterialButton`, then continue to customize the button. 
  ````Swift
  // Inside viewDidLoad()
  menuButton.configureViews()
  menuButton.dataSource = self
  menuButton.delegate = self
  // Continue customizing....
  ````

## Author

kylelol, kyle.kirkland0528@me.com

## License

KKFloatingMaterialButtonDataSource is available under the MIT license. See the LICENSE file for more info.
