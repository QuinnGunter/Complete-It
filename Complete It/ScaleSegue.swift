//
//  ScaleSegue.swift
//  Complete It
//
//  Created by Quintin Gunter on 7/17/17.
//  Copyright © 2017 Quintin Gunter. All rights reserved.
//

import UIKit

class ScaleSegue: UIStoryboardSegue {

    override func perform() {
        
        let source = self.source
        let destination = self.destination
        
        source.view.superview?.insertSubview(destination.view, aboveSubview: source.view)
        destination.view.transform = CGAffineTransform(translationX: 0, y: -source.view.frame.size.height)
        
        UIView.animate(withDuration: 0.5,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.curveEaseInOut,
                                   animations: {
                                    destination.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                                   completion: { finished in
                                    source.present(destination, animated: false, completion: nil)
        }
        )
    }
}
