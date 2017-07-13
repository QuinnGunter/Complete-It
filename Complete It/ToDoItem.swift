//
//  ToDoItem.swift
//  Complete It
//
//  Created by Quintin Gunter on 7/8/17.
//  Copyright © 2017 Quintin Gunter. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {

    var text: String
    var completed: Bool
    
    init(text: String){
        self.text = text
        self.completed = false
    }
}
