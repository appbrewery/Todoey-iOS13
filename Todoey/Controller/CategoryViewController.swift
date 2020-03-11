//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Paola Castro on 3/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {
    var categories: [String] = ["app", "interview", "excercise", "car"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    // MARK: - TableView Delegate methods
    
    // MARK: - Add new categories
    @IBAction func categoryPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        var alertTextField = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//
//            let newItem = Itema(context: self.context)
//            newItem.name = alertTextField.text!
//            newItem.done = false
            self.categories.append(alertTextField.text!)
            
            self.tableView.reloadData()
        }
        alert.addTextField { (textField) in
            alertTextField = textField
            alertTextField.placeholder = "Type category"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Data Manipulation




    
}
