//
//  ViewController.swift
//  Complete It
//
//  Created by Quintin Gunter on 7/8/17.
//  Copyright © 2017 Quintin Gunter. All rights reserved.
//

import UIKit
import CoreData
import MGSwipeTableCell


class ViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var toDoItems: [NSManagedObject] = []
    
    @IBAction func addTask(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Task",
                                      message: "Add a new task",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let taskTosave = textField.text else {
                    return
            }
            
            self.save(task: taskTosave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(task: String) {
        
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
        
        do {
            try managedContext.save()
            toDoItems.append(todo)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func remove() {
        
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
        
        
        do {
            managedContext.delete(todo)
           try managedContext.save()
            
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MGSwipeTableCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 50.0
        tableView.layer.cornerRadius = 24
        tableView.backgroundColor = UIColor.white

        if toDoItems.count > 0 {
            return
        }
        /*
        toDoItems.append(ToDoItem(text: "feed the cat"))
        toDoItems.append(ToDoItem(text: "buy eggs"))
        toDoItems.append(ToDoItem(text: "watch WWDC videos"))
        toDoItems.append(ToDoItem(text: "rule the Web"))
         */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Todo")
        
        do {
            toDoItems = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MGSwipeTableCell
        
        //configure left buttons
        cell.leftButtons = [MGSwipeButton(title: "", icon: UIImage(named:"check.png"), backgroundColor: .green),
                            MGSwipeButton(title: "", icon: UIImage(named:"fav.png"), backgroundColor: .blue)]
        cell.leftSwipeSettings.transition = .drag
        
        //configure right buttons
        cell.rightButtons =
            [MGSwipeButton(title: "Delete", backgroundColor: .red) {
                (sender: MGSwipeTableCell!) -> Bool in
                //remove core data
                let task = self.toDoItems[indexPath.row]
                self.context.delete(task)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                //remove from tableview
                self.toDoItems.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.remove()
            
                print("Convenience callback for swipe buttons!")
            return true
            },
             
            MGSwipeButton(title: "Move",backgroundColor: .lightGray){
                (sender: MGSwipeTableCell!) -> Bool in
                // add code
            
                print("Editing")
                return true
            }]
        cell.rightSwipeSettings.transition = .drag
        cell.layer.cornerRadius = 50
        cell.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        cell.clipsToBounds = true
        cell.swipeBackgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        //cell separator
        let maskLayer = CAShapeLayer()
        let bounds = cell.bounds
        maskLayer.path = UIBezierPath(roundedRect: CGRect(x: 2, y: 2, width: bounds.width-4, height: bounds.height-4), cornerRadius: 5).cgPath
        cell.layer.mask = maskLayer
        
        let todo = toDoItems[indexPath.row]
        cell.textLabel?.text = todo.value(forKeyPath: "task") as? String
        cell.selectionStyle = .none
            return cell
    }
    
    // MARK: - Table view delegate

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        cell.layer.cornerRadius = 60
        cell.layoutMargins = UIEdgeInsets.init(top: 50, left: 50, bottom: 50, right: 50)
       
       
        
        /* //White layer
        let whiteBorder = UIView()
        whiteBorder.frame = cell.contentView.bounds
        whiteBorder.layer.borderWidth = 17
        whiteBorder.layer.cornerRadius = 24
        whiteBorder.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
        cell.contentView.addSubview(whiteBorder)
       */
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}

