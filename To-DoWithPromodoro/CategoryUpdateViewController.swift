//
//  CategoryUpdateViewController.swift
//  To-DoWithPromodoro
//
//  Created by MYMACBOOK on 13.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit
import CoreData

class CategoryUpdateViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    var category: Category?
    var managedObjectContex: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        
        if let c = category {
            textField.text = c.category_name
        }
    }
    
    @IBAction func ok(_ sender: Any) {
        performSegue(withIdentifier: "updateToCategory", sender: self)
        
        if let c = category, let tf = textField.text {
            c.category_name = tf
            
            do {
                try managedObjectContex.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
