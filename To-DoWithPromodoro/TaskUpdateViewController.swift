//
//  TaskUpdateViewController.swift
//  To-DoWithPromodoro
//
//  Created by MYMACBOOK on 13.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit
import CoreData

class TaskUpdateViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    var task: Task?
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        
        if let t = task {
            textField.text = t.task_name
        }
    }
    
    @IBAction func ok(_ sender: Any) {
       performSegue(withIdentifier: "updateToTask", sender: self)
        
        if let t = task, let tf = textField.text {
            t.task_name = tf
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
