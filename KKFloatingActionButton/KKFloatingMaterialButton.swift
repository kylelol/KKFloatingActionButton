//
//  KKFloatingMaterialButton.swift
//  FloatingMaterialButton
//
//  Created by Kyle Kirkland on 7/10/15.
//  Copyright (c) 2015 Kyle Kirkland. All rights reserved.
//

import UIKit

protocol KKFloatingMaterialButtonDataSource: class {
    
    func numberOfRowsInMenuTableView() -> Int
    func menuTableView(tableView: UITableView, cellForAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
}

protocol KKFloatingMaterialButtonDelegate: class {
    func menuTableView(tableView: UITableView, heightForCellAtIndexPath indexPath: NSIndexPath) -> CGFloat
    
    func menuTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
}

class KKFloatingMaterialButton: UIView {
    
    
    //Exposed Properties
    var menuBgColor: UIColor? = UIColor.greenColor() {
        didSet {
            self.bgView?.backgroundColor = menuBgColor
        }
    }
    
    var buttonBgColor: UIColor? {
        didSet {
            self.button?.backgroundColor = buttonBgColor
        }
    }
    
    var buttonShadowRadius: CGFloat? {
        didSet {
            
            if buttonShadowRadius != nil {
                self.button?.layer.shadowRadius = buttonShadowRadius!
            }
        }
    }
    
    var buttonShadowOpacity: Float? {
        didSet {
            
            //Ensure value is not nil, and between [0, 1]
            if buttonShadowOpacity != nil {
                self.button?.layer.shadowOpacity = max( 0 , min(1, buttonShadowOpacity!))
            }
        }
    }
    
    var buttonShadowColor: UIColor? {
        didSet {
            if buttonShadowColor != nil {
                self.button?.layer.shadowColor = buttonShadowColor!.CGColor
            }
        }
    }
    
    var customTableViewCell: (nib: UINib?, reuseIdentifer: String?)? {
        didSet {
            
            if let tuple = customTableViewCell, nib = tuple.nib, reuseIdentifier = tuple.reuseIdentifer {
                self.menuTableView!.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
            }
        }
    }
    
    weak var delegate: KKFloatingMaterialButtonDelegate?
    weak var dataSource: KKFloatingMaterialButtonDataSource! //must be set
    
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
    
    func configureViews() {
        
        windowView = UIView(frame: UIScreen.mainScreen().bounds)
        self.configureBgView()
        self.configureMenuTableView()
        self.configureMKButton()
        
      //  self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTapFloatingButton:"))
        button!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTapFloatingButton"))
        
    }
    
    func showMenu() {
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
        self.menuTableView?.reloadData()
        
    }
    
    private func presentMenu() {

        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.bgView?.alpha = 0.7
            self.imageView?.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI + -M_PI_4))
        })
    }
    
    private func dismissMenu() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.menuTableView?.alpha = 0.0
            self.bgView?.alpha = 0.0
            
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
    
    private func configureMenuTableView() {
        menuTableView = UITableView(frame: CGRect(x: screenWidth/4, y: 0, width: 0.75 * screenWidth, height: screenHeight - (screenHeight - CGRectGetMaxY(self.frame))))
        menuTableView!.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: self.bounds.height/2))
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.delegate!.menuTableView(tableView, heightForCellAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate!.menuTableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
}

extension KKFloatingMaterialButton: UITableViewDataSource {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.numberOfRowsInMenuTableView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.dataSource.menuTableView(tableView, cellForAtIndexPath: indexPath)
    }
}
