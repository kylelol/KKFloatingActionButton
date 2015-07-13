//
//  UITableViewCell+KKFABHelper.swift
//  KKFloatingActionButton
//
//  Created by Kyle Kirkland on 7/13/15.
//  Copyright (c) 2015 Kyle Kirkland. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    public func configureCellForKKFloatingActionButtonMenu() {
        self.backgroundColor = UIColor.clearColor()
        self.contentView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        self.selectionStyle = .None
    }
}
