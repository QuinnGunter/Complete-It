//
//  TaskFormControllerViewController.swift
//  Complete It
//
//  Created by Quintin Gunter on 7/13/17.
//  Copyright © 2017 Quintin Gunter. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import CloudKit

class TaskFormControllerVC: UIViewController {

    var toDoItems: [NSManagedObject] = []
    @IBOutlet weak var addTaskField: UITextField!
    
    @IBOutlet weak var addTimeField: UIDatePicker!
    
    @IBAction func saveButtonTapped(_ sender: Any) {
            
            let taskField = addTaskField.text
            let timeField = addTimeField.date
        //Save to CoreData
            self.save(task: taskField!, time: timeField)
        
        //Save iCloud
        if addTaskField?.text != "" {
            let newTask = CKRecord(recordType: "Task")
            newTask["content"] = addTaskField?.text as CKRecordValue?
            
            let privateDatabase = CKContainer.default().privateCloudDatabase
            privateDatabase.save(newTask, completionHandler: { (record: CKRecord?, error: Error?) in
                if error == nil {
                    print("Task saved")
                } else {
                    print("Error: \(error.debugDescription)")
                }
            })
        }
        
            FIRAnalytics.logEvent(withName: "Task_Made", parameters: nil)
            performSegue(withIdentifier: "toTableView", sender: sender)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func save(task: String, time: Date) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Todo",
                                       in: managedContext)!
        let todo = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        todo.setValue(task, forKeyPath: "task")
        todo.setValue(time, forKey: "time")
        
        do {
            try managedContext.save()
            toDoItems.append(todo)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
