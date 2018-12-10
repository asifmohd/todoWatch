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
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)

        self.setupFetchedResultsController()
        self.fetchData()
    }

    func setupFetchedResultsController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.persistentContainer.viewContext
        moc.automaticallyMergesChangesFromParent = true
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController<Todo>(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
    }

    @objc func fetchData() {
        do {
            self.refreshControl?.beginRefreshing()
            try self.fetchedResultsController.performFetch()
        } catch let error {
            print(error)
        }
        self.refreshControl?.endRefreshing()
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

@objc
extension TodoListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .none)
        case .move:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
