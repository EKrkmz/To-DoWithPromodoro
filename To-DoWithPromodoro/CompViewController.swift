//
//  CompViewController.swift
//  To-DoWithPromodoro
//
//  Created by MYMACBOOK on 1.03.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit
import CoreData

class CompViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var managedObjectContext: NSManagedObjectContext!
    var taskList = [Task]()
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTasks()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tasarim : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let genislik = self.collectionView.frame.size.width
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let hucreGenislik = (genislik-30)/2
        tasarim.itemSize = CGSize(width: hucreGenislik, height: hucreGenislik)
        tasarim.minimumInteritemSpacing = 10
        tasarim.minimumLineSpacing = 10
        collectionView.collectionViewLayout = tasarim
    }
    
    func fetchTasks() {
         do {
             let fetchReq: NSFetchRequest<Task> = Task.fetchRequest()
             fetchReq.predicate = NSPredicate(format: "task_done == %@ ", NSNumber(value: true))
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
     }
}

extension CompViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        taskList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let task = taskList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "compCell", for: indexPath) as! CompCollectionViewCell
        
        cell.labelCategory.text = task.category?.category_name
        cell.labelTask.text = task.task_name
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        
        return cell
    }
}
