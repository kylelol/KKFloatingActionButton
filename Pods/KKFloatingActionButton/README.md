# KKFloatingActionButton


[![Version](https://img.shields.io/cocoapods/v/KKFloatingActionButton.svg?style=flat)](http://cocoapods.org/pods/KKFloatingActionButton)
[![License](https://img.shields.io/cocoapods/l/KKFloatingActionButton.svg?style=flat)](http://cocoapods.org/pods/KKFloatingActionButton)
[![Platform](https://img.shields.io/cocoapods/p/KKFloatingActionButton.svg?style=flat)](http://cocoapods.org/pods/KKFloatingActionButton)

KKFloatingActionButton is very customizable, Material Design-like menu, inspried by the Inbox app made by Google.  

![Screencapture GIF](https://dl.dropboxusercontent.com/u/21995835/out4.gif)

## Usage

To run the example project, clone the repo, and run `pod install`. Open the .xcworkspace, change the build target to 'Example', and build and run.

## Requirements
iOS 8+
Swift 1.2 

## Installation

KKFloatingActionButton is available through [CocoaPods](http://cocoapods.org). To install
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
  (Note: This could be done programatically, I just prefer to use IB.)

3.  Conform to the `KKFloatingMaterialButtonDataSource` and `KKFloatingMaterialButtonDelegate`

  The control contains a `customTableViewCell` property which is a tuple that requires a `UINib`, representing the cell to be displayed in the menu, and a `String` which is the `reuseIdentifier` to be used for the cell. Set this property with your own custom table view cell. **The project does not use a deafult cell, you must provide a custom one. Refer to Example project. **

4. Inside your view controllers `viewDidLoad()` call the `configureViews()` method on the `KKFloatingMaterialButton`, then continue to customize the button. 
  ````Swift
  // Inside viewDidLoad()
  menuButton.configureViews()
  menuButton.dataSource = self
  menuButton.delegate = self
  // Continue customizing....
  ````

## Customization

Here are some of the customization points of the control:
* `customTableViewCell: (UINib, String)` - a tuple to hold a custom table view cell .xib and the reuse identifier associated with it 
* `buttonShadowColor: UIColor?` - The color of the button's shadow.
* `buttonShadowOpacity: CGFloat?` - The opacity of the button's shadow. Kept between 0 and 1.
* `buttonBgColor: UIColor?` - The background color of the button.
* `menuBgColor: UIColor?` - The background color of the overlay that appears when the menu is presented. 
* `menuBgOpacity: CGFloat` - The opacity of the overlay that appears when the menu is presented. 
* `rotatingImage: UIImage?` - The image that rotated when the menu is presented. Displayed half the size of the button, aligned with the button's center.
* `imageRotationAngle: CGFloat` - The angle to rotate the rotatingImage when the menu is presented. 

## License

KKFloatingActionButton is available under the MIT license. See the LICENSE file for more info.

## Special Thanks to 

* Material Kit  - https://github.com/nghialv/MaterialKit
* VCFloatingActionButton - https://github.com/gizmoboy7/VCFloatingActionButton
