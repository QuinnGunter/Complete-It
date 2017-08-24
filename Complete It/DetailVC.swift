//
//  DetailVC.swift
//  Complete It
//
//  Created by Quintin Gunter on 8/3/17.
//  Copyright © 2017 Quintin Gunter. All rights reserved.
//

import UIKit
import Firebase

class DetailVC: UIViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var taskItem: Date? {
        didSet {
            // Update the view.
            
        }
    }

}
