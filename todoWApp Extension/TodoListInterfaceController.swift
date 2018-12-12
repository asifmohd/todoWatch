//
//  InterfaceController.swift
//  todoWApp Extension
//
//  Created by Asif on 11/12/18.
//  Copyright © 2018 Asif. All rights reserved.
//

import WatchKit
import Foundation


class TodoListInterfaceController: WKInterfaceController {

    @IBOutlet weak var todoTable: WKInterfaceTable!

    var allTodos: [String] = [] {
        didSet {
            reloadTable()
        }
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        WatchSessionManager.shared.startSession()

        WatchSessionManager.shared.addDataSourceChangedDelegate(delegate: self)
    }

    func reloadTable() {
        self.todoTable.setNumberOfRows(self.allTodos.count, withRowType: "TodoRow")
        for index in 0..<self.todoTable.numberOfRows {
            guard let row = self.todoTable.rowController(at: index) as? TodoRow else {
                continue
            }
            row.todoItem = self.allTodos[index]
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        WatchSessionManager.shared.removeDataSourceChangedDelegate(delegate: self)
        super.didDeactivate()
    }

}

extension TodoListInterfaceController: DataSourceChangedDelegate {
    func dataSourceDidUpdate(dataSource: [String : [String]]) {
        self.allTodos = dataSource["Todos"]!
    }
}
