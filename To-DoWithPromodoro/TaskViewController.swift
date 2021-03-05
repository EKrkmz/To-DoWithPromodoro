//
//  TaskViewController.swift
//  To-DoWithPromodoro
//
//  Created by MYMACBOOK on 13.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    var category: Category!
    var categoryName: String!
    var taskList = [Task]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = category.category_name
        
        categoryName = category.category_name
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func addButton(_ sender: Any) {
        if let t = textField.text {
            let task = Task(context: managedObjectContext)
            task.task_name = t
            task.category = category
            task.task_done = false
        }
        textField.text = ""
        saveContext()
    }
    
    //MARK: - Navigation
    @IBAction func unwind(_ seg: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        
        if segue.identifier == "toUpdateTask" {
            let controller = segue.destination as! TaskUpdateViewController
            controller.task = taskList[index!]
            controller.managedObjectContext = managedObjectContext
        }
        
        if segue.identifier == "toComp" {
            let controller = segue.destination as! CompViewController
            controller.managedObjectContext = managedObjectContext
        }
    }
    
    //MARK:- Core Data Methods
    func fetchTasks() {
        let fetchReq: NSFetchRequest<Task> = Task.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "(category.category_name MATCHES %@) AND (task_done == %@)", categoryName, NSNumber(value: false))
        
        do {
           taskList = try managedObjectContext.fetch(fetchReq)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
        fetchTasks()
        tableView.reloadData()
    }
}

//MARK: - Table View Delegate Methods
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        cell.labeltask.text = task.task_name

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = taskList[indexPath.row]
      
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: {
            (contextualAction, view, boolValue) in
            
            let task = self.taskList[indexPath.row]
            self.managedObjectContext.delete(task)
            self.saveContext()
        })
        
        delete.image = UIImage(named: "deleteWhite")
        
        let update = UIContextualAction(style: .normal, title: "Update", handler: {
            (contextualAction, view, boolValue) in
            
            self.performSegue(withIdentifier: "toUpdateTask", sender: indexPath.row)
        })
        
        update.backgroundColor = UIColor(red: 197/255, green: 137/255, blue: 255/255, alpha: 1)
        
        let complete = UIContextualAction(style: .normal, title: "Done", handler: {
            (contextualAction, view, boolValue) in
        
            task.task_done = true
            self.saveContext()
        })
        
        complete.backgroundColor = UIColor(red: 134/255, green: 194/255, blue: 156/255, alpha: 1)
        complete.image = UIImage(named: "checkmarkWhite")
        
        return UISwipeActionsConfiguration(actions: [delete, complete, update])
    }
}
