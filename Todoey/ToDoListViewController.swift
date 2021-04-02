//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let todo = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell, for: indexPath)
        
        cell.textLabel?.text = todo
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            // if it already has a checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            // if it doesn't have a checkmark 
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //To create an animation of deselection
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

