//
//  ViewController.swift
//  todoWatch
//
//  Created by Asif on 10/12/18.
//  Copyright © 2018 Asif. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var fetchedResultsController: NSFetchedResultsController<Todo>!

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "TodoTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "TodoTableViewCell")

        self.setupFetchedResultsController()
    }

    func setupFetchedResultsController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController<Todo>(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        let todo = self.fetchedResultsController.fetchedObjects?[indexPath.row]
        cell.titleLabel.text = todo?.title
        return cell
    }
}
