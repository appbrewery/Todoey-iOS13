//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
        
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let todo = itemArray[indexPath.row].title
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell, for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = todo

        //Turnary Expression
        cell.accessoryType = item.done ? .checkmark : .none

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Make it the opposite
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //To create an animation of deselection
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a New To Do Item", message: "This is a message", preferredStyle: .alert)
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            //Passing reference, so that the bubble is now pointing to a more global textfield rather than the one in the closure
        }
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //New way of initialising Items
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
        //Have to let Swift know the data type <>
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
}


