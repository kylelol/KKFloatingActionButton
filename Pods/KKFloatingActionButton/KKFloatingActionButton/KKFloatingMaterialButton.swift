//
//  KKFloatingMaterialButton.swift
//  FloatingMaterialButton
//
//  Created by Kyle Kirkland on 7/10/15.
//  Copyright (c) 2015 Kyle Kirkland. All rights reserved.
//

import UIKit
import MaterialKit

public protocol KKFloatingMaterialButtonDataSource: class {
    
    func numberOfRowsInMenuTableView() -> Int
    func menuTableView(tableView: UITableView, cellForAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
}

public protocol KKFloatingMaterialButtonDelegate: class {
    func menuTableView(tableView: UITableView, heightForCellAtIndexPath indexPath: NSIndexPath) -> CGFloat
    
    func menuTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
}

public class KKFloatingMaterialButton: UIView {
    
    
    //Exposed Properties
    
    public var imageRotationAngle: CGFloat = CGFloat(-M_PI + -M_PI_4) //Default
    
    public var rotatingImage: UIImage? {
        didSet {
            self.imageView?.image = rotatingImage
        }
    }
    
    public var menuBgOpacity: CGFloat = 0.7 //Default
    
    public var menuBgColor: UIColor? = UIColor.greenColor() {
        didSet {
            self.bgView?.backgroundColor = menuBgColor
        }
    }
    
    public var buttonBgColor: UIColor? {
        didSet {
            self.button?.backgroundColor = buttonBgColor
        }
    }
    
    public var buttonShadowRadius: CGFloat? {
        didSet {
            
            if buttonShadowRadius != nil {
                self.button?.layer.shadowRadius = buttonShadowRadius!
            }
        }
    }
    
    public var buttonShadowOpacity: Float? {
        didSet {
            
            //Ensure value is not nil, and between [0, 1]
            if buttonShadowOpacity != nil {
                self.button?.layer.shadowOpacity = max( 0 , min(1, buttonShadowOpacity!))
            }
        }
    }
    
    public var buttonShadowColor: UIColor? {
        didSet {
            if buttonShadowColor != nil {
                self.button?.layer.shadowColor = buttonShadowColor!.CGColor
            }
        }
    }
    
    public var customTableViewCell: (nib: UINib?, reuseIdentifer: String?)? {
        didSet {
            
            if let tuple = customTableViewCell, nib = tuple.nib, reuseIdentifier = tuple.reuseIdentifer {
                self.menuTableView!.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
            }
        }
    }
    
    public weak var delegate: KKFloatingMaterialButtonDelegate?
    public weak var dataSource: KKFloatingMaterialButtonDataSource! //must be set
    
    //Constants
    private let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
    private let screenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)
    
    //SubViews.
    private var button: MKButton?
    private var imageView: UIImageView?
    
    private weak var scrollView: UIScrollView? //For show/hide when scrolling

    
    //Menu Display Views
    private var menuTableView: UITableView?
    private var bgView: UIView?
    private var windowView: UIView?
    private var isMenuVisible = false
    
    private var mainWindow: UIWindow? {
        return UIApplication.sharedApplication().keyWindow
    }
    
    public func configureViews() {
        self.backgroundColor = UIColor.clearColor()
        windowView = UIView(frame: UIScreen.mainScreen().bounds)
        self.configureBgView()
        self.configureMenuTableView()
        self.configureMKButton()
        self.configureRotatingImageView()
        
      //  self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTapFloatingButton:"))
        button!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTapFloatingButton"))
        
    }
    
    public func showMenu() {
        if isMenuVisible {
            self.dismissMenu()
        } else {
            self.insertSubviews()
            self.presentMenu()
            
        }
        
        isMenuVisible = !isMenuVisible
    }
    
    private func insertSubviews() {
        menuTableView?.alpha = 1.0
        windowView!.addSubview(bgView!)
        windowView!.addSubview(menuTableView!)
        mainWindow?.insertSubview(windowView!, belowSubview: self)
        mainWindow?.addSubview(self)
        self.menuTableView?.reloadData()
        
    }
    
    private func presentMenu() {

        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.bgView?.alpha = self.menuBgOpacity
            self.imageView?.transform = CGAffineTransformMakeRotation(self.imageRotationAngle)
        })
    }
    
    private func dismissMenu() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.menuTableView?.alpha = 0.0
            self.bgView?.alpha = 0.0
            self.imageView!.transform = CGAffineTransformIdentity
            
            }) { _ in
                self.bgView?.removeFromSuperview()
                self.windowView?.removeFromSuperview()
                self.mainWindow?.removeFromSuperview()
        }
    }
    
    private func configureMKButton() {
        button = MKButton(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.bounds), height: CGRectGetHeight(self.bounds)))
        button!.cornerRadius = CGRectGetHeight(button!.frame)/2
        button!.backgroundLayerCornerRadius = CGRectGetHeight(button!.frame)/2
        button!.maskEnabled = false
        button!.ripplePercent = 1.75
        button!.rippleLocation = .Center
        button!.layer.shadowOpacity = 0.3
        button!.layer.shadowRadius = 7
        button!.layer.shadowColor = UIColor.blackColor().CGColor
        button!.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.addSubview(button!)
    }
    
    private func configureRotatingImageView() {
        
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.bounds)/2, height: CGRectGetHeight(self.bounds)/2))
            imageView!.center = button!.center
            imageView!.clipsToBounds = true
            imageView!.contentMode = .ScaleAspectFit
            self.addSubview(imageView!)
    }
    
    private func configureMenuTableView() {
        menuTableView = UITableView(frame: CGRect(x: screenWidth/4, y: 0, width: 0.75 * screenWidth, height: screenHeight - (screenHeight - CGRectGetMaxY(self.frame))))
        menuTableView!.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: self.bounds.height/3))
        menuTableView!.scrollEnabled = false
        menuTableView!.dataSource = self
        menuTableView!.delegate = self
        menuTableView!.backgroundColor = UIColor.clearColor()
        menuTableView!.separatorStyle = .None
        menuTableView!.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
    }
    
    private func configureBgView() {
        bgView = UIView(frame: UIScreen.mainScreen().bounds)
        bgView!.backgroundColor = self.menuBgColor
        bgView!.userInteractionEnabled = true
        bgView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTapBgView:"))
        
    }
    

    
    //MARK: - Target Action 
    func didTapBgView(tap: UITapGestureRecognizer) {
        self.showMenu()
    }
    
    func didTapFloatingButton() {
        self.showMenu()
    }
    
    
}

 extension KKFloatingMaterialButton: UITableViewDelegate {
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.delegate!.menuTableView(tableView, heightForCellAtIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate!.menuTableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
}

 extension KKFloatingMaterialButton: UITableViewDataSource {
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var delay = Double((indexPath.row * indexPath.row)) * 0.004
        
        let translation = -(indexPath.row + 1) * 50
        
        var scaleTransform = CGAffineTransformMakeScale(0.95, 0.95)
        var translationTransform = CGAffineTransformMakeTranslation(0, CGFloat(translation))
        
        cell.transform = CGAffineTransformConcat(scaleTransform, translationTransform)
        cell.alpha = 0.0
        
        UIView.animateWithDuration(0.2, delay: delay, options: .CurveEaseInOut, animations: { () -> Void in
            cell.transform = CGAffineTransformIdentity
            cell.alpha = 1.0
        }, completion: nil)
    }
   public  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.numberOfRowsInMenuTableView()
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.dataSource.menuTableView(tableView, cellForAtIndexPath: indexPath)
    }
}
