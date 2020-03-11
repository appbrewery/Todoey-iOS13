//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Paola Castro on 3/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Itema]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    // MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedCategory = categories[tableView.indexPathForSelectedRow!.row]
        let destination = segue.destination as! TodoListViewController
        destination.selectedCategory = selectedCategory
    }
    
    // MARK: - Add new categories
    @IBAction func categoryPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        var alertTextField = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            let newCategory = Category(context: self.context)
            newCategory.name = alertTextField.text!
            self.categories.append(newCategory)
            self.saveCategories()
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

    func saveCategories() {
        do {
            try context.save()
        } catch  {
            print("saving: \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            try categories = context.fetch(request)
        } catch  {
            print("loading: \(error)")
        }
        tableView.reloadData()
    }

}
