//
//  KKMenuTableViewCell.swift
//  FloatingMaterialButton
//
//  Created by Kyle Kirkland on 7/10/15.
//  Copyright (c) 2015 Kyle Kirkland. All rights reserved.
//

import UIKit
import KKFloatingActionButton

class KKMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.configureCellForKKFloatingActionButtonMenu()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageContainerView.layer.cornerRadius = self.imageContainerView.bounds.height/2
        self.imageContainerView.layer.shadowOpacity = 0.3
        self.imageContainerView.layer.shadowRadius = 5.5
        self.imageContainerView.layer.shadowColor = UIColor.blackColor().CGColor
        self.imageContainerView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        
        self.labelContainerView.layer.cornerRadius = 4.0
        self.labelContainerView.layer.shadowOpacity = 0.3
        self.labelContainerView.layer.shadowRadius = 1
        self.labelContainerView.layer.shadowColor = UIColor.blackColor().CGColor
        self.labelContainerView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    }

}
