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

    func updateWatchData() {
        let allTodoTitles: [String] = Todo.getSortedTodoTitles()
        let context: [String: [String]] = ["Todos": allTodoTitles ]
        WatchSessionManager.shared.update(context: context)
    }

    @objc func fetchData() {
        do {
            self.refreshControl?.beginRefreshing()
            try self.fetchedResultsController.performFetch()

            self.updateWatchData()
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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete,
            let todo = self.fetchedResultsController.fetchedObjects?[indexPath.row],
            let id = todo.id else {
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let newMoc = appDelegate.persistentContainer.newBackgroundContext()
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            guard let objectInNewMoc = try newMoc.fetch(fetchRequest).first else {
                return
            }
            newMoc.delete(objectInNewMoc)
            try newMoc.save()
        } catch let error {
            print(error)
        }
        self.updateWatchData()
    }
}

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
        self.updateWatchData()
    }
}
