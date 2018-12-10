//
//  AddTodoViewController.swift
//  todoWatch
//
//  Created by Asif on 10/12/18.
//  Copyright © 2018 Asif. All rights reserved.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.titleTextField.becomeFirstResponder()
    }

    @IBAction func doneTapped(_ sender: Any) {
        guard let titleText = self.titleTextField.text,
            titleText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0 else {
            return
        }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let newMoc = appDelegate.persistentContainer.newBackgroundContext()
        let newTodoObj = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: newMoc) as! Todo
        newTodoObj.title = titleText
        newTodoObj.id = UUID().uuidString
        newTodoObj.createdAt = Date()
        newTodoObj.completed = false

        do {
            try newMoc.save()
        } catch let error {
            print(error)
        }

        self.navigationController?.popViewController(animated: true)
    }
    
}
