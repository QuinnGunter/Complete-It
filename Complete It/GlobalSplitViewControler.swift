//
//  GlobalSplitViewControler.swift
//  
//
//  Created by Quintin Gunter on 8/15/17.
//
//

import UIKit

class GlobalSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool{
        return true
    }
    
}
