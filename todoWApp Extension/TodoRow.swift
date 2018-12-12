//
//  TodoRow.swift
//  todoWApp Extension
//
//  Created by Asif on 12/12/18.
//  Copyright © 2018 Asif. All rights reserved.
//

import WatchKit

class TodoRow: NSObject {
    var todoItem: String? {
        didSet {
            self.titleLabel.setText(todoItem)
        }
    }

    @IBOutlet weak var titleLabel: WKInterfaceLabel!
}
