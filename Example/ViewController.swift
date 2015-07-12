//
//  ViewController.swift
//  FloatingMaterialButton
//
//  Created by Kyle Kirkland on 7/10/15.
//  Copyright (c) 2015 Kyle Kirkland. All rights reserved.
//

import UIKit
import KKFloatingActionButton

class ViewController: UIViewController {

    @IBOutlet weak var floatingButton: KKFloatingMaterialButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Must get called before anything.
        self.floatingButton.configureViews()

        // Customization points. 
        self.floatingButton.dataSource = self
        self.floatingButton.delegate = self
        self.floatingButton.customTableViewCell = (UINib(nibName: "KKMenuTableViewCell", bundle: nil), "MenuTableCell")
        self.floatingButton.buttonBgColor = UIColor.whiteColor()
        self.floatingButton.menuBgColor = UIColor.whiteColor()
        self.floatingButton.buttonShadowOpacity = 0.3
        self.floatingButton.menuBgOpacity = 0.7
        self.floatingButton.rotatingImage = UIImage(named: "plus_sign")


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: KKFloatingMaterialButtonDelegate {
    
    func menuTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("Selected row at index path ")
    }
    
    func menuTableView(tableView: UITableView, heightForCellAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
}

extension ViewController: KKFloatingMaterialButtonDataSource {
    func numberOfRowsInMenuTableView() -> Int {
        return 5
    }
    
    func menuTableView(tableView: UITableView, cellForAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MenuTableCell") as! KKMenuTableViewCell
        
        let buttonCenter = self.floatingButton.center
        cell.imageViewTrailingConstraint.constant = self.view.frame.size.width - (buttonCenter.x + cell.imageContainerView.frame.size.width/2)
        
        let tuple = tupleForIndexPath(indexPath)
        
        cell.menuImageView.image = tuple.0
        cell.menuLabel.text = tuple.1
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func tupleForIndexPath(indexPath: NSIndexPath) -> (UIImage, String) {
        switch indexPath.row {
        case 0:
            return (UIImage(named: "albumImage")!, "Album")
        case 1: return (UIImage(named: "contactImage")!, "Contact")
        case 2: return (UIImage(named: "eventImage")!, "Event")
        case 3: return (UIImage(named: "listImage")!, "List")
        default : return (UIImage(named: "albumImage")!, "Default")
        }
    }
}

