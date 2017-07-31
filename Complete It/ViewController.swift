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
import Firebase

class ViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customSegmentedControl: CustomSegmentedControl!
    @IBOutlet weak var editbutton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var toDoItems: [NSManagedObject] = []
    @IBAction func customSegmentedChanged(_ sender: CustomSegmentedControl) {
        tableView.reloadData()
    }
    
    @IBAction func startEditing(_ sender: UIBarButtonItem) {
       tableView.isEditing = !tableView.isEditing
        switch tableView.isEditing {
        case true:
            editbutton.title = "Done"
        case false:
            editbutton.title = "Edit"
        }
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        FIRAnalytics.logEvent(withName: "New_Task_Button_Pressed", parameters: nil)
    /*
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
    */
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
        //tableView.layer.cornerRadius = 24
        tableView.backgroundColor = UIColor.white

        if toDoItems.count > 0 {
            return
        }
        
        self.navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)
        self.navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        self.navigationController?.toolbar.shadowImage(forToolbarPosition: .bottom)
        self.navigationController?.toolbar.alpha = 0.0
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
        switch customSegmentedControl.selectedSegmentIndex {
        case 0:
            return toDoItems.count
        case 1:
            return toDoItems.count
        case 2:
            return toDoItems.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MGSwipeTableCell
        
        //configure left buttons
        cell.leftButtons = [MGSwipeButton(title: "Complete", backgroundColor: #colorLiteral(red: 0.2474539252, green: 0.8585546875, blue: 0.5740827903, alpha: 1)){
            (sender: MGSwipeTableCell!) -> Bool in
                let lineView = UIView(frame: CGRect(x: 0, y: cell.contentView.bounds.size.height/2, width: cell.contentView.bounds.size.width, height: 5))
                lineView.backgroundColor = UIColor.lightGray
                lineView.autoresizingMask = UIViewAutoresizing(rawValue: 0x3f)
                cell.contentView.addSubview(lineView)
            return true
            
            }]
        cell.leftSwipeSettings.transition = .drag
        
        //configure right buttons
        cell.rightButtons =
            [MGSwipeButton(title: "Delete", backgroundColor: #colorLiteral(red: 0.9606611037, green: 0.2751472445, blue: 0.2812705144, alpha: 1)) {
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
//            },
//             
//            MGSwipeButton(title: "Move",backgroundColor: .lightGray){
//                (sender: MGSwipeTableCell!) -> Bool in
//                //Move
//                tableView.isEditing = !tableView.isEditing
//                
//
//                (UIApplication.shared.delegate as! AppDelegate).saveContext()
//                
//                print("Editing")
//                return true
//            
                }]
        cell.rightSwipeSettings.transition = .drag
        cell.layer.cornerRadius = cell.frame.height/2
        cell.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        cell.clipsToBounds = true
        cell.swipeBackgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        cell.selectionStyle = .none
        
        //cell separator
        let maskLayer = CAShapeLayer()
        let bounds = cell.bounds
        maskLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height-4), cornerRadius: 100).cgPath
        cell.layer.mask = maskLayer
        
        let todo = toDoItems[indexPath.row]
        let task = todo.value(forKeyPath: "task")
        let time = todo.value(forKey: "time")
        
        switch customSegmentedControl.selectedSegmentIndex {
        case 0:
            cell.textLabel?.text = task as? String
            cell.detailTextLabel?.text = time as? String
        case 1:
            cell.textLabel?.text = task as? String
            cell.detailTextLabel?.text = time as? String
        case 2:
            cell.textLabel?.text = task as? String
            cell.detailTextLabel?.text = time as? String
        default:
            break
        }
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = toDoItems[sourceIndexPath.row]
        toDoItems.remove(at: sourceIndexPath.row)
        toDoItems.insert(item, at: destinationIndexPath.row)
        //save move in core data
        
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    // MARK: - Table view delegate

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        cell.layer.cornerRadius = 60
        cell.layoutMargins = UIEdgeInsets.init(top: 50, left: 50, bottom: 50, right: 50)
        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 21.0)
        
        cell.detailTextLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.detailTextLabel?.textAlignment = .natural
        cell.detailTextLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 10.0)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}

