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
import Seam3

class TaskFormControllerVC: UIViewController {

    var toDoItems: [NSManagedObject] = []
    var managedObjectContext: NSManagedObjectContext? = nil
    
    @IBOutlet weak var addTaskField: UITextField!
    
    @IBOutlet weak var addTimeField: UIDatePicker!
    
    @IBAction func saveButtonTapped(_ sender: Any) {
            
            let taskField = addTaskField.text
            let timeField = addTimeField.date
        
        //Save to CoreData
            self.save(task: taskField!, time: timeField)
        //saveCloudKitValuesToCoreData(results: <#T##[CKRecord]#>)
        
        //Save iCloud
        
        if addTaskField?.text != "" {
            let newTask = CKRecord(recordType: "Task")
            newTask["content"] = addTaskField?.text as CKRecordValue?
            newTask["time"] = addTimeField?.date as CKRecordValue?
            
            let privateDatabase = CKContainer.default().privateCloudDatabase
            privateDatabase.save(newTask, completionHandler: { (record: CKRecord?, error: Error?) in
                if error == nil {
                    print("Task saved")
                } else {
                    print("Error: \(error.debugDescription)")
                }
            })
        }
 
        //Seam Save
        
        /*
        if let context = self.managedObjectContext {
            let newTask = Todo(context: context)
            let taskField = addTaskField.text
            let timeField = addTimeField.date
            // If appropriate, configure the new managed object.
            newTask.task = taskField
            newTask.time = timeField as NSDate
            // Save the context.
            do {
                try context.save()
                print("Save")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        */
            Analytics.logEvent("Task_Made", parameters: nil)
            performSegue(withIdentifier: "toTableView", sender: sender)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loadTaks() {
        let publicDatabase = CKContainer.default().privateCloudDatabase
        let query = CKQuery(recordType: "Task", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        publicDatabase.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: Error?) in
            if let tasks = results {
                self.deleteAllRecordFromCoreData()
                self.saveCloudKitValuesToCoreData(results: tasks)
            }
        }
    }
    
    func deleteAllRecordFromCoreData() {
        // make a batch delete request
    }
    
    func saveCloudKitValuesToCoreData(results: [CKRecord]) {
        
        for record in results {
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
            todo.setValue(record["content"], forKeyPath: "task")
            todo.setValue(record["time"], forKey: "time")
            
            do {
                try managedContext.save()
                toDoItems.append(todo)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
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
