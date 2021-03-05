//
//  ViewController.swift
//  To-DoWithPromodoro
//
//  Created by MYMACBOOK on 13.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var categoryList = [Category]()
    var managedObjectContext: NSManagedObjectContext!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.tintColor = .purple
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchCategories()
        tableView.reloadData()
    }
    
    @IBAction func addCategoryButton(_ sender: Any) {
        if let t = textField.text {
            let category = Category(context: managedObjectContext)
            category.category_name = t
        }
        textField.text = ""
        saveContext()
        fetchCategories()
        tableView.reloadData()
    }
    
    //MARK: - Core Data Methods
    func fetchCategories() {
        do {
            categoryList = try managedObjectContext.fetch(Category.fetchRequest())
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
    }
    
    //MARK: - Navigation
    @IBAction func unwind(_ seg: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        
        if segue.identifier == "toTasks" {
            let controller = segue.destination as! TaskViewController
            controller.category = categoryList[index!]
            controller.managedObjectContext = managedObjectContext
        }
    
        if segue.identifier == "toCategoryUpdate" {
            let controller = segue.destination as! CategoryUpdateViewController
            controller.category = categoryList[index!]
            controller.managedObjectContex = managedObjectContext
        }
    }
}

//MARK: - Table View Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categoryList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        cell.labelCategory.text = category.category_name
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toTasks", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: {
            (contextualAction, view, boolValue) in
            
            let category = self.categoryList[indexPath.row]
            self.managedObjectContext.delete(category)
            
            self.saveContext()
            self.fetchCategories()
            tableView.reloadData()
        })
        
        delete.image = UIImage(named: "deleteWhite")
        
        let update = UIContextualAction(style: .normal, title: "Update", handler: {
            (contextualAction, view, boolValue) in
            
            self.performSegue(withIdentifier: "toCategoryUpdate", sender: indexPath.row)
        })
        
        update.backgroundColor = UIColor(red: 197/255, green: 137/255, blue: 255/255, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [delete, update])
    }
}
