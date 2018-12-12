//
//  Todo+CoreDataClass.swift
//  todoWatch
//
//  Created by Asif on 10/12/18.
//  Copyright © 2018 Asif. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Todo)
public class Todo: NSManagedObject {

    static func getSortedTodoTitles() -> [String] {
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.persistentContainer.viewContext
        do {
            let allTodos = try moc.fetch(fetchRequest)
            return allTodos.compactMap({ $0.title })
        } catch let error {
            print("Error occurred while fetching \(error.localizedDescription)")
        }
        return []
    }
}
